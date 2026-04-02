import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/transaction.dart';
import '../../entities/transaction_item.dart';
import '../../repositories/transaction_repository.dart';
import '../../repositories/checklist_repository.dart';

/// Create export order — checks PCCC checklist first
class CreateExportOrder {
  final TransactionRepository _transactionRepo;
  final ChecklistRepository _checklistRepo;

  CreateExportOrder(this._transactionRepo, this._checklistRepo);

  Future<Either<Failure, String>> call({
    required Transaction transaction,
    required List<TransactionItem> items,
  }) async {
    // Verify PCCC checklist completed today
    final checklistResult = await _checklistRepo.isTodayChecklistCompleted();
    return checklistResult.fold(
      (failure) => Left(failure),
      (isCompleted) {
        if (!isCompleted) {
          return const Left(ChecklistNotCompletedFailure());
        }
        return _transactionRepo.createExportOrder(
          transaction: transaction,
          items: items,
        );
      },
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
