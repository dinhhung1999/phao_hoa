import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/product/product_usecases.dart';

part 'category_event.dart';
part 'category_state.dart';
part 'category_bloc.freezed.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetAllProducts _getAllProducts;
  final GetProductsPaginated _getProductsPaginated;
  final AddProduct _addProduct;
  final UpdateProduct _updateProduct;
  final DeleteProduct _deleteProduct;

  static const int _pageSize = 20;

  CategoryBloc({
    required GetAllProducts getAllProducts,
    required GetProductsPaginated getProductsPaginated,
    required AddProduct addProduct,
    required UpdateProduct updateProduct,
    required DeleteProduct deleteProduct,
  })  : _getAllProducts = getAllProducts,
        _getProductsPaginated = getProductsPaginated,
        _addProduct = addProduct,
        _updateProduct = updateProduct,
        _deleteProduct = deleteProduct,
        super(const CategoryState.initial()) {
    on<CategoryEvent>((event, emit) async {
      await event.map(
        loadProducts: (_) => _onLoadProducts(emit),
        addProduct: (e) => _onAddProduct(e, emit),
        updateProduct: (e) => _onUpdateProduct(e, emit),
        deleteProduct: (e) => _onDeleteProduct(e, emit),
        loadProductsPaginated: (_) => _onLoadPaginated(emit),
        loadMoreProducts: (_) => _onLoadMore(emit),
        refreshProducts: (_) => _onRefresh(emit),
      );
    });
  }

  // ── Legacy: load all (used by product picker) ──
  Future<void> _onLoadProducts(Emitter<CategoryState> emit) async {
    emit(const CategoryState.loading());
    final result = await _getAllProducts();
    result.fold(
      (f) => emit(CategoryState.error(f.message)),
      (products) => emit(CategoryState.loaded(products)),
    );
  }

  // ── Paginated: first page ──
  Future<void> _onLoadPaginated(Emitter<CategoryState> emit) async {
    emit(const CategoryState.loading());
    final result = await _getProductsPaginated(limit: _pageSize);
    result.fold(
      (f) => emit(CategoryState.error(f.message)),
      (paginated) => emit(CategoryState.paginatedLoaded(
        products: paginated.items,
        hasMore: paginated.hasMore,
        lastDocument: paginated.lastDocument,
      )),
    );
  }

  // ── Paginated: load more ──
  Future<void> _onLoadMore(Emitter<CategoryState> emit) async {
    final current = state;
    if (current is! _PaginatedLoaded || !current.hasMore || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true));

    final result = await _getProductsPaginated(
      limit: _pageSize,
      startAfter: current.lastDocument,
    );

    result.fold(
      (f) => emit(current.copyWith(isLoadingMore: false, error: f.message)),
      (paginated) => emit(CategoryState.paginatedLoaded(
        products: [...current.products, ...paginated.items],
        hasMore: paginated.hasMore,
        lastDocument: paginated.lastDocument,
        isLoadingMore: false,
      )),
    );
  }

  // ── Paginated: refresh ──
  Future<void> _onRefresh(Emitter<CategoryState> emit) async {
    final result = await _getProductsPaginated(limit: _pageSize);
    result.fold(
      (f) => emit(CategoryState.error(f.message)),
      (paginated) => emit(CategoryState.paginatedLoaded(
        products: paginated.items,
        hasMore: paginated.hasMore,
        lastDocument: paginated.lastDocument,
      )),
    );
  }

  Future<void> _onAddProduct(
    _AddProduct event, Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryState.loading());
    final result = await _addProduct(event.product);
    result.fold(
      (f) => emit(CategoryState.error(f.message)),
      (_) {
        emit(const CategoryState.actionSuccess('Đã thêm sản phẩm'));
        add(const CategoryEvent.loadProductsPaginated());
      },
    );
  }

  Future<void> _onUpdateProduct(
    _UpdateProduct event, Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryState.loading());
    final result = await _updateProduct(event.product);
    result.fold(
      (f) => emit(CategoryState.error(f.message)),
      (_) {
        emit(const CategoryState.actionSuccess('Đã cập nhật sản phẩm'));
        add(const CategoryEvent.loadProductsPaginated());
      },
    );
  }

  Future<void> _onDeleteProduct(
    _DeleteProduct event, Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryState.loading());
    final result = await _deleteProduct(event.id);
    result.fold(
      (f) => emit(CategoryState.error(f.message)),
      (_) {
        emit(const CategoryState.actionSuccess('Đã xóa sản phẩm'));
        add(const CategoryEvent.loadProductsPaginated());
      },
    );
  }
}
