part of 'checklist_bloc.dart';

@freezed
sealed class ChecklistState with _$ChecklistState {
  const factory ChecklistState.initial() = _Initial;
  const factory ChecklistState.loading() = _Loading;
  const factory ChecklistState.notCompleted() = _NotCompleted;
  const factory ChecklistState.completed() = _Completed;
  const factory ChecklistState.submitted() = _Submitted;
  const factory ChecklistState.error(String message) = _Error;
}
