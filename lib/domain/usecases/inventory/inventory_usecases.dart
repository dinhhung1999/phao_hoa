import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/inventory_snapshot.dart';
import '../../entities/warehouse_stock.dart';
import '../../repositories/inventory_repository.dart';

/// Get dashboard summary (all stocks)
class GetDashboardSummary {
  final InventoryRepository _repository;

  GetDashboardSummary(this._repository);

  Future<Either<Failure, List<WarehouseStock>>> call() =>
      _repository.getAllStocks();
}

/// Get stock by location
class GetStockByLocation {
  final InventoryRepository _repository;

  GetStockByLocation(this._repository);

  Future<Either<Failure, List<WarehouseStock>>> call(String location) =>
      _repository.getStocksByLocation(location);
}

/// Perform stock reconciliation
class PerformStockReconciliation {
  final InventoryRepository _repository;

  PerformStockReconciliation(this._repository);

  Future<Either<Failure, String>> call({
    required String userId,
    required String warehouseLocation,
    required List<ReconciliationItem> items,
    required bool shouldAdjust,
    String? notes,
  }) {
    return _repository.performReconciliation(
      userId: userId,
      warehouseLocation: warehouseLocation,
      items: items,
      shouldAdjust: shouldAdjust,
      notes: notes,
    );
  }
}

/// Get reconciliation history
class GetReconciliationHistory {
  final InventoryRepository _repository;

  GetReconciliationHistory(this._repository);

  Future<Either<Failure, List<InventorySnapshot>>> call() =>
      _repository.getReconciliationHistory();
}

/// Get total inventory value
class GetTotalInventoryValue {
  final InventoryRepository _repository;

  GetTotalInventoryValue(this._repository);

  Future<Either<Failure, double>> call() =>
      _repository.getTotalInventoryValue();
}
