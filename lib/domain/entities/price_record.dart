import 'package:equatable/equatable.dart';

/// Domain entity representing a price record for a product
class PriceRecord extends Equatable {
  final String id;
  final String productId;
  final double importPrice;
  final double exportPrice;
  final String? updatedBy;
  final DateTime recordedAt;

  const PriceRecord({
    required this.id,
    required this.productId,
    required this.importPrice,
    required this.exportPrice,
    this.updatedBy,
    required this.recordedAt,
  });

  /// Profit per unit at this price point
  double get profitPerUnit => exportPrice - importPrice;

  /// Profit margin percentage
  double get profitMargin =>
      importPrice > 0 ? (profitPerUnit / importPrice) * 100 : 0;

  @override
  List<Object?> get props => [id, productId, importPrice, exportPrice, recordedAt];
}
