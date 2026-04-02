// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductModel _$ProductModelFromJson(Map<String, dynamic> json) =>
    _ProductModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String,
      category: json['category'] as String,
      regulationClass: json['regulation_class'] as String,
      unit: json['unit'] as String,
      importPrice: (json['import_price'] as num).toDouble(),
      exportPrice: (json['export_price'] as num).toDouble(),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: timestampFromJson(json['created_at']),
      updatedAt: timestampFromJson(json['updated_at']),
      updatedBy: json['updated_by'] as String?,
    );

Map<String, dynamic> _$ProductModelToJson(_ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'regulation_class': instance.regulationClass,
      'unit': instance.unit,
      'import_price': instance.importPrice,
      'export_price': instance.exportPrice,
      'is_active': instance.isActive,
      'created_at': timestampToJson(instance.createdAt),
      'updated_at': timestampToJson(instance.updatedAt),
      'updated_by': instance.updatedBy,
    };
