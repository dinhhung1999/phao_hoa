import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_paths.dart';

/// Application-wide constants
class AppConstants {
  AppConstants._();

  static const String appName = 'Quản lý Kho Pháo Hoa';

  /// Warehouse location keys and names — loaded dynamically from Firestore 'warehouses' collection.
  /// These are populated at startup via [loadWarehouseNames].
  static List<String> warehouseLocationKeys = [];
  static List<String> warehouseLocationNames = [];

  /// Load warehouse keys and names from the 'warehouses' Firestore collection.
  /// Call at app startup after seedDefaultWarehouses.
  static Future<void> loadWarehouseNames() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection(FirestorePaths.warehouses)
          .where('is_active', isEqualTo: true)
          .orderBy('created_at')
          .get();

      warehouseLocationKeys = snap.docs.map((d) => d.id).toList();
      warehouseLocationNames = snap.docs.map((d) {
        final data = d.data();
        return (data['name'] as String?) ?? d.id;
      }).toList();

      // Fallback if no warehouses exist
      if (warehouseLocationKeys.isEmpty) {
        warehouseLocationKeys = ['kho_1', 'kho_2', 'kho_3'];
        warehouseLocationNames = ['Kho 1', 'Kho 2', 'Kho 3'];
      }
    } catch (_) {
      // Fallback to defaults on error — app still works
      if (warehouseLocationKeys.isEmpty) {
        warehouseLocationKeys = ['kho_1', 'kho_2', 'kho_3'];
        warehouseLocationNames = ['Kho 1', 'Kho 2', 'Kho 3'];
      }
    }
  }

  /// Get display name for a location key
  static String getDisplayName(String locationKey) {
    final index = warehouseLocationKeys.indexOf(locationKey);
    if (index >= 0 && index < warehouseLocationNames.length) {
      return warehouseLocationNames[index];
    }
    return locationKey;
  }

  /// Get location key for a display name
  static String getLocationKey(String displayName) {
    final index = warehouseLocationNames.indexOf(displayName);
    if (index >= 0 && index < warehouseLocationKeys.length) {
      return warehouseLocationKeys[index];
    }
    // Fallback: convert display name to key format
    return displayName.toLowerCase().replaceAll(' ', '_');
  }

  /// Daily reminder time (HH:mm)
  static const String defaultReminderTime = '20:00';

  /// FCM topic for daily reminders
  static const String dailyReminderTopic = 'daily_reminder';

  /// PCCC Checklist default items
  static const List<Map<String, dynamic>> defaultChecklistItems = [
    {'label': 'Kiểm tra hệ thống báo cháy', 'required': true},
    {
      'label': 'Kiểm tra bình chữa cháy (còn hạn, áp suất đủ)',
      'required': true,
    },
    {
      'label': 'Kiểm tra lối thoát hiểm (không bị chặn)',
      'required': true,
    },
    {'label': 'Kiểm tra nhiệt độ kho (< 35°C)', 'required': true},
    {'label': 'Kiểm tra độ ẩm kho', 'required': true},
    {'label': 'Kiểm tra camera an ninh hoạt động', 'required': false},
    {
      'label': 'Kiểm tra hệ thống điện (không rò rỉ)',
      'required': true,
    },
    {
      'label': 'Kiểm tra biển báo cấm lửa, cấm hút thuốc',
      'required': true,
    },
  ];
}
