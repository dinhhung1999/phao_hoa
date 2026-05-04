import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/product_formula.dart';

/// Formula repository contract
abstract class FormulaRepository {
  /// Get all active formulas
  Future<Either<Failure, List<ProductFormula>>> getAllFormulas();

  /// Stream all formulas in realtime
  Stream<List<ProductFormula>> watchAllFormulas();

  /// Get formula for a specific product
  Future<Either<Failure, ProductFormula?>> getFormulaByProductId(String productId);

  /// Create or update a formula
  Future<Either<Failure, String>> saveFormula(ProductFormula formula);

  /// Delete a formula
  Future<Either<Failure, void>> deleteFormula(String formulaId);
}
