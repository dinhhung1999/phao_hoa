import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/product_formula.dart';
import '../../domain/repositories/formula_repository.dart';
import '../datasources/formula_remote_datasource.dart';
import '../models/product_formula_model.dart';

class FormulaRepositoryImpl implements FormulaRepository {
  final FormulaRemoteDatasource _datasource;

  FormulaRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<ProductFormula>>> getAllFormulas() async {
    try {
      final models = await _datasource.getAllFormulas();
      return Right(models.map(_toEntity).toList());
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Stream<List<ProductFormula>> watchAllFormulas() {
    return _datasource.watchAllFormulas().map(
      (models) => models.map(_toEntity).toList(),
    );
  }

  @override
  Future<Either<Failure, ProductFormula?>> getFormulaByProductId(
    String productId,
  ) async {
    try {
      final model = await _datasource.getFormulaByProductId(productId);
      return Right(model != null ? _toEntity(model) : null);
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> saveFormula(ProductFormula formula) async {
    try {
      final model = _toModel(formula);
      final id = await _datasource.saveFormula(model);
      return Right(id);
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteFormula(String formulaId) async {
    try {
      await _datasource.deleteFormula(formulaId);
      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  ProductFormula _toEntity(ProductFormulaModel m) => ProductFormula(
    id: m.id,
    productId: m.productId,
    productName: m.productName,
    components: m.components.map((c) => FormulaComponent(
      productId: c.productId,
      productName: c.productName,
      quantity: c.quantity,
    )).toList(),
    laborCost: m.laborCost,
    notes: m.notes,
    isActive: m.isActive,
    updatedAt: m.updatedAt,
    updatedBy: m.updatedBy,
  );

  ProductFormulaModel _toModel(ProductFormula f) => ProductFormulaModel(
    id: f.id,
    productId: f.productId,
    productName: f.productName,
    components: f.components.map((c) => FormulaComponentModel(
      productId: c.productId,
      productName: c.productName,
      quantity: c.quantity,
    )).toList(),
    laborCost: f.laborCost,
    notes: f.notes,
    isActive: f.isActive,
    updatedAt: f.updatedAt,
    updatedBy: f.updatedBy,
  );
}
