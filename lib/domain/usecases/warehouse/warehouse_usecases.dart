import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/warehouse.dart';
import '../../repositories/warehouse_repository.dart';

class GetAllWarehouses {
  final WarehouseRepository _repository;
  GetAllWarehouses(this._repository);
  Future<Either<Failure, List<Warehouse>>> call() =>
      _repository.getAllWarehouses();
}

class GetWarehouseById {
  final WarehouseRepository _repository;
  GetWarehouseById(this._repository);
  Future<Either<Failure, Warehouse>> call(String id) =>
      _repository.getWarehouseById(id);
}

class AddWarehouse {
  final WarehouseRepository _repository;
  AddWarehouse(this._repository);
  Future<Either<Failure, String>> call(Warehouse warehouse) =>
      _repository.addWarehouse(warehouse);
}

class UpdateWarehouse {
  final WarehouseRepository _repository;
  UpdateWarehouse(this._repository);
  Future<Either<Failure, void>> call(Warehouse warehouse) =>
      _repository.updateWarehouse(warehouse);
}

class DeleteWarehouse {
  final WarehouseRepository _repository;
  DeleteWarehouse(this._repository);
  Future<Either<Failure, void>> call(String id) =>
      _repository.deleteWarehouse(id);
}

class WatchAllWarehouses {
  final WarehouseRepository _repository;
  WatchAllWarehouses(this._repository);
  Stream<List<Warehouse>> call() => _repository.watchAllWarehouses();
}
