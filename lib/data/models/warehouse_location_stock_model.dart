import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/constants/app_constants.dart';
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
    // ── Step 1: Recover corrupted flat fields ──
    // Due to a bug where batch.set() + merge:true treated dot-notation keys as
    // literal field names, we may have flat fields like 'stock_by_location.kho_1'
    // at the root level instead of nested fields inside 'stock_by_location' map.
    final rawStock = <String, dynamic>{
      ...(data['stock_by_location'] as Map<String, dynamic>? ?? {}),
    };
    // Scan for flat dot-notation fields at root level and merge them
    for (final key in data.keys) {
      if (key.startsWith('stock_by_location.') && key.length > 'stock_by_location.'.length) {
        final locationKey = key.substring('stock_by_location.'.length);
        final value = data[key];
        if (value is num) {
          // Merge into existing stock, preferring the flat field value as it's more recent
          final existingValue = rawStock[locationKey];
          if (existingValue == null) {
            rawStock[locationKey] = value.toInt();
          } else {
            // If both exist, use the flat field value (it's the intended increment result)
            rawStock[locationKey] = value.toInt();
          }

        }
      }
    }

    // ── Step 2: Normalize keys ──
    final knownKeys = AppConstants.warehouseLocationKeys;
    final knownNames = AppConstants.warehouseLocationNames;
    final normalizedStock = <String, int>{};
    for (final entry in rawStock.entries) {
      String key = entry.key;
      final value = (entry.value as num).toInt();

      if (knownKeys.contains(key)) {
        // Key is already a known warehouse key (doc ID or 'kho_1' etc.) — keep as-is
      } else {
        // Try to resolve the key:
        // 1. Check if it's a display name (e.g. 'Kho 1 hung') → map to its doc ID key
        final nameIndex = knownNames.indexOf(key);
        if (nameIndex >= 0 && nameIndex < knownKeys.length) {
          key = knownKeys[nameIndex];
        }
        // 2. Check if it's a legacy display name with spaces (e.g. 'Kho 1') → normalize
        else if (key.contains(' ')) {
          final normalized = key.toLowerCase().replaceAll(' ', '_');
          // If normalized form matches a known key, use it
          if (knownKeys.contains(normalized)) {
            key = normalized;
          } else {
            // Try matching the normalized form to a known key by checking names
            final nameIdx2 = knownNames.indexWhere(
              (n) => n.toLowerCase().replaceAll(' ', '_') == normalized,
            );
            if (nameIdx2 >= 0 && nameIdx2 < knownKeys.length) {
              key = knownKeys[nameIdx2];
            } else {
              key = normalized;
            }
          }
        }
        // 3. Check if it's a fallback key like 'kho_1_hung' that was generated
        //    by getLocationKey fallback — try to match back to known key
        else if (key.startsWith('kho_')) {
          // Try to find a known name whose fallback form would match this key
          for (int i = 0; i < knownNames.length; i++) {
            final fallbackKey = knownNames[i].toLowerCase().replaceAll(' ', '_');
            if (fallbackKey == key && i < knownKeys.length) {
              key = knownKeys[i];
              break;
            }
          }
        }
        // 4. Otherwise keep the key unchanged (auto-generated IDs, etc.)
      }

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


