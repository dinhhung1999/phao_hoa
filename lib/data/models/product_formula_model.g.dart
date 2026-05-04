// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_formula_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FormulaComponentModel _$FormulaComponentModelFromJson(
  Map<String, dynamic> json,
) => _FormulaComponentModel(
  productId: json['product_id'] as String,
  productName: json['product_name'] as String,
  quantity: (json['quantity'] as num).toInt(),
);

Map<String, dynamic> _$FormulaComponentModelToJson(
  _FormulaComponentModel instance,
) => <String, dynamic>{
  'product_id': instance.productId,
  'product_name': instance.productName,
  'quantity': instance.quantity,
};

_ProductFormulaModel _$ProductFormulaModelFromJson(Map<String, dynamic> json) =>
    _ProductFormulaModel(
      id: json['id'] as String? ?? '',
      productId: json['product_id'] as String,
      productName: json['product_name'] as String,
      components: (json['components'] as List<dynamic>)
          .map((e) => FormulaComponentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      laborCost: (json['labor_cost'] as num?)?.toDouble() ?? 0,
      notes: json['notes'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      updatedAt: timestampFromJson(json['updated_at']),
      updatedBy: json['updated_by'] as String?,
    );

Map<String, dynamic> _$ProductFormulaModelToJson(
  _ProductFormulaModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'product_id': instance.productId,
  'product_name': instance.productName,
  'components': instance.components,
  'labor_cost': instance.laborCost,
  'notes': instance.notes,
  'is_active': instance.isActive,
  'updated_at': timestampToJson(instance.updatedAt),
  'updated_by': instance.updatedBy,
};
