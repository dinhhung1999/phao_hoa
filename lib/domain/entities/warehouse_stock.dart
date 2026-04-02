import 'package:equatable/equatable.dart';

/// Domain entity for inventory stock at a specific location
class WarehouseStock extends Equatable {
  final String productId;
  final String productName;
  final int totalQuantity;
  final Map<String, int> stockByLocation; // kho_1, kho_2, kho_3
  final String? updatedBy;

  const WarehouseStock({
    required this.productId,
    required this.productName,
    required this.totalQuantity,
    required this.stockByLocation,
    this.updatedBy,
  });

  int getStockAt(String location) => stockByLocation[location] ?? 0;

  @override
  List<Object?> get props => [productId, totalQuantity, stockByLocation, updatedBy];
}

