part of 'customer_bloc.dart';

@freezed
sealed class CustomerEvent with _$CustomerEvent {
  const factory CustomerEvent.loadCustomers() = _LoadCustomers;
  const factory CustomerEvent.addCustomer(Customer customer) = _AddCustomer;
  const factory CustomerEvent.loadDebts({
    required String customerId,
    required Customer customer,
  }) = _LoadDebts;
  const factory CustomerEvent.makePayment({
    required String customerId,
    required double amount,
    String? note,
  }) = _MakePayment;
  const factory CustomerEvent.settleAll(String customerId) = _SettleAll;
  const factory CustomerEvent.updateCustomer(Customer customer) = _UpdateCustomer;
  const factory CustomerEvent.deleteCustomer(String customerId) = _DeleteCustomer;

  // Pagination events
  const factory CustomerEvent.loadCustomersPaginated() = _LoadCustomersPaginated;
  const factory CustomerEvent.loadMoreCustomers() = _LoadMoreCustomers;
  const factory CustomerEvent.refreshCustomers() = _RefreshCustomers;
}
