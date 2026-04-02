part of 'checklist_bloc.dart';

@freezed
sealed class ChecklistEvent with _$ChecklistEvent {
  const factory ChecklistEvent.checkTodayStatus() = _CheckTodayStatus;
  const factory ChecklistEvent.submitChecklist({
    required String userId,
    required List<ChecklistItem> items,
  }) = _SubmitChecklist;
}
