import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'notification_service.dart';

/// Registers this browser for warehouse activity notifications.
/// Browser permission is only requested by [enable], from a user action.
class WebPushService {
  WebPushService._();
  static final WebPushService _instance = WebPushService._();
  factory WebPushService() => _instance;

  static const vapidKey = String.fromEnvironment(
    'WEB_PUSH_VAPID_KEY',
    defaultValue:
        'BBmJcIO4ZpOBLVaCM403nhuLQlalkh8fvnzM5FhopZCByAMfJ44H9Eo1F1CMKW8QpkTVc7mf688QWGqdRMs7oEw',
  );
  static const endpoint = String.fromEnvironment(
    'WEB_PUSH_ENDPOINT',
    defaultValue:
        'https://asia-southeast1-phao-hoa-92aee.cloudfunctions.net/webPush',
  );
  static const _enabledPreference = 'web_push_enabled';

  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  String? _token;
  void Function(String path)? _openPath;
  final Set<String> _seenEvents = {};

  bool get isConfigured => vapidKey.isNotEmpty;
  bool get isRegistered => _token != null;

  Future<bool> isSupported() async {
    return kIsWeb && await FirebaseMessaging.instance.isSupported();
  }

  void listenInForeground({void Function(String path)? onOpen}) {
    _openPath = onOpen ?? _openPath;
    if (!kIsWeb || _foregroundSubscription != null) return;
    _foregroundSubscription = FirebaseMessaging.onMessage.listen((message) {
      if (FirebaseAuth.instance.currentUser == null) return;
      final data = message.data;
      final eventId = data['eventId'];
      if (eventId != null && !_seenEvents.add(eventId)) return;
      if (_seenEvents.length > 100) _seenEvents.clear();

      notificationMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            '${data['title'] ?? 'Có cập nhật mới'}\n${data['body'] ?? ''}',
          ),
          duration: const Duration(seconds: 8),
          behavior: SnackBarBehavior.floating,
          action: _openPath == null
              ? null
              : SnackBarAction(
                  label: 'Mở',
                  onPressed: () => _openPath?.call(data['path'] ?? '/journal'),
                ),
        ),
      );
    });
  }

  /// Re-registers an existing browser permission without prompting the user.
  Future<void> restoreIfAllowed() async {
    if (!isConfigured) return;
    try {
      final preferences = await SharedPreferences.getInstance();
      if (preferences.getBool(_enabledPreference) != true) return;
      if (!await isSupported()) return;
      listenInForeground();
      final settings = await FirebaseMessaging.instance
          .getNotificationSettings();
      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        return;
      }
      await _registerToken();
    } catch (error) {
      debugPrint('Could not restore Web Push registration: $error');
    }
  }

  /// Call from a button/switch gesture so browsers can show the permission UI.
  Future<void> enable() async {
    if (!isConfigured) {
      throw StateError('Chưa cấu hình Web Push VAPID key.');
    }
    if (!kIsWeb) throw StateError('Web Push chỉ dùng trên trình duyệt.');
    listenInForeground();
    // Keep this as the first asynchronous browser call after the user gesture.
    final settings = await FirebaseMessaging.instance.requestPermission();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      throw StateError('Hãy cấp quyền thông báo trong cài đặt trình duyệt.');
    }
    if (!await isSupported()) {
      throw StateError('Trình duyệt này không hỗ trợ Web Push.');
    }
    await _registerToken();
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_enabledPreference, true);
  }

  Future<void> _registerToken() async {
    final token = await FirebaseMessaging.instance.getToken(vapidKey: vapidKey);
    if (token == null || token.isEmpty) {
      throw StateError('Không lấy được mã nhận thông báo từ trình duyệt.');
    }
    await _request({'action': 'subscribe', 'token': token});
    _token = token;
  }

  Future<void> disable() async {
    if (!kIsWeb) return;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_enabledPreference, false);
    final token = _token;
    try {
      if (token != null) {
        await _request({'action': 'unsubscribe', 'token': token});
      }
    } finally {
      // Invalidating the browser token also stops delivery if the server is down.
      try {
        await FirebaseMessaging.instance.deleteToken();
      } finally {
        _token = null;
      }
    }
  }

  Future<void> disableOnSignOut() async {
    try {
      await disable();
    } catch (error) {
      debugPrint('Could not unsubscribe Web Push before sign-out: $error');
    }
  }

  Future<void> sendTest() async {
    final token = _token;
    if (token == null) throw StateError('Hãy bật Web Push trước.');
    await _request({'action': 'test', 'token': token});
  }

  /// Called after a bulk reset; one push replaces a message per deleted document.
  Future<void> notifyDataReset(Map<String, int> counts) async {
    if (counts.values.every((count) => count == 0)) return;
    await _request({'action': 'data-reset', 'counts': counts});
  }

  Future<void> _request(Map<String, Object> body) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw StateError('Cần đăng nhập để dùng Web Push.');
    final idToken = await user.getIdToken();
    final response = await http
        .post(
          Uri.parse(endpoint),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $idToken',
          },
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 12));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError(
        'Máy chủ Web Push chưa sẵn sàng (${response.statusCode}).',
      );
    }
  }
}
