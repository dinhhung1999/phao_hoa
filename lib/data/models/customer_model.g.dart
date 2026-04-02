// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomerModel _$CustomerModelFromJson(Map<String, dynamic> json) =>
    _CustomerModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String,
      phone: json['phone'] as String?,
      type: json['type'] as String,
      totalDebt: (json['total_debt'] as num?)?.toDouble() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: timestampFromJson(json['created_at']),
      updatedAt: timestampFromJson(json['updated_at']),
      updatedBy: json['updated_by'] as String?,
    );

Map<String, dynamic> _$CustomerModelToJson(_CustomerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'type': instance.type,
      'total_debt': instance.totalDebt,
      'is_active': instance.isActive,
      'created_at': timestampToJson(instance.createdAt),
      'updated_at': timestampToJson(instance.updatedAt),
      'updated_by': instance.updatedBy,
    };
