import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/utils/firestore_converters.dart';

part 'warehouse_location_stock_model.freezed.dart';
part 'warehouse_location_stock_model.g.dart';

@freezed
abstract class WarehouseLocationStockModel with _$WarehouseLocationStockModel {
  const factory WarehouseLocationStockModel({
    @Default('') String id,
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'product_name') required String productName,
    @JsonKey(name: 'total_quantity') required int totalQuantity,
    @JsonKey(name: 'stock_by_location') required Map<String, int> stockByLocation,
    @JsonKey(name: 'last_updated', fromJson: timestampFromJson, toJson: timestampToJson)
    required DateTime lastUpdated,
    @JsonKey(name: 'updated_by') String? updatedBy,
  }) = _WarehouseLocationStockModel;

  factory WarehouseLocationStockModel.fromJson(Map<String, dynamic> json) =>
      _$WarehouseLocationStockModelFromJson(json);

  factory WarehouseLocationStockModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    // Ensure stock_by_location values are ints
    final rawStock = data['stock_by_location'] as Map<String, dynamic>? ?? {};
    final stockMap = rawStock.map((k, v) => MapEntry(k, (v as num).toInt()));
    return WarehouseLocationStockModel.fromJson({
      ...data,
      'id': doc.id,
      'stock_by_location': stockMap,
    });
  }
}


