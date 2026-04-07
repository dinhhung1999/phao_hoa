part of 'category_bloc.dart';

@freezed
sealed class CategoryState with _$CategoryState {
  const factory CategoryState.initial() = _Initial;
  const factory CategoryState.loading() = _Loading;
  const factory CategoryState.loaded(List<Product> products) = _Loaded;
  const factory CategoryState.actionSuccess(String message) = _ActionSuccess;
  const factory CategoryState.error(String message) = _Error;

  // Paginated state
  const factory CategoryState.paginatedLoaded({
    required List<Product> products,
    required bool hasMore,
    @Default(false) bool isLoadingMore,
    dynamic lastDocument,
    String? error,
  }) = _PaginatedLoaded;

  // Price history state
  const factory CategoryState.priceHistoryLoaded({
    required List<PriceRecord> records,
    required Product product,
  }) = _PriceHistoryLoaded;
}
