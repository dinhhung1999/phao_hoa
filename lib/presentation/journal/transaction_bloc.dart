import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/transaction.dart' as entity;
import '../../domain/entities/transaction_item.dart';
import '../../domain/usecases/transaction/transaction_usecases.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';
part 'transaction_bloc.freezed.dart';


class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final GetTransactionHistory _getHistory;
  final GetTransactionHistoryPaginated _getHistoryPaginated;
  final CreateExportOrder _createExport;
  final CreateImportOrder _createImport;
  final UpdateDebtPayment _updateDebtPayment;
  final GetTransactionsByProductId _getByProductId;
  final UpdateTransaction _updateTransaction;

  static const int _pageSize = 20;

  TransactionBloc({
    required GetTransactionHistory getHistory,
    required GetTransactionHistoryPaginated getHistoryPaginated,
    required CreateExportOrder createExport,
    required CreateImportOrder createImport,
    required UpdateDebtPayment updateDebtPayment,
    required GetTransactionsByProductId getByProductId,
    required UpdateTransaction updateTransaction,
  })  : _getHistory = getHistory,
        _getHistoryPaginated = getHistoryPaginated,
        _createExport = createExport,
        _createImport = createImport,
        _updateDebtPayment = updateDebtPayment,
        _getByProductId = getByProductId,
        _updateTransaction = updateTransaction,
        super(const TransactionState.initial()) {
    on<TransactionEvent>((event, emit) async {
      await event.map(
        loadHistory: (e) => _onLoadHistory(e, emit),
        createExport: (e) => _onCreateExport(e, emit),
        createImport: (e) => _onCreateImport(e, emit),
        loadHistoryPaginated: (e) => _onLoadPaginated(e, emit),
        loadMoreHistory: (_) => _onLoadMore(emit),
        refreshHistory: (e) => _onRefresh(e, emit),
        updateDebtPayment: (e) => _onUpdateDebt(e, emit),
        loadByProductId: (e) => _onLoadByProductId(e, emit),
        editTransaction: (e) => _onEditTransaction(e, emit),
      );
    });
  }

  // ── Legacy: load all (used by date-specific queries) ──
  Future<void> _onLoadHistory(
    _LoadHistory event, Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionState.loading());
    final result = await _getHistory(
      startDate: event.startDate,
      endDate: event.endDate,
      type: event.type,
      warehouseLocation: event.warehouseLocation,
    );
    result.fold(
      (f) => emit(TransactionState.error(f.message)),
      (txs) => emit(TransactionState.historyLoaded(txs)),
    );
  }

  // ── Paginated: first page ──
  Future<void> _onLoadPaginated(
    _LoadHistoryPaginated event, Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionState.loading());
    final result = await _getHistoryPaginated(
      startDate: event.startDate,
      endDate: event.endDate,
      type: event.type,
      warehouseLocation: event.warehouseLocation,
      limit: _pageSize,
    );
    result.fold(
      (f) => emit(TransactionState.error(f.message)),
      (paginated) => emit(TransactionState.paginatedHistoryLoaded(
        transactions: paginated.items,
        hasMore: paginated.hasMore,
        lastDocument: paginated.lastDocument,
        startDate: event.startDate,
        endDate: event.endDate,
        type: event.type,
        warehouseLocation: event.warehouseLocation,
      )),
    );
  }

  // ── Paginated: load more ──
  Future<void> _onLoadMore(Emitter<TransactionState> emit) async {
    final current = state;
    if (current is! _PaginatedHistoryLoaded || !current.hasMore || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true));

    final result = await _getHistoryPaginated(
      startDate: current.startDate,
      endDate: current.endDate,
      type: current.type,
      warehouseLocation: current.warehouseLocation,
      limit: _pageSize,
      startAfter: current.lastDocument,
    );

    result.fold(
      (f) => emit(current.copyWith(isLoadingMore: false, error: f.message)),
      (paginated) => emit(TransactionState.paginatedHistoryLoaded(
        transactions: [...current.transactions, ...paginated.items],
        hasMore: paginated.hasMore,
        lastDocument: paginated.lastDocument,
        startDate: current.startDate,
        endDate: current.endDate,
        type: current.type,
        warehouseLocation: current.warehouseLocation,
        isLoadingMore: false,
      )),
    );
  }

  // ── Paginated: refresh ──
  Future<void> _onRefresh(
    _RefreshHistory event, Emitter<TransactionState> emit,
  ) async {
    final result = await _getHistoryPaginated(
      startDate: event.startDate,
      endDate: event.endDate,
      type: event.type,
      warehouseLocation: event.warehouseLocation,
      limit: _pageSize,
    );
    result.fold(
      (f) => emit(TransactionState.error(f.message)),
      (paginated) => emit(TransactionState.paginatedHistoryLoaded(
        transactions: paginated.items,
        hasMore: paginated.hasMore,
        lastDocument: paginated.lastDocument,
        startDate: event.startDate,
        endDate: event.endDate,
        type: event.type,
        warehouseLocation: event.warehouseLocation,
      )),
    );
  }

  Future<void> _onCreateExport(
    _CreateExport event, Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionState.loading());
    final result = await _createExport(
      transaction: event.transaction,
      items: event.items,
    );
    result.fold(
      (f) => emit(TransactionState.error(f.message)),
      (id) => emit(TransactionState.created(id)),
    );
  }

  Future<void> _onCreateImport(
    _CreateImport event, Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionState.loading());
    final result = await _createImport(
      transaction: event.transaction,
      items: event.items,
    );
    result.fold(
      (f) => emit(TransactionState.error(f.message)),
      (id) => emit(TransactionState.created(id)),
    );
  }

  Future<void> _onUpdateDebt(
    _UpdateDebtPayment event, Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionState.loading());
    final result = await _updateDebtPayment(
      transactionId: event.transactionId,
      newPaidAmount: event.newPaidAmount,
      totalValue: event.totalValue,
      customerId: event.customerId,
      previousPaidAmount: event.previousPaidAmount,
    );
    result.fold(
      (f) => emit(TransactionState.error(f.message)),
      (_) => emit(TransactionState.debtUpdated(event.transactionId)),
    );
  }

  Future<void> _onLoadByProductId(
    _LoadByProductId event, Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionState.loading());
    final result = await _getByProductId(event.productId, limit: event.limit);
    result.fold(
      (f) => emit(TransactionState.error(f.message)),
      (txs) => emit(TransactionState.historyLoaded(txs)),
    );
  }

  Future<void> _onEditTransaction(
    _EditTransaction event, Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionState.loading());
    final result = await _updateTransaction(
      oldTransaction: event.oldTransaction,
      oldItems: event.oldItems,
      newTransaction: event.newTransaction,
      newItems: event.newItems,
    );
    result.fold(
      (f) => emit(TransactionState.error(f.message)),
      (_) => emit(TransactionState.updated(event.oldTransaction.id)),
    );
  }
}
