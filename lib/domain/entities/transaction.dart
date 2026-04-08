import 'package:equatable/equatable.dart';
import 'transaction_item.dart';

/// Domain entity representing a warehouse transaction (import/export)
class Transaction extends Equatable {
  final String id;
  final String type; // 'nhap' | 'xuat'
  final String? customerId;
  final String customerName;
  final String customerType;
  final String warehouseLocation;
  final bool isDebt;
  final int totalQuantity;
  final double totalValue;
  final double paidAmount;
  final String? note;
  final DateTime createdAt;
  final String createdBy;
  final List<Map<String, dynamic>> itemsSummary;
  final List<TransactionItem> items;

  const Transaction({
    required this.id,
    required this.type,
    this.customerId,
    required this.customerName,
    required this.customerType,
    required this.warehouseLocation,
    this.isDebt = false,
    this.totalQuantity = 0,
    required this.totalValue,
    required this.paidAmount,
    this.note,
    required this.createdAt,
    required this.createdBy,
    this.itemsSummary = const [],
    this.items = const [],
  });

  double get unpaidAmount => totalValue - paidAmount;

  @override
  List<Object?> get props => [
    id,
    type,
    customerId,
    customerName,
    warehouseLocation,
    totalValue,
    createdAt,
  ];
}
