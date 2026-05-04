import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/product_formula.dart';
import '../../repositories/formula_repository.dart';

/// Get all product formulas
class GetAllFormulas {
  final FormulaRepository _repository;

  GetAllFormulas(this._repository);

  Future<Either<Failure, List<ProductFormula>>> call() =>
      _repository.getAllFormulas();
}

/// Watch all formulas in realtime
class WatchAllFormulas {
  final FormulaRepository _repository;

  WatchAllFormulas(this._repository);

  Stream<List<ProductFormula>> call() => _repository.watchAllFormulas();
}

/// Get formula for a specific product
class GetFormulaByProductId {
  final FormulaRepository _repository;

  GetFormulaByProductId(this._repository);

  Future<Either<Failure, ProductFormula?>> call(String productId) =>
      _repository.getFormulaByProductId(productId);
}

/// Save (create or update) a formula
class SaveFormula {
  final FormulaRepository _repository;

  SaveFormula(this._repository);

  Future<Either<Failure, String>> call(ProductFormula formula) =>
      _repository.saveFormula(formula);
}

/// Delete a formula
class DeleteFormula {
  final FormulaRepository _repository;

  DeleteFormula(this._repository);

  Future<Either<Failure, void>> call(String formulaId) =>
      _repository.deleteFormula(formulaId);
}
