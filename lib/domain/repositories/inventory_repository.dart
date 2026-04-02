import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/inventory_snapshot.dart';
import '../entities/warehouse_stock.dart';

/// Inventory repository contract
abstract class InventoryRepository {
  /// Get all inventory stocks
  Future<Either<Failure, List<WarehouseStock>>> getAllStocks();

  /// Stream all stocks in realtime
  Stream<List<WarehouseStock>> watchAllStocks();

  /// Get stock for a specific product
  Future<Either<Failure, WarehouseStock>> getStockByProductId(String productId);

  /// Get stocks filtered by location
  Future<Either<Failure, List<WarehouseStock>>> getStocksByLocation(
    String location,
  );

  /// Perform stock reconciliation (atomic batch write)
  Future<Either<Failure, String>> performReconciliation({
    required String userId,
    required String warehouseLocation,
    required List<ReconciliationItem> items,
    required bool shouldAdjust,
    String? notes,
  });

  /// Get reconciliation history
  Future<Either<Failure, List<InventorySnapshot>>> getReconciliationHistory();

  /// Get total inventory value
  Future<Either<Failure, double>> getTotalInventoryValue();
}
