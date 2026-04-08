import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/warehouse.dart';
import '../../domain/repositories/warehouse_repository.dart';
import '../datasources/warehouse_remote_datasource.dart';
import '../models/warehouse_model.dart';

class WarehouseRepositoryImpl implements WarehouseRepository {
  final WarehouseRemoteDatasource _datasource;

  WarehouseRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<Warehouse>>> getAllWarehouses() async {
    try {
      final models = await _datasource.getAllWarehouses();
      return Right(models.map(_toEntity).toList());
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Warehouse>> getWarehouseById(String id) async {
    try {
      final model = await _datasource.getWarehouseById(id);
      return Right(_toEntity(model));
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> addWarehouse(Warehouse warehouse) async {
    try {
      final model = _toModel(warehouse);
      final id = await _datasource.addWarehouse(model);
      return Right(id);
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateWarehouse(Warehouse warehouse) async {
    try {
      final model = _toModel(warehouse);
      await _datasource.updateWarehouse(model);
      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteWarehouse(String id) async {
    try {
      await _datasource.deleteWarehouse(id);
      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Stream<List<Warehouse>> watchAllWarehouses() {
    return _datasource
        .watchAllWarehouses()
        .map((models) => models.map(_toEntity).toList());
  }

  Warehouse _toEntity(WarehouseModel m) => Warehouse(
        id: m.id,
        name: m.name,
        address: m.address,
        area: m.area,
        capacity: m.capacity,
        notes: m.notes,
        isActive: m.isActive,
        createdAt: m.createdAt,
        updatedAt: m.updatedAt,
        updatedBy: m.updatedBy,
      );

  WarehouseModel _toModel(Warehouse w) => WarehouseModel(
        id: w.id,
        name: w.name,
        address: w.address,
        area: w.area,
        capacity: w.capacity,
        notes: w.notes,
        isActive: w.isActive,
        createdAt: w.createdAt,
        updatedAt: w.updatedAt,
        updatedBy: w.updatedBy,
      );
}
