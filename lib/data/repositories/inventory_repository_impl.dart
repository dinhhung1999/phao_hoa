import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/inventory_snapshot.dart';
import '../../domain/entities/warehouse_stock.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/inventory_remote_datasource.dart';
import '../models/warehouse_location_stock_model.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryRemoteDatasource _datasource;

  InventoryRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<WarehouseStock>>> getAllStocks() async {
    try {
      final models = await _datasource.getAllStocks();
      return Right(models.map(_toEntity).toList());
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Stream<List<WarehouseStock>> watchAllStocks() {
    return _datasource.watchAllStocks().map(
      (models) => models.map(_toEntity).toList(),
    );
  }

  @override
  Future<Either<Failure, WarehouseStock>> getStockByProductId(
    String productId,
  ) async {
    try {
      final model = await _datasource.getStockByProductId(productId);
      return Right(_toEntity(model));
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WarehouseStock>>> getStocksByLocation(
    String location,
  ) async {
    try {
      final models = await _datasource.getAllStocks();
      final filtered = models
          .where((m) => (m.stockByLocation[location] ?? 0) > 0)
          .toList();
      return Right(filtered.map(_toEntity).toList());
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> performReconciliation({
    required String userId,
    required String warehouseLocation,
    required List<ReconciliationItem> items,
    required bool shouldAdjust,
    String? notes,
  }) async {
    try {
      final itemMaps = items.map((i) => {
        'product_id': i.productId,
        'product_name': i.productName,
        'warehouse_location': i.warehouseLocation,
        'system_quantity': i.systemQuantity,
        'actual_quantity': i.actualQuantity,
        'difference': i.difference,
        'is_matched': i.isMatched,
      }).toList();

      final id = await _datasource.performReconciliation(
        userId: userId,
        warehouseLocation: warehouseLocation,
        items: itemMaps,
        shouldAdjust: shouldAdjust,
        notes: notes,
      );
      return Right(id);
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<InventorySnapshot>>> getReconciliationHistory() async {
    try {
      final models = await _datasource.getReconciliationHistory();
      return Right(
        models.map((m) => InventorySnapshot(
          id: m.id,
          date: m.date,
          createdBy: m.createdBy,
          status: m.status,
          notes: m.notes,
        )).toList(),
      );
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalInventoryValue() async {
    try {
      final value = await _datasource.getTotalInventoryValue();
      return Right(value);
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  WarehouseStock _toEntity(WarehouseLocationStockModel m) => WarehouseStock(
    productId: m.productId,
    productName: m.productName,
    totalQuantity: m.totalQuantity,
    stockByLocation: m.stockByLocation,
    updatedBy: m.updatedBy,
  );
}
