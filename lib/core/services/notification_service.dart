import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Shared messenger used for in-app reminders on Web, where OS scheduling is
/// unavailable and browser permission prompts must be tied to a user gesture.
final GlobalKey<ScaffoldMessengerState> notificationMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

/// Service for managing daily report reminder notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  Timer? _webReminderTimer;

  static const int _dailyReportNotificationId = 1001;
  static const String _channelId = 'daily_report_reminder';
  static const String _channelName = 'Nhắc báo cáo hàng ngày';
  static const String _channelDescription =
      'Nhắc nhở báo cáo nhập xuất kho hàng ngày';

  /// Initialize notification plugin and timezone data
  Future<void> init() async {
    if (kIsWeb) return;

    // Initialize timezone database (required for zonedSchedule)
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create Android notification channel
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            _channelName,
            description: _channelDescription,
            importance: Importance.high,
          ),
        );
  }

  /// Request notification permission (iOS / Android 13+)
  Future<bool> requestPermission() async {
    // Web reminders are shown in-app and don't request browser permissions.
    if (kIsWeb) return true;

    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    }

    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      final granted = await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return true;
  }

  /// Schedule daily reminder at specified time using OS-level scheduling.
  ///
  /// Uses [zonedSchedule] with [DateTimeComponents.time] so the OS
  /// delivers the notification every day at the given hour:minute,
  /// even when the app is suspended or terminated — critical for iOS.
  Future<void> scheduleDailyReminder({int hour = 20, int minute = 0}) async {
    if (kIsWeb) {
      _scheduleWebReminder(hour: hour, minute: minute);
      return;
    }

    // Cancel any existing reminder first
    await cancelDailyReminder();

    // Build the next occurrence of hour:minute in the local timezone
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If the time has already passed today, push to tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      styleInformation: BigTextStyleInformation(
        'Đã đến giờ báo cáo! Hãy kiểm tra và xác nhận các giao dịch nhập xuất trong ngày.',
        contentTitle: '📊 Nhắc nhở báo cáo hàng ngày',
      ),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.zonedSchedule(
      id: _dailyReportNotificationId,
      title: '📊 Nhắc nhở báo cáo hàng ngày',
      body: 'Đã đến giờ báo cáo! Kiểm tra giao dịch nhập xuất trong ngày.',
      scheduledDate: scheduledDate,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Show the reminder notification immediately
  Future<void> _showReminderNotification() async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      styleInformation: BigTextStyleInformation(
        'Đã đến giờ báo cáo! Hãy kiểm tra và xác nhận các giao dịch nhập xuất trong ngày.',
        contentTitle: '📊 Nhắc nhở báo cáo hàng ngày',
      ),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      id: _dailyReportNotificationId,
      title: '📊 Nhắc nhở báo cáo hàng ngày',
      body: 'Đã đến giờ báo cáo! Kiểm tra giao dịch nhập xuất trong ngày.',
      notificationDetails: details,
    );
  }

  /// Cancel daily reminder
  Future<void> cancelDailyReminder() async {
    if (kIsWeb) {
      _webReminderTimer?.cancel();
      _webReminderTimer = null;
      return;
    }
    await _plugin.cancel(id: _dailyReportNotificationId);
  }

  /// Show a test notification (for debugging)
  Future<void> showTestNotification() async {
    if (kIsWeb) {
      _showWebReminder();
      return;
    }
    await _showReminderNotification();
  }

  void _scheduleWebReminder({required int hour, required int minute}) {
    _webReminderTimer?.cancel();
    final now = DateTime.now();
    var next = DateTime(now.year, now.month, now.day, hour, minute);
    if (!next.isAfter(now)) next = next.add(const Duration(days: 1));

    _webReminderTimer = Timer(next.difference(now), () {
      _showWebReminder();
      _scheduleWebReminder(hour: hour, minute: minute);
    });
  }

  void _showWebReminder() {
    notificationMessengerKey.currentState?.showSnackBar(
      const SnackBar(
        content: Text(
          'Đến giờ tổng kết giao dịch trong ngày. Mở báo cáo để kiểm tra.',
        ),
        duration: Duration(seconds: 12),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap — navigate to daily report page
    // This will be handled by the app's navigation system
    debugPrint('Notification tapped: ${response.payload}');
  }
}
