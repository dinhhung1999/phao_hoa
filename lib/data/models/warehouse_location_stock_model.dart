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
    // Ensure stock_by_location values are ints and normalize keys
    final rawStock = data['stock_by_location'] as Map<String, dynamic>? ?? {};
    final normalizedStock = <String, int>{};
    for (final entry in rawStock.entries) {
      // Normalize key: 'Kho 1' → 'kho_1', 'kho_1' stays 'kho_1'
      final key = entry.key.startsWith('kho_')
          ? entry.key
          : entry.key.toLowerCase().replaceAll(' ', '_');
      final value = (entry.value as num).toInt();
      // Merge values: if both 'Kho 1' and 'kho_1' exist, sum them
      normalizedStock[key] = (normalizedStock[key] ?? 0) + value;
    }
    return WarehouseLocationStockModel.fromJson({
      ...data,
      'id': doc.id,
      'stock_by_location': normalizedStock,
    });
  }
}


