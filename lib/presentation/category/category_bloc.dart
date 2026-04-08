import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/price_record.dart';
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
  final UpdateProductPrice _updateProductPrice;
  final GetPriceHistory _getPriceHistory;
  final AddInitialPriceRecord _addInitialPriceRecord;

  static const int _pageSize = 20;

  CategoryBloc({
    required GetAllProducts getAllProducts,
    required GetProductsPaginated getProductsPaginated,
    required AddProduct addProduct,
    required UpdateProduct updateProduct,
    required DeleteProduct deleteProduct,
    required UpdateProductPrice updateProductPrice,
    required GetPriceHistory getPriceHistory,
    required AddInitialPriceRecord addInitialPriceRecord,
  })  : _getAllProducts = getAllProducts,
        _getProductsPaginated = getProductsPaginated,
        _addProduct = addProduct,
        _updateProduct = updateProduct,
        _deleteProduct = deleteProduct,
        _updateProductPrice = updateProductPrice,
        _getPriceHistory = getPriceHistory,
        _addInitialPriceRecord = addInitialPriceRecord,
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
        updatePrice: (e) => _onUpdatePrice(e, emit),
        loadPriceHistory: (e) => _onLoadPriceHistory(e, emit),
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
      (productId) {
        // Record initial price
        _addInitialPriceRecord(
          productId: productId,
          importPrice: event.product.importPrice,
          exportPrice: event.product.exportPrice,
          updatedBy: event.product.updatedBy,
        );
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

  // ── Price History ──

  Future<void> _onUpdatePrice(
    _UpdatePrice event, Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryState.loading());
    final result = await _updateProductPrice(
      productId: event.productId,
      newImportPrice: event.newImportPrice,
      newExportPrice: event.newExportPrice,
      updatedBy: event.updatedBy,
    );
    result.fold(
      (f) => emit(CategoryState.error(f.message)),
      (_) {
        emit(const CategoryState.actionSuccess('Đã cập nhật giá'));
        add(const CategoryEvent.loadProductsPaginated());
      },
    );
  }

  Future<void> _onLoadPriceHistory(
    _LoadPriceHistory event, Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryState.loading());

    // Get product info first
    final productResult = await _getAllProducts();

    if (productResult.isLeft()) {
      productResult.fold(
        (f) => emit(CategoryState.error(f.message)),
        (_) {},
      );
      return;
    }

    final products = productResult.getOrElse(() => []);
    final product = products.firstWhere(
      (p) => p.id == event.productId,
      orElse: () => products.first,
    );

    // Get price history
    final historyResult = await _getPriceHistory(event.productId);

    if (historyResult.isLeft()) {
      historyResult.fold(
        (f) => emit(CategoryState.error(f.message)),
        (_) {},
      );
      return;
    }

    var records = historyResult.getOrElse(() => []);

    // Auto-seed initial price record if empty (for products created before this feature)
    if (records.isEmpty) {
      await _addInitialPriceRecord(
        productId: product.id,
        importPrice: product.importPrice,
        exportPrice: product.exportPrice,
        updatedBy: product.updatedBy,
      );
      // Reload after seeding
      final reloadResult = await _getPriceHistory(event.productId);
      records = reloadResult.getOrElse(() => []);
    }

    emit(CategoryState.priceHistoryLoaded(
      records: records,
      product: product,
    ));
  }
}
