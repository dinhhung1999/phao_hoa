import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/customer.dart';
import '../../entities/debt_record.dart';
import '../../repositories/customer_repository.dart';

/// Get all customers
class GetAllCustomers {
  final CustomerRepository _repository;

  GetAllCustomers(this._repository);

  Future<Either<Failure, List<Customer>>> call() =>
      _repository.getAllCustomers();
}

/// Add a new customer
class AddCustomer {
  final CustomerRepository _repository;

  AddCustomer(this._repository);

  Future<Either<Failure, String>> call(Customer customer) =>
      _repository.addCustomer(customer);
}

/// Update an existing customer
class UpdateCustomer {
  final CustomerRepository _repository;

  UpdateCustomer(this._repository);

  Future<Either<Failure, void>> call(Customer customer) =>
      _repository.updateCustomer(customer);
}

/// Delete a customer (soft delete by deactivating)
class DeleteCustomer {
  final CustomerRepository _repository;

  DeleteCustomer(this._repository);

  Future<Either<Failure, void>> call(String customerId) =>
      _repository.deleteCustomer(customerId);
}

/// Get debt records for a customer
class GetCustomerDebts {
  final CustomerRepository _repository;

  GetCustomerDebts(this._repository);

  Future<Either<Failure, List<DebtRecord>>> call(String customerId) =>
      _repository.getCustomerDebts(customerId);
}

/// Make a partial payment
class MakePartialPayment {
  final CustomerRepository _repository;

  MakePartialPayment(this._repository);

  Future<Either<Failure, void>> call({
    required String customerId,
    required double amount,
    String? note,
  }) {
    return _repository.makePartialPayment(
      customerId: customerId,
      amount: amount,
      note: note,
    );
  }
}

/// Settle all debts for a customer (Tất toán công nợ)
class SettleAllDebts {
  final CustomerRepository _repository;

  SettleAllDebts(this._repository);

  Future<Either<Failure, void>> call(String customerId) =>
      _repository.settleAllDebts(customerId);
}

