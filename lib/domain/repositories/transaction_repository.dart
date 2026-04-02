import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/transaction.dart';
import '../entities/transaction_item.dart';

/// Transaction repository contract
abstract class TransactionRepository {
  /// Create a new export order (atomic batch write)
  Future<Either<Failure, String>> createExportOrder({
    required Transaction transaction,
    required List<TransactionItem> items,
  });

  /// Create a new import order (atomic batch write)
  Future<Either<Failure, String>> createImportOrder({
    required Transaction transaction,
    required List<TransactionItem> items,
  });

  /// Get transaction history with optional filters
  Future<Either<Failure, List<Transaction>>> getTransactionHistory({
    DateTime? startDate,
    DateTime? endDate,
    String? type,
    String? warehouseLocation,
  });

  /// Get transactions for a specific date
  Future<Either<Failure, List<Transaction>>> getTransactionsByDate(
    DateTime date,
  );

  /// Get transaction with its items
  Future<Either<Failure, Transaction>> getTransactionWithItems(String id);
}
