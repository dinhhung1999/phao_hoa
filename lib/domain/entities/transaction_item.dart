import 'package:equatable/equatable.dart';

/// Domain entity for a single item within a transaction.
/// Contains a SNAPSHOT of the price at the time of the transaction.
class TransactionItem extends Equatable {
  final String id;
  final String productId;
  final String productName; // Snapshot
  final String category; // Snapshot
  final String regulationClass; // Snapshot
  final int quantity;
  final double unitPriceAtTime; // ⭐ KEY: Price snapshot at transaction time
  final double subtotal;

  const TransactionItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.category,
    required this.regulationClass,
    required this.quantity,
    required this.unitPriceAtTime,
    required this.subtotal,
  });

  @override
  List<Object?> get props => [id, productId, quantity, unitPriceAtTime];
}
