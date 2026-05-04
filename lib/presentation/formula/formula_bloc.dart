import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/product_formula.dart';
import '../../domain/usecases/formula/formula_usecases.dart';

part 'formula_event.dart';
part 'formula_state.dart';
part 'formula_bloc.freezed.dart';

class FormulaBloc extends Bloc<FormulaEvent, FormulaState> {
  final GetAllFormulas _getAllFormulas;
  final SaveFormula _saveFormula;
  final DeleteFormula _deleteFormula;

  FormulaBloc({
    required GetAllFormulas getAllFormulas,
    required SaveFormula saveFormula,
    required DeleteFormula deleteFormula,
  })  : _getAllFormulas = getAllFormulas,
        _saveFormula = saveFormula,
        _deleteFormula = deleteFormula,
        super(const FormulaState.initial()) {
    on<FormulaEvent>((event, emit) async {
      await event.map(
        loadFormulas: (_) => _onLoad(emit),
        saveFormula: (e) => _onSave(e, emit),
        deleteFormula: (e) => _onDelete(e, emit),
      );
    });
  }

  Future<void> _onLoad(Emitter<FormulaState> emit) async {
    emit(const FormulaState.loading());
    final result = await _getAllFormulas();
    result.fold(
      (f) => emit(FormulaState.error(f.message)),
      (formulas) => emit(FormulaState.loaded(formulas)),
    );
  }

  Future<void> _onSave(
    _SaveFormula event,
    Emitter<FormulaState> emit,
  ) async {
    emit(const FormulaState.loading());
    final result = await _saveFormula(event.formula);
    result.fold(
      (f) => emit(FormulaState.error(f.message)),
      (_) {
        emit(const FormulaState.actionSuccess('Đã lưu công thức'));
        add(const FormulaEvent.loadFormulas());
      },
    );
  }

  Future<void> _onDelete(
    _DeleteFormula event,
    Emitter<FormulaState> emit,
  ) async {
    emit(const FormulaState.loading());
    final result = await _deleteFormula(event.formulaId);
    result.fold(
      (f) => emit(FormulaState.error(f.message)),
      (_) {
        emit(const FormulaState.actionSuccess('Đã xoá công thức'));
        add(const FormulaEvent.loadFormulas());
      },
    );
  }
}
