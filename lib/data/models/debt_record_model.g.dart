// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DebtRecordModel _$DebtRecordModelFromJson(Map<String, dynamic> json) =>
    _DebtRecordModel(
      id: json['id'] as String? ?? '',
      transactionId: json['transaction_id'] as String?,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      runningBalance: (json['running_balance'] as num).toDouble(),
      note: json['note'] as String?,
      createdAt: timestampFromJson(json['created_at']),
    );

Map<String, dynamic> _$DebtRecordModelToJson(_DebtRecordModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transaction_id': instance.transactionId,
      'type': instance.type,
      'amount': instance.amount,
      'running_balance': instance.runningBalance,
      'note': instance.note,
      'created_at': timestampToJson(instance.createdAt),
    };
