import 'package:equatable/equatable.dart';

/// Domain entity for inventory reconciliation snapshot
class InventorySnapshot extends Equatable {
  final String id;
  final DateTime date;
  final String createdBy;
  final String status; // 'completed' | 'has_discrepancy'
  final String? notes;
  final List<ReconciliationItem> items;

  const InventorySnapshot({
    required this.id,
    required this.date,
    required this.createdBy,
    required this.status,
    this.notes,
    this.items = const [],
  });

  bool get hasDiscrepancy => status == 'has_discrepancy';

  @override
  List<Object?> get props => [id, date, status];
}

/// A single product comparison in a reconciliation
class ReconciliationItem extends Equatable {
  final String productId;
  final String productName;
  final String warehouseLocation;
  final int systemQuantity;
  final int actualQuantity;
  final int difference;
  final bool isMatched;

  const ReconciliationItem({
    required this.productId,
    required this.productName,
    required this.warehouseLocation,
    required this.systemQuantity,
    required this.actualQuantity,
    required this.difference,
    required this.isMatched,
  });

  @override
  List<Object?> get props => [productId, systemQuantity, actualQuantity];
}
