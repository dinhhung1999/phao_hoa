import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/utils/firestore_converters.dart';

part 'warehouse_model.freezed.dart';
part 'warehouse_model.g.dart';

@freezed
abstract class WarehouseModel with _$WarehouseModel {
  const factory WarehouseModel({
    @Default('') String id,
    required String name,
    String? address,
    double? area,
    int? capacity,
    String? notes,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson)
    required DateTime createdAt,
    @JsonKey(name: 'updated_at', fromJson: timestampFromJson, toJson: timestampToJson)
    required DateTime updatedAt,
    @JsonKey(name: 'updated_by') String? updatedBy,
  }) = _WarehouseModel;

  factory WarehouseModel.fromJson(Map<String, dynamic> json) =>
      _$WarehouseModelFromJson(json);

  factory WarehouseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WarehouseModel.fromJson({...data, 'id': doc.id});
  }
}
