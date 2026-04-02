part of 'transaction_bloc.dart';

@freezed
sealed class TransactionState with _$TransactionState {
  const factory TransactionState.initial() = _Initial;
  const factory TransactionState.loading() = _Loading;
  const factory TransactionState.historyLoaded(
    List<entity.Transaction> transactions,
  ) = _HistoryLoaded;
  const factory TransactionState.created(String transactionId) = _Created;
  const factory TransactionState.error(String message) = _Error;
}
