import 'package:equatable/equatable.dart';

/// Domain entity representing a fireworks product
class Product extends Equatable {
  final String id;
  final String name;
  final String category;
  final String regulationClass; // A, B, C per NĐ 137
  final String unit;
  final double importPrice;
  final double exportPrice;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? updatedBy;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.regulationClass,
    required this.unit,
    required this.importPrice,
    required this.exportPrice,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.updatedBy,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    category,
    regulationClass,
    unit,
    importPrice,
    exportPrice,
    isActive,
    updatedBy,
  ];
}

