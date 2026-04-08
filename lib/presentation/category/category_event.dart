part of 'category_bloc.dart';

@freezed
sealed class CategoryEvent with _$CategoryEvent {
  const factory CategoryEvent.loadProducts() = _LoadProducts;
  const factory CategoryEvent.addProduct(Product product) = _AddProduct;
  const factory CategoryEvent.updateProduct(Product product) = _UpdateProduct;
  const factory CategoryEvent.deleteProduct(String id) = _DeleteProduct;

  // Pagination events
  const factory CategoryEvent.loadProductsPaginated() = _LoadProductsPaginated;
  const factory CategoryEvent.loadMoreProducts() = _LoadMoreProducts;
  const factory CategoryEvent.refreshProducts() = _RefreshProducts;

  // Price history events
  const factory CategoryEvent.updatePrice({
    required String productId,
    required double newImportPrice,
    required double newExportPrice,
    String? updatedBy,
  }) = _UpdatePrice;
  const factory CategoryEvent.loadPriceHistory(String productId) = _LoadPriceHistory;
}
