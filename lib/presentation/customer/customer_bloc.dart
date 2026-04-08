import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/customer.dart';
import '../../domain/entities/debt_record.dart';
import '../../domain/usecases/customer/customer_usecases.dart';

part 'customer_event.dart';
part 'customer_state.dart';
part 'customer_bloc.freezed.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final GetAllCustomers _getAllCustomers;
  final GetCustomersPaginated _getCustomersPaginated;
  final AddCustomer _addCustomer;
  final UpdateCustomer _updateCustomer;
  final DeleteCustomer _deleteCustomer;
  final GetCustomerDebts _getDebts;
  final MakePartialPayment _makePayment;
  final SettleAllDebts _settleAll;

  static const int _pageSize = 20;

  CustomerBloc({
    required GetAllCustomers getAllCustomers,
    required GetCustomersPaginated getCustomersPaginated,
    required AddCustomer addCustomer,
    required UpdateCustomer updateCustomer,
    required DeleteCustomer deleteCustomer,
    required GetCustomerDebts getDebts,
    required MakePartialPayment makePayment,
    required SettleAllDebts settleAll,
  })  : _getAllCustomers = getAllCustomers,
        _getCustomersPaginated = getCustomersPaginated,
        _addCustomer = addCustomer,
        _updateCustomer = updateCustomer,
        _deleteCustomer = deleteCustomer,
        _getDebts = getDebts,
        _makePayment = makePayment,
        _settleAll = settleAll,
        super(const CustomerState.initial()) {
    on<CustomerEvent>((event, emit) async {
      await event.map(
        loadCustomers: (_) => _onLoadCustomers(emit),
        addCustomer: (e) => _onAddCustomer(e, emit),
        updateCustomer: (e) => _onUpdateCustomer(e, emit),
        deleteCustomer: (e) => _onDeleteCustomer(e, emit),
        loadDebts: (e) => _onLoadDebts(e, emit),
        makePayment: (e) => _onMakePayment(e, emit),
        settleAll: (e) => _onSettleAll(e, emit),
        loadCustomersPaginated: (_) => _onLoadPaginated(emit),
        loadMoreCustomers: (_) => _onLoadMore(emit),
        refreshCustomers: (_) => _onRefresh(emit),
        addMultipleCustomers: (e) => _onAddMultipleCustomers(e, emit),
      );
    });
  }

  // ── Legacy: load all (used by export customer picker) ──
  Future<void> _onLoadCustomers(Emitter<CustomerState> emit) async {
    emit(const CustomerState.loading());
    final result = await _getAllCustomers();
    result.fold(
      (f) => emit(CustomerState.error(f.message)),
      (customers) => emit(CustomerState.customersLoaded(customers)),
    );
  }

  // ── Paginated: first page ──
  Future<void> _onLoadPaginated(Emitter<CustomerState> emit) async {
    emit(const CustomerState.loading());
    final result = await _getCustomersPaginated(limit: _pageSize);
    result.fold(
      (f) => emit(CustomerState.error(f.message)),
      (paginated) => emit(CustomerState.paginatedLoaded(
        customers: paginated.items,
        hasMore: paginated.hasMore,
        lastDocument: paginated.lastDocument,
      )),
    );
  }

  // ── Paginated: load more ──
  Future<void> _onLoadMore(Emitter<CustomerState> emit) async {
    final current = state;
    if (current is! _PaginatedLoaded || !current.hasMore || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true));

    final result = await _getCustomersPaginated(
      limit: _pageSize,
      startAfter: current.lastDocument,
    );

    result.fold(
      (f) => emit(current.copyWith(isLoadingMore: false, error: f.message)),
      (paginated) => emit(CustomerState.paginatedLoaded(
        customers: [...current.customers, ...paginated.items],
        hasMore: paginated.hasMore,
        lastDocument: paginated.lastDocument,
        isLoadingMore: false,
      )),
    );
  }

  // ── Paginated: refresh ──
  Future<void> _onRefresh(Emitter<CustomerState> emit) async {
    final result = await _getCustomersPaginated(limit: _pageSize);
    result.fold(
      (f) => emit(CustomerState.error(f.message)),
      (paginated) => emit(CustomerState.paginatedLoaded(
        customers: paginated.items,
        hasMore: paginated.hasMore,
        lastDocument: paginated.lastDocument,
      )),
    );
  }

  Future<void> _onAddCustomer(
    _AddCustomer event, Emitter<CustomerState> emit,
  ) async {
    emit(const CustomerState.loading());
    final result = await _addCustomer(event.customer);
    result.fold(
      (f) => emit(CustomerState.error(f.message)),
      (_) {
        emit(const CustomerState.actionSuccess('Đã thêm khách hàng'));
        add(const CustomerEvent.loadCustomersPaginated());
      },
    );
  }

  Future<void> _onUpdateCustomer(
    _UpdateCustomer event, Emitter<CustomerState> emit,
  ) async {
    emit(const CustomerState.loading());
    final result = await _updateCustomer(event.customer);
    result.fold(
      (f) => emit(CustomerState.error(f.message)),
      (_) {
        emit(const CustomerState.actionSuccess('Đã cập nhật khách hàng'));
        add(const CustomerEvent.loadCustomersPaginated());
      },
    );
  }

  Future<void> _onDeleteCustomer(
    _DeleteCustomer event, Emitter<CustomerState> emit,
  ) async {
    emit(const CustomerState.loading());
    final result = await _deleteCustomer(event.customerId);
    result.fold(
      (f) => emit(CustomerState.error(f.message)),
      (_) {
        emit(const CustomerState.actionSuccess('Đã xóa khách hàng'));
        add(const CustomerEvent.loadCustomersPaginated());
      },
    );
  }

  Future<void> _onLoadDebts(
    _LoadDebts event, Emitter<CustomerState> emit,
  ) async {
    emit(const CustomerState.loading());
    final result = await _getDebts(event.customerId);
    result.fold(
      (f) => emit(CustomerState.error(f.message)),
      (records) => emit(CustomerState.debtsLoaded(
        customer: event.customer,
        records: records,
      )),
    );
  }

  Future<void> _onMakePayment(
    _MakePayment event, Emitter<CustomerState> emit,
  ) async {
    emit(const CustomerState.loading());
    final result = await _makePayment(
      customerId: event.customerId,
      amount: event.amount,
      note: event.note,
    );
    result.fold(
      (f) => emit(CustomerState.error(f.message)),
      (_) => emit(const CustomerState.actionSuccess('Đã ghi nhận thanh toán')),
    );
  }

  Future<void> _onSettleAll(
    _SettleAll event, Emitter<CustomerState> emit,
  ) async {
    emit(const CustomerState.loading());
    final result = await _settleAll(event.customerId);
    result.fold(
      (f) => emit(CustomerState.error(f.message)),
      (_) => emit(const CustomerState.actionSuccess('Đã tất toán công nợ')),
    );
  }

  Future<void> _onAddMultipleCustomers(
    _AddMultipleCustomers event, Emitter<CustomerState> emit,
  ) async {
    emit(const CustomerState.loading());
    int successCount = 0;
    int failCount = 0;

    for (final customer in event.customers) {
      final result = await _addCustomer(customer);
      result.fold(
        (_) => failCount++,
        (_) => successCount++,
      );
    }

    if (failCount == 0) {
      emit(CustomerState.actionSuccess(
        'Đã thêm $successCount khách hàng từ danh bạ',
      ));
    } else {
      emit(CustomerState.actionSuccess(
        'Đã thêm $successCount, thất bại $failCount khách hàng',
      ));
    }
    add(const CustomerEvent.loadCustomersPaginated());
  }
}
