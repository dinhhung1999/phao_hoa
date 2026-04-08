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

  // Pagination events
  const factory TransactionEvent.loadHistoryPaginated({
    DateTime? startDate,
    DateTime? endDate,
    String? type,
    String? warehouseLocation,
  }) = _LoadHistoryPaginated;

  const factory TransactionEvent.loadMoreHistory() = _LoadMoreHistory;

  const factory TransactionEvent.refreshHistory({
    DateTime? startDate,
    DateTime? endDate,
    String? type,
    String? warehouseLocation,
  }) = _RefreshHistory;

  const factory TransactionEvent.updateDebtPayment({
    required String transactionId,
    required double newPaidAmount,
    required double totalValue,
    String? customerId,
    required double previousPaidAmount,
  }) = _UpdateDebtPayment;
}
