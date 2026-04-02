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
  final CreateExportOrder _createExport;
  final CreateImportOrder _createImport;

  TransactionBloc({
    required GetTransactionHistory getHistory,
    required CreateExportOrder createExport,
    required CreateImportOrder createImport,
  })  : _getHistory = getHistory,
        _createExport = createExport,
        _createImport = createImport,
        super(const TransactionState.initial()) {
    on<TransactionEvent>((event, emit) async {
      await event.map(
        loadHistory: (e) => _onLoadHistory(e, emit),
        createExport: (e) => _onCreateExport(e, emit),
        createImport: (e) => _onCreateImport(e, emit),
      );
    });
  }

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
}
