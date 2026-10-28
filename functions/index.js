const {randomUUID} = require('node:crypto');
const {initializeApp} = require('firebase-admin/app');
const {getAuth} = require('firebase-admin/auth');
const {getMessaging} = require('firebase-admin/messaging');
const {onDocumentWritten, onDocumentCreated} = require('firebase-functions/v2/firestore');
const {onRequest} = require('firebase-functions/v2/https');
const logger = require('firebase-functions/logger');

initializeApp();

const REGION = 'asia-southeast1';
const TOPIC = 'warehouse_activity';

function safeName(value) {
  return typeof value === 'string' ? value.trim().slice(0, 80) : '';
}

function changed(before, after, fields) {
  return fields.some((field) => JSON.stringify(before[field]) !== JSON.stringify(after[field]));
}

async function broadcast(title, body, path, eventId) {
  await getMessaging().send({
    topic: TOPIC,
    data: {
      title,
      body,
      path,
      eventId: eventId || randomUUID(),
    },
    webpush: {headers: {Urgency: 'high'}},
  });
}

function documentChange(event) {
  return {
    before: event.data?.before?.data(),
    after: event.data?.after?.data(),
  };
}

exports.notifyTransactionChange = onDocumentWritten(
  {document: 'transactions/{transactionId}', region: REGION},
  async (event) => {
    const {before, after} = documentChange(event);
    // Hard deletes are used by bulk reset. That operation sends one summary.
    if (!after) return;
    const type = after.type === 'nhap' ? 'nhập kho' : 'xuất kho';
    if (!before) {
      await broadcast(
        `Có phiếu ${type} mới`,
        `Một phiếu ${type} vừa được tạo${safeName(after.warehouse_location) ? ` tại ${safeName(after.warehouse_location)}` : ''}.`,
        '/journal',
        event.id,
      );
      return;
    }
    if (!changed(before, after, [
      'type', 'customer_name', 'warehouse_location', 'total_quantity',
      'total_value', 'paid_amount', 'is_debt', 'note', 'items_summary',
    ])) return;
    await broadcast(
      `Đã chỉnh sửa phiếu ${type}`,
      `Thông tin phiếu ${type} vừa được cập nhật.`,
      '/journal',
      event.id,
    );
  },
);

exports.notifyReconciliation = onDocumentCreated(
  {document: 'reconciliations/{reconciliationId}', region: REGION},
  async (event) => {
    if (!event.data) return;
    await broadcast(
      'Đã kiểm kho',
      'Một lượt kiểm kho vừa được ghi nhận. Xem tồn kho để kiểm tra kết quả.',
      '/inventory',
      event.id,
    );
  },
);

function catalogNotifier(collection, label, path, relevantFields) {
  return onDocumentWritten(
    {document: `${collection}/{documentId}`, region: REGION},
    async (event) => {
      const {before, after} = documentChange(event);
      // Bulk hard deletes are summarized by notifyDataReset below.
      if (!after) return;
      const deleted = before && before.is_active !== false && after.is_active === false;
      if (deleted) {
        await broadcast(`Đã xóa ${label}`, `Một ${label} vừa được xóa.`, path, event.id);
        return;
      }
      if (after.is_active === false) return;
      if (!before) {
        await broadcast(`Đã thêm ${label}`, `Một ${label} mới vừa được thêm.`, path, event.id);
        return;
      }
      if (!changed(before, after, relevantFields)) return;
      await broadcast(`Đã chỉnh sửa ${label}`, `Thông tin ${label} vừa được cập nhật.`, path, event.id);
    },
  );
}

exports.notifyProductChange = catalogNotifier(
  'products', 'sản phẩm', '/catalog/products',
  ['name', 'unit', 'category', 'regulation_class', 'import_price', 'export_price'],
);
exports.notifyCustomerChange = catalogNotifier(
  'customers', 'khách hàng', '/catalog/customers',
  ['name', 'phone', 'type'],
);
exports.notifyWarehouseChange = catalogNotifier(
  'warehouses', 'kho hàng', '/warehouses',
  ['name', 'address', 'area', 'capacity', 'notes'],
);
exports.notifyFormulaChange = catalogNotifier(
  'product_formulas', 'công thức', '/catalog/formulas',
  ['product_id', 'product_name', 'components', 'labor_cost', 'notes'],
);

function validToken(value) {
  return typeof value === 'string' && value.length >= 40 && value.length <= 4096;
}

exports.webPush = onRequest(
  {region: REGION, cors: true, invoker: 'public', maxInstances: 10},
  async (request, response) => {
    if (request.method !== 'POST') {
      response.status(405).json({error: 'method-not-allowed'});
      return;
    }
    const match = /^Bearer (.+)$/.exec(request.get('authorization') || '');
    if (!match) {
      response.status(401).json({error: 'authentication-required'});
      return;
    }
    let user;
    try {
      user = await getAuth().verifyIdToken(match[1]);
    } catch (_) {
      response.status(401).json({error: 'invalid-authentication'});
      return;
    }

    const {action, token} = request.body || {};
    try {
      if (action === 'subscribe' || action === 'unsubscribe') {
        if (!validToken(token)) {
          response.status(400).json({error: 'invalid-token'});
          return;
        }
        const result = action === 'subscribe'
          ? await getMessaging().subscribeToTopic(token, TOPIC)
          : await getMessaging().unsubscribeFromTopic(token, TOPIC);
        if (result.failureCount > 0) {
          response.status(400).json({error: 'topic-subscription-failed'});
          return;
        }
        response.json({ok: true});
        return;
      }
      if (action === 'test') {
        if (!validToken(token)) {
          response.status(400).json({error: 'invalid-token'});
          return;
        }
        await getMessaging().send({
          token,
          data: {
            title: 'Thông báo thử',
            body: 'Web Push đã hoạt động trên trình duyệt này.',
            path: '/journal',
            eventId: randomUUID(),
          },
        });
        response.json({ok: true});
        return;
      }
      if (action === 'data-reset') {
        const allowed = new Set(['products', 'inventory', 'transactions', 'customers', 'checklists']);
        const counts = request.body?.counts;
        if (!counts || typeof counts !== 'object' || Array.isArray(counts) ||
            Object.keys(counts).some((key) => !allowed.has(key) ||
              !Number.isInteger(counts[key]) || counts[key] < 0 || counts[key] > 1000000)) {
          response.status(400).json({error: 'invalid-counts'});
          return;
        }
        const total = Object.values(counts).reduce((sum, count) => sum + count, 0);
        if (total === 0) {
          response.json({ok: true});
          return;
        }
        await broadcast(
          'Đã xóa dữ liệu',
          `${total} bản ghi đã được xóa khỏi ứng dụng.`,
          '/settings',
          randomUUID(),
        );
        logger.info('Data reset notification sent', {uid: user.uid, counts});
        response.json({ok: true});
        return;
      }
      response.status(400).json({error: 'invalid-action'});
    } catch (error) {
      logger.error('Web Push request failed', {action, uid: user.uid, error});
      response.status(500).json({error: 'push-service-unavailable'});
    }
  },
);
