import 'package:equatable/equatable.dart';

/// A single component in a product formula
class FormulaComponent extends Equatable {
  final String productId;
  final String productName;
  final int quantity;

  const FormulaComponent({
    required this.productId,
    required this.productName,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, quantity];
}

/// Domain entity representing a product assembly formula.
///
/// Example: "Giàn 100 ghép = 4 Viên + 50.000₫ tiền công"
/// The assembled product's price is automatically calculated from
/// the current prices of its components plus labor cost.
class ProductFormula extends Equatable {
  final String id;
  final String productId;
  final String productName;
  final List<FormulaComponent> components;
  final double laborCost;
  final String? notes;
  final bool isActive;
  final DateTime updatedAt;
  final String? updatedBy;

  const ProductFormula({
    required this.id,
    required this.productId,
    required this.productName,
    required this.components,
    this.laborCost = 0,
    this.notes,
    this.isActive = true,
    required this.updatedAt,
    this.updatedBy,
  });

  /// Calculate the assembled price given current component prices.
  /// [priceMap] maps productId → current export price.
  double calculatePrice(Map<String, double> priceMap) {
    double total = laborCost;
    for (final comp in components) {
      final unitPrice = priceMap[comp.productId] ?? 0;
      total += comp.quantity * unitPrice;
    }
    return total;
  }

  /// Human-readable formula description
  String get formulaDescription {
    final parts = components
        .where((c) => c.quantity > 0)
        .map((c) => '${c.quantity} ${c.productName}')
        .toList();
    if (laborCost > 0) {
      parts.add('tiền công');
    }
    return parts.join(' + ');
  }

  @override
  List<Object?> get props => [id, productId, components, laborCost];
}
