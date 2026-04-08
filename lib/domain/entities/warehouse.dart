import 'package:equatable/equatable.dart';

/// Domain entity representing a physical warehouse
class Warehouse extends Equatable {
  final String id;        // Firestore doc ID ('kho_1', 'kho_2', or auto-generated)
  final String name;      // Display name
  final String? address;  // Physical address
  final double? area;     // Area in m²
  final int? capacity;    // Max capacity (units)
  final String? notes;    // Free-text notes
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? updatedBy;

  const Warehouse({
    required this.id,
    required this.name,
    this.address,
    this.area,
    this.capacity,
    this.notes,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.updatedBy,
  });

  @override
  List<Object?> get props => [id, name, address, area, capacity, isActive];
}
