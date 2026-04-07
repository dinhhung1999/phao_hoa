import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../../core/models/paginated_result.dart';
import '../../entities/price_record.dart';
import '../../entities/product.dart';
import '../../repositories/product_repository.dart';

/// Get all active products
class GetAllProducts {
  final ProductRepository _repository;

  GetAllProducts(this._repository);

  Future<Either<Failure, List<Product>>> call() =>
      _repository.getAllProducts();
}

/// Add a new product
class AddProduct {
  final ProductRepository _repository;

  AddProduct(this._repository);

  Future<Either<Failure, String>> call(Product product) =>
      _repository.addProduct(product);
}

/// Update an existing product
class UpdateProduct {
  final ProductRepository _repository;

  UpdateProduct(this._repository);

  Future<Either<Failure, void>> call(Product product) =>
      _repository.updateProduct(product);
}

/// Soft-delete a product
class DeleteProduct {
  final ProductRepository _repository;

  DeleteProduct(this._repository);

  Future<Either<Failure, void>> call(String id) =>
      _repository.deleteProduct(id);
}

/// Watch all products in realtime
class WatchAllProducts {
  final ProductRepository _repository;

  WatchAllProducts(this._repository);

  Stream<List<Product>> call() => _repository.watchAllProducts();
}

/// Get products with pagination
class GetProductsPaginated {
  final ProductRepository _repository;

  GetProductsPaginated(this._repository);

  Future<Either<Failure, PaginatedResult<Product>>> call({
    int limit = 20,
    dynamic startAfter,
  }) => _repository.getProductsPaginated(limit: limit, startAfter: startAfter);
}

/// Update product price and record history
class UpdateProductPrice {
  final ProductRepository _repository;

  UpdateProductPrice(this._repository);

  Future<Either<Failure, void>> call({
    required String productId,
    required double newImportPrice,
    required double newExportPrice,
    String? updatedBy,
  }) => _repository.updateProductPrice(
    productId: productId,
    newImportPrice: newImportPrice,
    newExportPrice: newExportPrice,
    updatedBy: updatedBy,
  );
}

/// Get price history for a product
class GetPriceHistory {
  final ProductRepository _repository;

  GetPriceHistory(this._repository);

  Future<Either<Failure, List<PriceRecord>>> call(String productId) =>
      _repository.getPriceHistory(productId);
}

/// Record initial price when product is first created
class AddInitialPriceRecord {
  final ProductRepository _repository;

  AddInitialPriceRecord(this._repository);

  Future<Either<Failure, void>> call({
    required String productId,
    required double importPrice,
    required double exportPrice,
    String? updatedBy,
  }) => _repository.addInitialPriceRecord(
    productId: productId,
    importPrice: importPrice,
    exportPrice: exportPrice,
    updatedBy: updatedBy,
  );
}
