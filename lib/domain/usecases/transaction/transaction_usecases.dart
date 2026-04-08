import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../../core/models/paginated_result.dart';
import '../../entities/transaction.dart';
import '../../entities/transaction_item.dart';
import '../../repositories/transaction_repository.dart';

/// Create export order
class CreateExportOrder {
  final TransactionRepository _repository;

  CreateExportOrder(this._repository);

  Future<Either<Failure, String>> call({
    required Transaction transaction,
    required List<TransactionItem> items,
  }) {
    return _repository.createExportOrder(
      transaction: transaction,
      items: items,
    );
  }
}

/// Create import order
class CreateImportOrder {
  final TransactionRepository _repository;

  CreateImportOrder(this._repository);

  Future<Either<Failure, String>> call({
    required Transaction transaction,
    required List<TransactionItem> items,
  }) {
    return _repository.createImportOrder(
      transaction: transaction,
      items: items,
    );
  }
}

/// Get transaction history with filters
class GetTransactionHistory {
  final TransactionRepository _repository;

  GetTransactionHistory(this._repository);

  Future<Either<Failure, List<Transaction>>> call({
    DateTime? startDate,
    DateTime? endDate,
    String? type,
    String? warehouseLocation,
  }) {
    return _repository.getTransactionHistory(
      startDate: startDate,
      endDate: endDate,
      type: type,
      warehouseLocation: warehouseLocation,
    );
  }
}

/// Get transactions by specific date
class GetTransactionsByDate {
  final TransactionRepository _repository;

  GetTransactionsByDate(this._repository);

  Future<Either<Failure, List<Transaction>>> call(DateTime date) =>
      _repository.getTransactionsByDate(date);
}

/// Get transaction history with pagination
class GetTransactionHistoryPaginated {
  final TransactionRepository _repository;

  GetTransactionHistoryPaginated(this._repository);

  Future<Either<Failure, PaginatedResult<Transaction>>> call({
    DateTime? startDate,
    DateTime? endDate,
    String? type,
    String? warehouseLocation,
    int limit = 20,
    dynamic startAfter,
  }) {
    return _repository.getTransactionHistoryPaginated(
      startDate: startDate,
      endDate: endDate,
      type: type,
      warehouseLocation: warehouseLocation,
      limit: limit,
      startAfter: startAfter,
    );
  }
}
