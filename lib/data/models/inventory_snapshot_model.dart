import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/utils/firestore_converters.dart';

part 'inventory_snapshot_model.freezed.dart';
part 'inventory_snapshot_model.g.dart';

@freezed
abstract class InventorySnapshotModel with _$InventorySnapshotModel {
  const factory InventorySnapshotModel({
    @Default('') String id,
    @JsonKey(name: 'date', fromJson: timestampFromJson, toJson: timestampToJson)
    required DateTime date,
    @JsonKey(name: 'created_by') required String createdBy,
    required String status,
    String? notes,
    @JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson)
    required DateTime createdAt,
  }) = _InventorySnapshotModel;

  factory InventorySnapshotModel.fromJson(Map<String, dynamic> json) =>
      _$InventorySnapshotModelFromJson(json);

  factory InventorySnapshotModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return InventorySnapshotModel.fromJson({...data, 'id': doc.id});
  }
}


