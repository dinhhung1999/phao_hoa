import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/customer.dart';
import '../../domain/entities/debt_record.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasources/customer_remote_datasource.dart';
import '../models/customer_model.dart';
import '../models/debt_record_model.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerRemoteDatasource _datasource;

  CustomerRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<Customer>>> getAllCustomers() async {
    try {
      final models = await _datasource.getAllCustomers();
      return Right(models.map(_toEntity).toList());
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Stream<List<Customer>> watchAllCustomers() {
    return _datasource.watchAllCustomers().map(
      (models) => models.map(_toEntity).toList(),
    );
  }

  @override
  Future<Either<Failure, List<Customer>>> getCustomersByType(
    String type,
  ) async {
    try {
      final models = await _datasource.getCustomersByType(type);
      return Right(models.map(_toEntity).toList());
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> addCustomer(Customer customer) async {
    try {
      final id = await _datasource.addCustomer(_toModel(customer));
      return Right(id);
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateCustomer(Customer customer) async {
    try {
      await _datasource.updateCustomer(_toModel(customer));
      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DebtRecord>>> getCustomerDebts(
    String customerId,
  ) async {
    try {
      final models = await _datasource.getCustomerDebts(customerId);
      return Right(models.map(_debtToEntity).toList());
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> makePartialPayment({
    required String customerId,
    required double amount,
    String? note,
  }) async {
    try {
      await _datasource.makePartialPayment(
        customerId: customerId,
        amount: amount,
        note: note,
      );
      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> settleAllDebts(String customerId) async {
    try {
      await _datasource.settleAllDebts(customerId);
      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCustomer(String customerId) async {
    try {
      await _datasource.deactivateCustomer(customerId);
      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  Customer _toEntity(CustomerModel m) => Customer(
    id: m.id,
    name: m.name,
    phone: m.phone,
    type: m.type,
    totalDebt: m.totalDebt,
    isActive: m.isActive,
    createdAt: m.createdAt,
    updatedAt: m.updatedAt,
    updatedBy: m.updatedBy,
  );

  CustomerModel _toModel(Customer e) => CustomerModel(
    id: e.id,
    name: e.name,
    phone: e.phone,
    type: e.type,
    totalDebt: e.totalDebt,
    isActive: e.isActive,
    createdAt: e.createdAt,
    updatedAt: e.updatedAt,
    updatedBy: e.updatedBy,
  );

  DebtRecord _debtToEntity(DebtRecordModel m) => DebtRecord(
    id: m.id,
    transactionId: m.transactionId,
    type: m.type,
    amount: m.amount,
    runningBalance: m.runningBalance,
    note: m.note,
    createdAt: m.createdAt,
  );
}
