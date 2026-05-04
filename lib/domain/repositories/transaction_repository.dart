import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/models/paginated_result.dart';
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

  /// Get transaction history with pagination
  Future<Either<Failure, PaginatedResult<Transaction>>> getTransactionHistoryPaginated({
    DateTime? startDate,
    DateTime? endDate,
    String? type,
    String? warehouseLocation,
    int limit = 20,
    dynamic startAfter,
  });

  /// Update debt payment for a transaction
  Future<Either<Failure, void>> updateDebtPayment({
    required String transactionId,
    required double newPaidAmount,
    required double totalValue,
    String? customerId,
    required double previousPaidAmount,
  });

  /// Get transactions that contain a specific product
  Future<Either<Failure, List<Transaction>>> getTransactionsByProductId(
    String productId, {
    int limit = 20,
  });

  /// Update an existing transaction (edit within 24h).
  /// Reverses old inventory, applies new inventory atomically.
  Future<Either<Failure, void>> updateTransaction({
    required Transaction oldTransaction,
    required List<TransactionItem> oldItems,
    required Transaction newTransaction,
    required List<TransactionItem> newItems,
  });
}
