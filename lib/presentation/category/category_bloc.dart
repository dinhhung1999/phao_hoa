import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/product/product_usecases.dart';

part 'category_event.dart';
part 'category_state.dart';
part 'category_bloc.freezed.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetAllProducts _getAllProducts;
  final AddProduct _addProduct;
  final UpdateProduct _updateProduct;
  final DeleteProduct _deleteProduct;

  CategoryBloc({
    required GetAllProducts getAllProducts,
    required AddProduct addProduct,
    required UpdateProduct updateProduct,
    required DeleteProduct deleteProduct,
  })  : _getAllProducts = getAllProducts,
        _addProduct = addProduct,
        _updateProduct = updateProduct,
        _deleteProduct = deleteProduct,
        super(const CategoryState.initial()) {
    on<CategoryEvent>((event, emit) async {
      await event.map(
        loadProducts: (_) => _onLoad(emit),
        addProduct: (e) => _onAdd(e, emit),
        updateProduct: (e) => _onUpdate(e, emit),
        deleteProduct: (e) => _onDelete(e, emit),
      );
    });
  }

  Future<void> _onLoad(Emitter<CategoryState> emit) async {
    emit(const CategoryState.loading());
    final result = await _getAllProducts();
    result.fold(
      (f) => emit(CategoryState.error(f.message)),
      (products) => emit(CategoryState.loaded(products)),
    );
  }

  Future<void> _onAdd(_AddProduct event, Emitter<CategoryState> emit) async {
    emit(const CategoryState.loading());
    final result = await _addProduct(event.product);
    result.fold(
      (f) => emit(CategoryState.error(f.message)),
      (_) {
        emit(const CategoryState.actionSuccess('Đã thêm sản phẩm'));
        add(const CategoryEvent.loadProducts());
      },
    );
  }

  Future<void> _onUpdate(
    _UpdateProduct event, Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryState.loading());
    final result = await _updateProduct(event.product);
    result.fold(
      (f) => emit(CategoryState.error(f.message)),
      (_) {
        emit(const CategoryState.actionSuccess('Đã cập nhật sản phẩm'));
        add(const CategoryEvent.loadProducts());
      },
    );
  }

  Future<void> _onDelete(
    _DeleteProduct event, Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryState.loading());
    final result = await _deleteProduct(event.id);
    result.fold(
      (f) => emit(CategoryState.error(f.message)),
      (_) {
        emit(const CategoryState.actionSuccess('Đã xóa sản phẩm'));
        add(const CategoryEvent.loadProducts());
      },
    );
  }
}
