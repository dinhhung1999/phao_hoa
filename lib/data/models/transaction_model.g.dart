// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    _TransactionModel(
      id: json['id'] as String? ?? '',
      type: json['type'] as String,
      customerId: json['customer_id'] as String?,
      customerName: json['customer_name'] as String,
      customerType: json['customer_type'] as String,
      warehouseLocation: json['warehouse_location'] as String,
      isDebt: json['is_debt'] as bool? ?? false,
      totalValue: (json['total_value'] as num).toDouble(),
      paidAmount: (json['paid_amount'] as num).toDouble(),
      note: json['note'] as String?,
      createdAt: timestampFromJson(json['created_at']),
      createdBy: json['created_by'] as String,
    );

Map<String, dynamic> _$TransactionModelToJson(_TransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'customer_id': instance.customerId,
      'customer_name': instance.customerName,
      'customer_type': instance.customerType,
      'warehouse_location': instance.warehouseLocation,
      'is_debt': instance.isDebt,
      'total_value': instance.totalValue,
      'paid_amount': instance.paidAmount,
      'note': instance.note,
      'created_at': timestampToJson(instance.createdAt),
      'created_by': instance.createdBy,
    };
