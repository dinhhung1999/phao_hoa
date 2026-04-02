import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/checklist.dart';
import '../../domain/usecases/checklist/checklist_usecases.dart';

part 'checklist_event.dart';
part 'checklist_state.dart';
part 'checklist_bloc.freezed.dart';

class ChecklistBloc extends Bloc<ChecklistEvent, ChecklistState> {
  final CheckTodayChecklistStatus _checkStatus;
  final SubmitDailyChecklist _submitChecklist;

  ChecklistBloc({
    required CheckTodayChecklistStatus checkStatus,
    required SubmitDailyChecklist submitChecklist,
  })  : _checkStatus = checkStatus,
        _submitChecklist = submitChecklist,
        super(const ChecklistState.initial()) {
    on<ChecklistEvent>((event, emit) async {
      await event.map(
        checkTodayStatus: (_) => _onCheckStatus(emit),
        submitChecklist: (e) => _onSubmit(e, emit),
      );
    });
  }

  Future<void> _onCheckStatus(Emitter<ChecklistState> emit) async {
    emit(const ChecklistState.loading());
    final result = await _checkStatus();
    result.fold(
      (f) => emit(ChecklistState.error(f.message)),
      (isCompleted) => emit(
        isCompleted
            ? const ChecklistState.completed()
            : const ChecklistState.notCompleted(),
      ),
    );
  }

  Future<void> _onSubmit(
    _SubmitChecklist event, Emitter<ChecklistState> emit,
  ) async {
    emit(const ChecklistState.loading());
    final result = await _submitChecklist(
      userId: event.userId,
      items: event.items,
    );
    result.fold(
      (f) => emit(ChecklistState.error(f.message)),
      (_) => emit(const ChecklistState.submitted()),
    );
  }
}
