/// Application-wide constants
class AppConstants {
  AppConstants._();

  static const String appName = 'Quản lý Kho Pháo Hoa';

  /// Default warehouse locations
  static const List<String> warehouseLocationNames = [
    'Kho 1',
    'Kho 2',
    'Kho 3',
  ];

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
