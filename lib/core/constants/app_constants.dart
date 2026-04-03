import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_paths.dart';

/// Application-wide constants
class AppConstants {
  AppConstants._();

  static const String appName = 'Quản lý Kho Pháo Hoa';

  /// Warehouse location storage keys (DO NOT change these — they are Firestore keys)
  static const List<String> warehouseLocationKeys = [
    'kho_1',
    'kho_2',
    'kho_3',
  ];

  /// Default warehouse display names (can be overridden via Firestore settings)
  static const List<String> defaultWarehouseNames = [
    'Kho 1',
    'Kho 2',
    'Kho 3',
  ];

  /// Current warehouse display names — loaded from Firestore at startup
  static List<String> warehouseLocationNames = List.from(defaultWarehouseNames);

  /// Load warehouse names from Firestore (call at app startup)
  static Future<void> loadWarehouseNames() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection(FirestorePaths.appConfig)
          .doc(FirestorePaths.warehouseConfigDoc)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        final names = data['warehouse_names'] as Map<String, dynamic>?;
        if (names != null) {
          for (int i = 0; i < warehouseLocationKeys.length; i++) {
            final key = warehouseLocationKeys[i];
            if (names.containsKey(key)) {
              warehouseLocationNames[i] = names[key] as String;
            }
          }
        }
      }
    } catch (_) {
      // Fallback to defaults on error — app still works
    }
  }

  /// Save warehouse names to Firestore (called from settings)
  static Future<void> saveWarehouseNames(List<String> names) async {
    final Map<String, String> nameMap = {};
    for (int i = 0; i < warehouseLocationKeys.length; i++) {
      nameMap[warehouseLocationKeys[i]] = names[i];
      warehouseLocationNames[i] = names[i];
    }

    await FirebaseFirestore.instance
        .collection(FirestorePaths.appConfig)
        .doc(FirestorePaths.warehouseConfigDoc)
        .set({
      'warehouse_names': nameMap,
      'updated_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
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
