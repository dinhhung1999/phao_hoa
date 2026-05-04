import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/utils/firestore_converters.dart';

part 'product_formula_model.freezed.dart';
part 'product_formula_model.g.dart';

@freezed
abstract class FormulaComponentModel with _$FormulaComponentModel {
  const factory FormulaComponentModel({
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'product_name') required String productName,
    required int quantity,
  }) = _FormulaComponentModel;

  factory FormulaComponentModel.fromJson(Map<String, dynamic> json) =>
      _$FormulaComponentModelFromJson(json);
}

@freezed
abstract class ProductFormulaModel with _$ProductFormulaModel {
  const factory ProductFormulaModel({
    @Default('') String id,
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'product_name') required String productName,
    required List<FormulaComponentModel> components,
    @JsonKey(name: 'labor_cost') @Default(0) double laborCost,
    String? notes,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'updated_at', fromJson: timestampFromJson, toJson: timestampToJson)
    required DateTime updatedAt,
    @JsonKey(name: 'updated_by') String? updatedBy,
  }) = _ProductFormulaModel;

  factory ProductFormulaModel.fromJson(Map<String, dynamic> json) =>
      _$ProductFormulaModelFromJson(json);

  factory ProductFormulaModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductFormulaModel.fromJson({...data, 'id': doc.id});
  }
}
