import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/models/paginated_result.dart';
import '../entities/price_record.dart';
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

  /// Update product price and record price history
  Future<Either<Failure, void>> updateProductPrice({
    required String productId,
    required double newImportPrice,
    required double newExportPrice,
    String? updatedBy,
  });

  /// Get price history for a product
  Future<Either<Failure, List<PriceRecord>>> getPriceHistory(String productId);

  /// Record initial price when product is created
  Future<Either<Failure, void>> addInitialPriceRecord({
    required String productId,
    required double importPrice,
    required double exportPrice,
    String? updatedBy,
  });
}
