import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
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
