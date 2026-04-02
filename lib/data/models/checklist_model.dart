import 'package:freezed_annotation/freezed_annotation.dart';

part 'checklist_model.freezed.dart';
part 'checklist_model.g.dart';

@freezed
abstract class ChecklistModel with _$ChecklistModel {
  const factory ChecklistModel({
    required String date, // yyyyMMdd
    @JsonKey(name: 'completed_by') required String completedBy,
    @JsonKey(name: 'completed_at') required DateTime completedAt,
    @JsonKey(name: 'is_passed') required bool isPassed,
    required List<ChecklistItemModel> items,
  }) = _ChecklistModel;

  factory ChecklistModel.fromJson(Map<String, dynamic> json) =>
      _$ChecklistModelFromJson(json);
}

@freezed
abstract class ChecklistItemModel with _$ChecklistItemModel {
  const factory ChecklistItemModel({
    required String label,
    @JsonKey(name: 'is_checked') @Default(false) bool isChecked,
    String? note,
  }) = _ChecklistItemModel;

  factory ChecklistItemModel.fromJson(Map<String, dynamic> json) =>
      _$ChecklistItemModelFromJson(json);
}
