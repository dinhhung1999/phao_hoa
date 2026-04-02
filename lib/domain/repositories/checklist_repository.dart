import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/checklist.dart';

/// Checklist repository contract for daily PCCC safety checks
abstract class ChecklistRepository {
  /// Submit today's daily checklist
  Future<Either<Failure, void>> submitDailyChecklist({
    required String userId,
    required List<ChecklistItem> items,
  });

  /// Check if today's checklist has been completed
  Future<Either<Failure, bool>> isTodayChecklistCompleted();

  /// Get today's checklist (if submitted)
  Future<Either<Failure, Checklist?>> getTodayChecklist();

  /// Get checklist history
  Future<Either<Failure, List<Checklist>>> getChecklistHistory();
}
