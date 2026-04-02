import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/checklist.dart';
import '../../repositories/checklist_repository.dart';

/// Submit daily PCCC checklist
class SubmitDailyChecklist {
  final ChecklistRepository _repository;

  SubmitDailyChecklist(this._repository);

  Future<Either<Failure, void>> call({
    required String userId,
    required List<ChecklistItem> items,
  }) {
    return _repository.submitDailyChecklist(userId: userId, items: items);
  }
}

/// Check if today's checklist is completed
class CheckTodayChecklistStatus {
  final ChecklistRepository _repository;

  CheckTodayChecklistStatus(this._repository);

  Future<Either<Failure, bool>> call() =>
      _repository.isTodayChecklistCompleted();
}

/// Get checklist history
class GetChecklistHistory {
  final ChecklistRepository _repository;

  GetChecklistHistory(this._repository);

  Future<Either<Failure, List<Checklist>>> call() =>
      _repository.getChecklistHistory();
}
