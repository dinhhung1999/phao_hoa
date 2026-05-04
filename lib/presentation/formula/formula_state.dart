part of 'formula_bloc.dart';

@freezed
sealed class FormulaState with _$FormulaState {
  const factory FormulaState.initial() = _Initial;
  const factory FormulaState.loading() = _Loading;
  const factory FormulaState.loaded(List<ProductFormula> formulas) = _Loaded;
  const factory FormulaState.actionSuccess(String message) = _ActionSuccess;
  const factory FormulaState.error(String message) = _Error;
}
