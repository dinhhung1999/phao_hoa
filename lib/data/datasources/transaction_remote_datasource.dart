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
    // Store total quantity and items summary for quick display in list
    txData['total_quantity'] = items.fold<int>(0, (s, item) => s + item.quantity);
    txData['items_summary'] = items.map((item) => {
      'name': item.productName,
      'qty': item.quantity,
      'price': item.unitPriceAtTime,
    }).toList();
    // Store product IDs array for efficient querying without collection group index
    txData['product_ids'] = items.map((item) => item.productId).toSet().toList();
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
    // Store total quantity and items summary for quick display in list
    txData['total_quantity'] = items.fold<int>(0, (s, item) => s + item.quantity);
    txData['items_summary'] = items.map((item) => {
      'name': item.productName,
      'qty': item.quantity,
      'price': item.unitPriceAtTime,
    }).toList();
    // Store product IDs array for efficient querying without collection group index
    txData['product_ids'] = items.map((item) => item.productId).toSet().toList();
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
  /// Note: type and warehouse filters are applied client-side to avoid
  /// needing Firestore composite indexes (which require manual deployment).
  /// Only date range uses Firestore where clauses (same field as orderBy).
  Future<List<TransactionModel>> getTransactionHistory({
    DateTime? startDate,
    DateTime? endDate,
    String? type,
    String? warehouseLocation,
  }) async {
    Query query = _txCollection.orderBy('created_at', descending: true);

    // Date range filters work with single-field index on created_at
    if (startDate != null) {
      query = query.where('created_at', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
    }
    if (endDate != null) {
      query = query.where('created_at', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
    }

    final snapshot = await query.get();
    var models = snapshot.docs
        .map((d) => TransactionModel.fromFirestore(d))
        .toList();

    // Client-side filtering for type and warehouse
    // to avoid Firestore composite index requirement
    if (type != null) {
      models = models.where((m) => m.type == type).toList();
    }
    if (warehouseLocation != null) {
      models = models.where((m) => m.warehouseLocation == warehouseLocation).toList();
    }

    return models;
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
  /// Note: type and warehouse filters are applied client-side to avoid
  /// needing Firestore composite indexes. Fetches extra documents when
  /// client-side filtering is active to compensate for filtered-out items.
  Future<(List<TransactionModel>, DocumentSnapshot?)> getTransactionHistoryPaginated({
    DateTime? startDate,
    DateTime? endDate,
    String? type,
    String? warehouseLocation,
    int limit = 20,
    DocumentSnapshot? startAfter,
  }) async {
    Query query = _txCollection.orderBy('created_at', descending: true);

    // Date range filters work with single-field index on created_at
    if (startDate != null) {
      query = query.where('created_at', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
    }
    if (endDate != null) {
      query = query.where('created_at', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
    }

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    // When client-side filtering is needed, fetch more documents
    // to compensate for items that will be filtered out
    final needsClientFilter = type != null || warehouseLocation != null;
    final fetchLimit = needsClientFilter ? limit * 5 : limit;
    query = query.limit(fetchLimit);

    final snapshot = await query.get();
    var models = snapshot.docs
        .map((d) => TransactionModel.fromFirestore(d))
        .toList();

    // Client-side filtering for type and warehouse
    // to avoid Firestore composite index requirement
    if (type != null) {
      models = models.where((m) => m.type == type).toList();
    }
    if (warehouseLocation != null) {
      models = models.where((m) => m.warehouseLocation == warehouseLocation).toList();
    }

    final lastDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

    return (models, lastDoc);
  }

  /// Update debt payment for a transaction
  /// Updates paid_amount, recalculates is_debt, and adjusts customer total_debt
  Future<void> updateDebtPayment({
    required String transactionId,
    required double newPaidAmount,
    required double totalValue,
    String? customerId,
    required double previousPaidAmount,
  }) async {
    final batch = _firestore.batch();
    final txRef = _txCollection.doc(transactionId);

    final isFullyPaid = newPaidAmount >= totalValue;

    // 1. Update transaction
    batch.update(txRef, {
      'paid_amount': newPaidAmount,
      'is_debt': !isFullyPaid,
    });

    // 2. Update customer total_debt if this is a customer order
    if (customerId != null && customerId.isNotEmpty) {
      final debtDiff = previousPaidAmount - newPaidAmount; // positive = more debt
      if (debtDiff != 0) {
        batch.update(_custCollection.doc(customerId), {
          'total_debt': FieldValue.increment(debtDiff),
          'updated_at': FieldValue.serverTimestamp(),
        });
      }
    }

    await _retryOperation(() => batch.commit());
  }

  /// Get transactions that contain a specific product.
  /// Uses array-contains on the denormalized 'product_ids' field.
  /// Falls back to scanning items_summary for older transactions
  /// that don't have the product_ids field yet.
  Future<List<TransactionModel>> getTransactionsByProductId(
    String productId, {
    int limit = 20,
  }) async {
    // Primary query: use array-contains on product_ids
    // Note: no orderBy to avoid needing a composite index; sort client-side
    final snapshot = await _txCollection
        .where('product_ids', arrayContains: productId)
        .limit(limit * 2)
        .get();

    final results = snapshot.docs
        .map((d) => TransactionModel.fromFirestore(d))
        .toList();

    // Sort client-side by date descending
    results.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // If we got enough results, return them
    if (results.length >= limit) {
      return results;
    }

    // Fallback: for older transactions that don't have product_ids,
    // scan recent transactions and check their items subcollections
    final fallbackSnapshot = await _txCollection
        .orderBy('created_at', descending: true)
        .limit(100)
        .get();

    final existingIds = results.map((r) => r.id).toSet();

    for (final doc in fallbackSnapshot.docs) {
      if (existingIds.contains(doc.id)) continue;

      final data = doc.data() as Map<String, dynamic>?;
      // Skip if this doc already has product_ids (already checked above)
      if (data != null && data.containsKey('product_ids')) continue;

      // Check items subcollection
      final itemsSnap = await doc.reference
          .collection(FirestorePaths.transactionItems)
          .where('product_id', isEqualTo: productId)
          .limit(1)
          .get();

      if (itemsSnap.docs.isNotEmpty) {
        results.add(TransactionModel.fromFirestore(doc));
        if (results.length >= limit) break;
      }
    }

    // Sort by date desc
    results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return results.take(limit).toList();
  }

  /// Update an existing transaction (edit within 24h).
  ///
  /// Atomically:
  /// 1. Reverse old inventory adjustments
  /// 2. Delete old item sub-documents
  /// 3. Update transaction document with new data
  /// 4. Create new item sub-documents
  /// 5. Apply new inventory adjustments
  Future<void> updateTransaction({
    required String transactionId,
    required TransactionModel oldTransaction,
    required List<TransactionItemModel> oldItems,
    required TransactionModel newTransaction,
    required List<TransactionItemModel> newItems,
  }) async {
    final batch = _firestore.batch();
    final txDocRef = _txCollection.doc(transactionId);
    final isExport = oldTransaction.type == 'xuat';
    final oldLocationKey = _toLocationKey(oldTransaction.warehouseLocation);
    final newLocationKey = _toLocationKey(newTransaction.warehouseLocation);

    // 1. Reverse old inventory adjustments
    for (final item in oldItems) {
      final invRef = _invCollection.doc(item.productId);
      if (isExport) {
        // Was export (decreased stock) → add back
        batch.set(invRef, {
          'stock_by_location': {
            oldLocationKey: FieldValue.increment(item.quantity),
          },
          'total_quantity': FieldValue.increment(item.quantity),
          'last_updated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } else {
        // Was import (increased stock) → subtract back
        batch.set(invRef, {
          'stock_by_location': {
            oldLocationKey: FieldValue.increment(-item.quantity),
          },
          'total_quantity': FieldValue.increment(-item.quantity),
          'last_updated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    }

    // 2. Delete old item sub-documents
    final oldItemsSnap = await txDocRef
        .collection(FirestorePaths.transactionItems)
        .get();
    for (final doc in oldItemsSnap.docs) {
      batch.delete(doc.reference);
    }

    // 3. Update transaction document
    final txData = newTransaction.toJson()..remove('id');
    txData['total_quantity'] = newItems.fold<int>(0, (s, item) => s + item.quantity);
    txData['items_summary'] = newItems.map((item) => {
      'name': item.productName,
      'qty': item.quantity,
      'price': item.unitPriceAtTime,
    }).toList();
    txData['product_ids'] = newItems.map((item) => item.productId).toSet().toList();
    txData['updated_at'] = FieldValue.serverTimestamp();
    batch.update(txDocRef, txData);

    // 4. Create new item sub-documents
    for (final item in newItems) {
      final itemRef = txDocRef.collection(FirestorePaths.transactionItems).doc();
      final itemData = item.toJson()..remove('id');
      batch.set(itemRef, itemData);
    }

    // 5. Apply new inventory adjustments
    for (final item in newItems) {
      final invRef = _invCollection.doc(item.productId);
      if (isExport) {
        // Export → decrease stock
        batch.set(invRef, {
          'product_id': item.productId,
          'product_name': item.productName,
          'stock_by_location': {
            newLocationKey: FieldValue.increment(-item.quantity),
          },
          'total_quantity': FieldValue.increment(-item.quantity),
          'last_updated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } else {
        // Import → increase stock
        batch.set(invRef, {
          'product_id': item.productId,
          'product_name': item.productName,
          'stock_by_location': {
            newLocationKey: FieldValue.increment(item.quantity),
          },
          'total_quantity': FieldValue.increment(item.quantity),
          'last_updated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    }

    // 6. Handle debt changes if applicable
    if (oldTransaction.isDebt && oldTransaction.customerId != null) {
      final oldUnpaid = oldTransaction.totalValue - oldTransaction.paidAmount;
      // Reverse old debt
      batch.update(_custCollection.doc(oldTransaction.customerId!), {
        'total_debt': FieldValue.increment(-oldUnpaid),
        'updated_at': FieldValue.serverTimestamp(),
      });
    }
    if (newTransaction.isDebt && newTransaction.customerId != null) {
      final newUnpaid = newTransaction.totalValue - newTransaction.paidAmount;
      // Apply new debt
      batch.update(_custCollection.doc(newTransaction.customerId!), {
        'total_debt': FieldValue.increment(newUnpaid),
        'updated_at': FieldValue.serverTimestamp(),
      });
    }

    await _retryOperation(() => batch.commit());
  }
}
