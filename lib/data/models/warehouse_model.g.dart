// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warehouse_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WarehouseModel _$WarehouseModelFromJson(Map<String, dynamic> json) =>
    _WarehouseModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String,
      address: json['address'] as String?,
      area: (json['area'] as num?)?.toDouble(),
      capacity: (json['capacity'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: timestampFromJson(json['created_at']),
      updatedAt: timestampFromJson(json['updated_at']),
      updatedBy: json['updated_by'] as String?,
    );

Map<String, dynamic> _$WarehouseModelToJson(_WarehouseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'area': instance.area,
      'capacity': instance.capacity,
      'notes': instance.notes,
      'is_active': instance.isActive,
      'created_at': timestampToJson(instance.createdAt),
      'updated_at': timestampToJson(instance.updatedAt),
      'updated_by': instance.updatedBy,
    };
