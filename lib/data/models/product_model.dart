import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/utils/firestore_converters.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
abstract class ProductModel with _$ProductModel {
  const factory ProductModel({
    @Default('') String id,
    required String name,
    required String category,
    @JsonKey(name: 'regulation_class') required String regulationClass,
    required String unit,
    @JsonKey(name: 'import_price') required double importPrice,
    @JsonKey(name: 'export_price') required double exportPrice,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson)
    required DateTime createdAt,
    @JsonKey(name: 'updated_at', fromJson: timestampFromJson, toJson: timestampToJson)
    required DateTime updatedAt,
    @JsonKey(name: 'updated_by') String? updatedBy,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  /// Create from Firestore document snapshot
  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel.fromJson({...data, 'id': doc.id});
  }
}


