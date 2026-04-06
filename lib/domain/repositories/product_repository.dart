import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/models/paginated_result.dart';
import '../entities/product.dart';

/// Product repository contract
abstract class ProductRepository {
  /// Get all active products
  Future<Either<Failure, List<Product>>> getAllProducts();

  /// Stream all active products in realtime
  Stream<List<Product>> watchAllProducts();

  /// Get a single product by ID
  Future<Either<Failure, Product>> getProductById(String id);

  /// Add a new product
  Future<Either<Failure, String>> addProduct(Product product);

  /// Update an existing product
  Future<Either<Failure, void>> updateProduct(Product product);

  /// Soft-delete a product (set isActive = false)
  Future<Either<Failure, void>> deleteProduct(String id);

  /// Get products with pagination
  Future<Either<Failure, PaginatedResult<Product>>> getProductsPaginated({
    int limit = 20,
    dynamic startAfter,
  });
}
