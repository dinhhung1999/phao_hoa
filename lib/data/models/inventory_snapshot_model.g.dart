// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_snapshot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InventorySnapshotModel _$InventorySnapshotModelFromJson(
  Map<String, dynamic> json,
) => _InventorySnapshotModel(
  id: json['id'] as String? ?? '',
  date: timestampFromJson(json['date']),
  createdBy: json['created_by'] as String,
  status: json['status'] as String,
  notes: json['notes'] as String?,
  createdAt: timestampFromJson(json['created_at']),
);

Map<String, dynamic> _$InventorySnapshotModelToJson(
  _InventorySnapshotModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'date': timestampToJson(instance.date),
  'created_by': instance.createdBy,
  'status': instance.status,
  'notes': instance.notes,
  'created_at': timestampToJson(instance.createdAt),
};
