import 'package:equatable/equatable.dart';

/// Domain entity representing a customer
class Customer extends Equatable {
  final String id;
  final String name;
  final String? phone;
  final String type; // 'khach_quen' | 'khach_le'
  final double totalDebt;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? updatedBy;

  const Customer({
    required this.id,
    required this.name,
    this.phone,
    required this.type,
    this.totalDebt = 0,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.updatedBy,
  });

  bool get hasDebt => totalDebt > 0;

  @override
  List<Object?> get props => [id, name, type, totalDebt, isActive, updatedBy];
}

