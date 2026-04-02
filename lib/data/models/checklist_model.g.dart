// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChecklistModel _$ChecklistModelFromJson(Map<String, dynamic> json) =>
    _ChecklistModel(
      date: json['date'] as String,
      completedBy: json['completed_by'] as String,
      completedAt: DateTime.parse(json['completed_at'] as String),
      isPassed: json['is_passed'] as bool,
      items: (json['items'] as List<dynamic>)
          .map((e) => ChecklistItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChecklistModelToJson(_ChecklistModel instance) =>
    <String, dynamic>{
      'date': instance.date,
      'completed_by': instance.completedBy,
      'completed_at': instance.completedAt.toIso8601String(),
      'is_passed': instance.isPassed,
      'items': instance.items,
    };

_ChecklistItemModel _$ChecklistItemModelFromJson(Map<String, dynamic> json) =>
    _ChecklistItemModel(
      label: json['label'] as String,
      isChecked: json['is_checked'] as bool? ?? false,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$ChecklistItemModelToJson(_ChecklistItemModel instance) =>
    <String, dynamic>{
      'label': instance.label,
      'is_checked': instance.isChecked,
      'note': instance.note,
    };
