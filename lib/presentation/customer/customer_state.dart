part of 'customer_bloc.dart';

@freezed
sealed class CustomerState with _$CustomerState {
  const factory CustomerState.initial() = _Initial;
  const factory CustomerState.loading() = _Loading;
  const factory CustomerState.customersLoaded(List<Customer> customers) =
      _CustomersLoaded;
  const factory CustomerState.debtsLoaded({
    required Customer customer,
    required List<DebtRecord> records,
  }) = _DebtsLoaded;
  const factory CustomerState.actionSuccess(String message) = _ActionSuccess;
  const factory CustomerState.error(String message) = _Error;

  // Paginated state
  const factory CustomerState.paginatedLoaded({
    required List<Customer> customers,
    required bool hasMore,
    @Default(false) bool isLoadingMore,
    dynamic lastDocument,
    String? error,
  }) = _PaginatedLoaded;
}
