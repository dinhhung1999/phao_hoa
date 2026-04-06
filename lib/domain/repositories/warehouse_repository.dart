import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/warehouse.dart';

/// Repository interface for warehouse management
abstract class WarehouseRepository {
  Future<Either<Failure, List<Warehouse>>> getAllWarehouses();
  Future<Either<Failure, Warehouse>> getWarehouseById(String id);
  Future<Either<Failure, String>> addWarehouse(Warehouse warehouse);
  Future<Either<Failure, void>> updateWarehouse(Warehouse warehouse);
  Future<Either<Failure, void>> deleteWarehouse(String id);
  Stream<List<Warehouse>> watchAllWarehouses();
}
