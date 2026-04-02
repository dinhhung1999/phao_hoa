import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/customer.dart';
import '../entities/debt_record.dart';

/// Customer repository contract
abstract class CustomerRepository {
  /// Get all active customers
  Future<Either<Failure, List<Customer>>> getAllCustomers();

  /// Stream all customers in realtime
  Stream<List<Customer>> watchAllCustomers();

  /// Get customers filtered by type
  Future<Either<Failure, List<Customer>>> getCustomersByType(String type);

  /// Add a new customer
  Future<Either<Failure, String>> addCustomer(Customer customer);

  /// Update customer info
  Future<Either<Failure, void>> updateCustomer(Customer customer);

  /// Get debt records for a specific customer
  Future<Either<Failure, List<DebtRecord>>> getCustomerDebts(String customerId);

  /// Record a partial payment for a customer
  Future<Either<Failure, void>> makePartialPayment({
    required String customerId,
    required double amount,
    String? note,
  });

  /// Settle all outstanding debts for a customer
  Future<Either<Failure, void>> settleAllDebts(String customerId);

  /// Soft-delete a customer (set isActive to false)
  Future<Either<Failure, void>> deleteCustomer(String customerId);
}
