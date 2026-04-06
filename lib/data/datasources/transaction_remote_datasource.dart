import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/firestore_paths.dart';
import '../models/transaction_model.dart';
import '../models/transaction_item_model.dart';

/// Firestore data source for Transactions
class TransactionRemoteDatasource {
  final FirebaseFirestore _firestore;

  TransactionRemoteDatasource(this._firestore);

  /// Retry helper with exponential backoff for Firestore operations
  Future<T> _retryOperation<T>(Future<T> Function() operation, {int maxRetries = 3}) async {
    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        return await operation().timeout(const Duration(seconds: 30));
      } on FirebaseException catch (e) {
        if (e.code == 'unavailable' && attempt < maxRetries - 1) {
          // Exponential backoff: 1s, 2s, 4s
          await Future.delayed(Duration(seconds: 1 << attempt));
          continue;
        }
        rethrow;
      } on TimeoutException {
        if (attempt < maxRetries - 1) {
          await Future.delayed(Duration(seconds: 1 << attempt));
          continue;
        }
        throw FirebaseException(
          plugin: 'cloud_firestore',
          code: 'timeout',
          message: 'Kết nối quá thời gian. Vui lòng kiểm tra mạng và thử lại.',
        );
      }
    }
    throw FirebaseException(
      plugin: 'cloud_firestore',
      code: 'unavailable',
      message: 'Không thể kết nối đến máy chủ sau nhiều lần thử. Vui lòng kiểm tra mạng.',
    );
  }

  CollectionReference get _txCollection =>
      _firestore.collection(FirestorePaths.transactions);

  CollectionReference get _invCollection =>
      _firestore.collection(FirestorePaths.inventory);

  CollectionReference get _custCollection =>
      _firestore.collection(FirestorePaths.customers);

  /// Convert warehouse display name to Firestore storage key
  String _toLocationKey(String warehouseLocation) =>
      AppConstants.getLocationKey(warehouseLocation);

  /// Create export order with atomic batch write
  Future<String> createExportOrder({
    required TransactionModel transaction,
    required List<TransactionItemModel> items,
  }) async {
    final batch = _firestore.batch();
    final txDocRef = _txCollection.doc();
    final txId = txDocRef.id;
    final locationKey = _toLocationKey(transaction.warehouseLocation);

    // 1. Create transaction document
    final txData = transaction.toJson()..remove('id');
    batch.set(txDocRef, txData);

    // 2. Create item sub-documents with price snapshots
    for (final item in items) {
      final itemRef = txDocRef.collection(FirestorePaths.transactionItems).doc();
      final itemData = item.toJson()..remove('id');
      batch.set(itemRef, itemData);
    }

    // 3. Update inventory (decrease stock at location)
    // Use nested map (NOT dot notation) with set+merge to correctly update nested fields
    for (final item in items) {
      final invRef = _invCollection.doc(item.productId);
      batch.set(
        invRef,
        {
          'product_id': item.productId,
          'product_name': item.productName,
          'stock_by_location': {
            locationKey: FieldValue.increment(-item.quantity),
          },
          'total_quantity': FieldValue.increment(-item.quantity),
          'last_updated': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    }

    // 4. Create debt record if applicable
    if (transaction.isDebt && transaction.customerId != null) {
      final unpaid = transaction.totalValue - transaction.paidAmount;
      final debtRef = _custCollection
          .doc(transaction.customerId)
          .collection(FirestorePaths.debtRecords)
          .doc();
      batch.set(debtRef, {
        'transaction_id': txId,
        'type': 'debt',
        'amount': unpaid,
        'running_balance': 0, // Will be calculated read-side
        'note': 'Ghi nợ đơn xuất #$txId',
        'created_at': FieldValue.serverTimestamp(),
      });

      // 5. Update customer total_debt
      batch.update(_custCollection.doc(transaction.customerId), {
        'total_debt': FieldValue.increment(unpaid),
        'updated_at': FieldValue.serverTimestamp(),
      });
    }

    await _retryOperation(() => batch.commit());
    return txId;
  }

  /// Create import order with atomic batch write
  Future<String> createImportOrder({
    required TransactionModel transaction,
    required List<TransactionItemModel> items,
  }) async {
    final batch = _firestore.batch();
    final txDocRef = _txCollection.doc();
    final txId = txDocRef.id;
    final locationKey = _toLocationKey(transaction.warehouseLocation);

    // 1. Create transaction
    final txData = transaction.toJson()..remove('id');
    batch.set(txDocRef, txData);

    // 2. Create items
    for (final item in items) {
      final itemRef = txDocRef.collection(FirestorePaths.transactionItems).doc();
      final itemData = item.toJson()..remove('id');
      batch.set(itemRef, itemData);
    }

    // 3. Update inventory (increase stock at location)
    // Use nested map (NOT dot notation) with set+merge to correctly update nested fields
    for (final item in items) {
      final invRef = _invCollection.doc(item.productId);
      batch.set(
        invRef,
        {
          'product_id': item.productId,
          'product_name': item.productName,
          'stock_by_location': {
            locationKey: FieldValue.increment(item.quantity),
          },
          'total_quantity': FieldValue.increment(item.quantity),
          'last_updated': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    }

    await _retryOperation(() => batch.commit());
    return txId;
  }

  /// Get transaction history with optional filters
  Future<List<TransactionModel>> getTransactionHistory({
    DateTime? startDate,
    DateTime? endDate,
    String? type,
    String? warehouseLocation,
  }) async {
    Query query = _txCollection.orderBy('created_at', descending: true);

    if (type != null) {
      query = query.where('type', isEqualTo: type);
    }
    if (warehouseLocation != null) {
      query = query.where('warehouse_location', isEqualTo: warehouseLocation);
    }
    if (startDate != null) {
      query = query.where('created_at', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
    }
    if (endDate != null) {
      query = query.where('created_at', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((d) => TransactionModel.fromFirestore(d))
        .toList();
  }

  /// Get transaction with items
  Future<(TransactionModel, List<TransactionItemModel>)> getTransactionWithItems(
    String id,
  ) async {
    final txDoc = await _txCollection.doc(id).get();
    final tx = TransactionModel.fromFirestore(txDoc);

    final itemsSnap = await _txCollection
        .doc(id)
        .collection(FirestorePaths.transactionItems)
        .get();
    final items = itemsSnap.docs
        .map((d) => TransactionItemModel.fromFirestore(d))
        .toList();

    return (tx, items);
  }

  /// Get transaction history with cursor-based pagination
  Future<(List<TransactionModel>, DocumentSnapshot?)> getTransactionHistoryPaginated({
    DateTime? startDate,
    DateTime? endDate,
    String? type,
    String? warehouseLocation,
    int limit = 20,
    DocumentSnapshot? startAfter,
  }) async {
    Query query = _txCollection.orderBy('created_at', descending: true);

    if (type != null) {
      query = query.where('type', isEqualTo: type);
    }
    if (warehouseLocation != null) {
      query = query.where('warehouse_location', isEqualTo: warehouseLocation);
    }
    if (startDate != null) {
      query = query.where('created_at', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
    }
    if (endDate != null) {
      query = query.where('created_at', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
    }

    query = query.limit(limit);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    final snapshot = await query.get();
    final models = snapshot.docs
        .map((d) => TransactionModel.fromFirestore(d))
        .toList();
    final lastDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

    return (models, lastDoc);
  }
}
