part of 'transaction_bloc.dart';

@freezed
sealed class TransactionEvent with _$TransactionEvent {
  const factory TransactionEvent.loadHistory({
    DateTime? startDate,
    DateTime? endDate,
    String? type,
    String? warehouseLocation,
  }) = _LoadHistory;

  const factory TransactionEvent.createExport({
    required entity.Transaction transaction,
    required List<TransactionItem> items,
  }) = _CreateExport;

  const factory TransactionEvent.createImport({
    required entity.Transaction transaction,
    required List<TransactionItem> items,
  }) = _CreateImport;
}
