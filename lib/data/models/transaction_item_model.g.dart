// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionItemModel _$TransactionItemModelFromJson(
  Map<String, dynamic> json,
) => _TransactionItemModel(
  id: json['id'] as String? ?? '',
  productId: json['product_id'] as String,
  productName: json['product_name'] as String,
  category: json['category'] as String,
  regulationClass: json['regulation_class'] as String,
  quantity: (json['quantity'] as num).toInt(),
  unitPriceAtTime: (json['unit_price_at_time'] as num).toDouble(),
  subtotal: (json['subtotal'] as num).toDouble(),
);

Map<String, dynamic> _$TransactionItemModelToJson(
  _TransactionItemModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'product_id': instance.productId,
  'product_name': instance.productName,
  'category': instance.category,
  'regulation_class': instance.regulationClass,
  'quantity': instance.quantity,
  'unit_price_at_time': instance.unitPriceAtTime,
  'subtotal': instance.subtotal,
};
