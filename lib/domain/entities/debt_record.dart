import 'package:equatable/equatable.dart';

/// Domain entity representing a debt record (either debt or payment)
class DebtRecord extends Equatable {
  final String id;
  final String? transactionId;
  final String type; // 'debt' | 'payment'
  final double amount;
  final double runningBalance;
  final String? note;
  final DateTime createdAt;

  const DebtRecord({
    required this.id,
    this.transactionId,
    required this.type,
    required this.amount,
    required this.runningBalance,
    this.note,
    required this.createdAt,
  });

  bool get isDebt => type == 'debt';
  bool get isPayment => type == 'payment';

  @override
  List<Object?> get props => [id, type, amount, runningBalance, createdAt];
}
