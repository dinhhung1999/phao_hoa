part of 'formula_bloc.dart';

@freezed
sealed class FormulaEvent with _$FormulaEvent {
  const factory FormulaEvent.loadFormulas() = _LoadFormulas;
  const factory FormulaEvent.saveFormula(ProductFormula formula) = _SaveFormula;
  const factory FormulaEvent.deleteFormula(String formulaId) = _DeleteFormula;
}
