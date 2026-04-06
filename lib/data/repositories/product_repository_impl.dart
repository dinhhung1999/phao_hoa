import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/models/paginated_result.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource _datasource;

  ProductRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async {
    try {
      final models = await _datasource.getAllProducts();
      return Right(models.map(_toEntity).toList());
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Stream<List<Product>> watchAllProducts() {
    return _datasource.watchAllProducts().map(
      (models) => models.map(_toEntity).toList(),
    );
  }

  @override
  Future<Either<Failure, Product>> getProductById(String id) async {
    try {
      final model = await _datasource.getProductById(id);
      return Right(_toEntity(model));
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> addProduct(Product product) async {
    try {
      final model = _toModel(product);
      final id = await _datasource.addProduct(model);
      return Right(id);
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(Product product) async {
    try {
      await _datasource.updateProduct(_toModel(product));
      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    try {
      await _datasource.deleteProduct(id);
      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedResult<Product>>> getProductsPaginated({
    int limit = 20,
    dynamic startAfter,
  }) async {
    try {
      final (models, lastDoc) = await _datasource.getProductsPaginated(
        limit: limit,
        startAfter: startAfter as DocumentSnapshot?,
      );
      return Right(PaginatedResult(
        items: models.map(_toEntity).toList(),
        lastDocument: lastDoc,
        hasMore: models.length >= limit,
      ));
    } catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  Product _toEntity(ProductModel m) => Product(
    id: m.id,
    name: m.name,
    category: m.category,
    regulationClass: m.regulationClass,
    unit: m.unit,
    importPrice: m.importPrice,
    exportPrice: m.exportPrice,
    isActive: m.isActive,
    createdAt: m.createdAt,
    updatedAt: m.updatedAt,
    updatedBy: m.updatedBy,
  );

  ProductModel _toModel(Product e) => ProductModel(
    id: e.id,
    name: e.name,
    category: e.category,
    regulationClass: e.regulationClass,
    unit: e.unit,
    importPrice: e.importPrice,
    exportPrice: e.exportPrice,
    isActive: e.isActive,
    createdAt: e.createdAt,
    updatedAt: e.updatedAt,
    updatedBy: e.updatedBy,
  );
}
