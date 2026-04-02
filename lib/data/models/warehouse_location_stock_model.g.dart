// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warehouse_location_stock_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WarehouseLocationStockModel _$WarehouseLocationStockModelFromJson(
  Map<String, dynamic> json,
) => _WarehouseLocationStockModel(
  id: json['id'] as String? ?? '',
  productId: json['product_id'] as String,
  productName: json['product_name'] as String,
  totalQuantity: (json['total_quantity'] as num).toInt(),
  stockByLocation: Map<String, int>.from(json['stock_by_location'] as Map),
  lastUpdated: timestampFromJson(json['last_updated']),
  updatedBy: json['updated_by'] as String?,
);

Map<String, dynamic> _$WarehouseLocationStockModelToJson(
  _WarehouseLocationStockModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'product_id': instance.productId,
  'product_name': instance.productName,
  'total_quantity': instance.totalQuantity,
  'stock_by_location': instance.stockByLocation,
  'last_updated': timestampToJson(instance.lastUpdated),
  'updated_by': instance.updatedBy,
};
