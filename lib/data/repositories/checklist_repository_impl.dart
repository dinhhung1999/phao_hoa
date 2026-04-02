import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/checklist.dart';
import '../../domain/repositories/checklist_repository.dart';
import '../datasources/checklist_remote_datasource.dart';
import '../models/checklist_model.dart';

class ChecklistRepositoryImpl implements ChecklistRepository {
  final ChecklistRemoteDatasource _datasource;

  ChecklistRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, void>> submitDailyChecklist({
    required String userId,
    required List<ChecklistItem> items,
  }) async {
    try {
      final itemModels = items
          .map((i) => ChecklistItemModel(
                label: i.label,
                isChecked: i.isChecked,
                note: i.note,
              ))
          .toList();

      await _datasource.submitDailyChecklist(
        userId: userId,
        items: itemModels,
      );
      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isTodayChecklistCompleted() async {
    try {
      final result = await _datasource.isTodayChecklistCompleted();
      return Right(result);
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Checklist?>> getTodayChecklist() async {
    try {
      final model = await _datasource.getTodayChecklist();
      if (model == null) return const Right(null);
      return Right(_toEntity(model));
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Checklist>>> getChecklistHistory() async {
    try {
      final models = await _datasource.getChecklistHistory();
      return Right(models.map(_toEntity).toList());
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  Checklist _toEntity(ChecklistModel m) => Checklist(
    date: m.date,
    completedBy: m.completedBy,
    completedAt: m.completedAt,
    isPassed: m.isPassed,
    items: m.items
        .map((i) => ChecklistItem(
              label: i.label,
              isChecked: i.isChecked,
              note: i.note,
            ))
        .toList(),
  );
}
