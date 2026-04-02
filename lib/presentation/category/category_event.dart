part of 'category_bloc.dart';

@freezed
sealed class CategoryEvent with _$CategoryEvent {
  const factory CategoryEvent.loadProducts() = _LoadProducts;
  const factory CategoryEvent.addProduct(Product product) = _AddProduct;
  const factory CategoryEvent.updateProduct(Product product) = _UpdateProduct;
  const factory CategoryEvent.deleteProduct(String id) = _DeleteProduct;
}
