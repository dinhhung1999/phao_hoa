import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/firestore_paths.dart';
import '../models/warehouse_location_stock_model.dart';
import '../models/inventory_snapshot_model.dart';

/// Firestore data source for Inventory and Reconciliation
class InventoryRemoteDatasource {
  final FirebaseFirestore _firestore;

  InventoryRemoteDatasource(this._firestore);

  CollectionReference get _invCollection =>
      _firestore.collection(FirestorePaths.inventory);

  CollectionReference get _reconCollection =>
      _firestore.collection(FirestorePaths.reconciliations);

  CollectionReference get _productCollection =>
      _firestore.collection(FirestorePaths.products);

  /// Get all inventory stocks
  Future<List<WarehouseLocationStockModel>> getAllStocks() async {
    final snapshot = await _invCollection.get();
    return snapshot.docs
        .map((d) => WarehouseLocationStockModel.fromFirestore(d))
        .toList();
  }

  /// Stream all stocks
  Stream<List<WarehouseLocationStockModel>> watchAllStocks() {
    return _invCollection.snapshots().map(
      (snap) => snap.docs
          .map((d) => WarehouseLocationStockModel.fromFirestore(d))
          .toList(),
    );
  }

  /// Get stock for a product
  Future<WarehouseLocationStockModel> getStockByProductId(
    String productId,
  ) async {
    final doc = await _invCollection.doc(productId).get();
    return WarehouseLocationStockModel.fromFirestore(doc);
  }

  /// Perform reconciliation with atomic batch write
  Future<String> performReconciliation({
    required String userId,
    required String warehouseLocation,
    required List<Map<String, dynamic>> items,
    required bool shouldAdjust,
    String? notes,
  }) async {
    final batch = _firestore.batch();
    final reconRef = _reconCollection.doc();
    final reconId = reconRef.id;

    final hasDiscrepancy = items.any(
      (item) => item['system_quantity'] != item['actual_quantity'],
    );

    // 1. Create reconciliation record
    batch.set(reconRef, {
      'date': FieldValue.serverTimestamp(),
      'created_by': userId,
      'status': hasDiscrepancy ? 'has_discrepancy' : 'completed',
      'notes': notes,
      'created_at': FieldValue.serverTimestamp(),
    });

    // 2. Save each item comparison
    for (final item in items) {
      final itemRef = reconRef
          .collection(FirestorePaths.reconciliationItems)
          .doc();
      batch.set(itemRef, item);

      // 3. Adjust inventory if user confirmed and there's a discrepancy
      if (shouldAdjust &&
          item['system_quantity'] != item['actual_quantity']) {
        final diff =
            (item['actual_quantity'] as int) - (item['system_quantity'] as int);
        batch.update(_invCollection.doc(item['product_id']), {
          'stock_by_location.$warehouseLocation': item['actual_quantity'],
          'total_quantity': FieldValue.increment(diff),
          'last_updated': FieldValue.serverTimestamp(),
        });
      }
    }

    await batch.commit();
    return reconId;
  }

  /// Get reconciliation history
  Future<List<InventorySnapshotModel>> getReconciliationHistory() async {
    final snapshot = await _reconCollection
        .orderBy('created_at', descending: true)
        .limit(30)
        .get();
    return snapshot.docs
        .map((d) => InventorySnapshotModel.fromFirestore(d))
        .toList();
  }

  /// Calculate total inventory value
  Future<double> getTotalInventoryValue() async {
    final stocks = await getAllStocks();
    double totalValue = 0;

    for (final stock in stocks) {
      final productDoc = await _productCollection.doc(stock.productId).get();
      if (productDoc.exists) {
        final data = productDoc.data() as Map<String, dynamic>;
        final exportPrice = (data['export_price'] as num?)?.toDouble() ?? 0;
        totalValue += exportPrice * stock.totalQuantity;
      }
    }

    return totalValue;
  }
}
