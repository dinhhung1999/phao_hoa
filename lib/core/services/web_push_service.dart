import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'browser_notifications_stub.dart'
    if (dart.library.html) 'browser_notifications_web.dart'
    as browser;
import 'notification_service.dart';

/// Spark-compatible activity alerts for an authenticated browser session.
///
/// Firestore listeners run in the page, so this does not deliver alerts after
/// the app is closed and does not require Cloud Functions or FCM sending APIs.
class WebPushService {
  WebPushService._();
  static final WebPushService _instance = WebPushService._();
  factory WebPushService() => _instance;

  final List<StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>
  _subscriptions = [];
  final Map<String, bool> _initializedCollections = {};
  final Set<String> _seenChanges = {};
  final List<_Activity> _pendingActivities = [];
  String? _userId;
  void Function(String path)? _openPath;
  Timer? _pendingTimer;

  void listenInForeground({void Function(String path)? onOpen}) {
    if (!kIsWeb) return;
    _openPath = onOpen ?? _openPath;
    _startListeners();
  }

  /// Stop this session's listeners when signing out.
  Future<void> disableOnSignOut() async {
    _stopListeners();
  }

  void _startListeners() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _userId == user.uid && _subscriptions.isNotEmpty) {
      return;
    }
    _stopListeners();
    _userId = user.uid;
    _watch('transactions', '/journal', _transactionMessage);
    _watch(
      'reconciliations',
      '/inventory',
      (_) => const _Activity(
        'Đã kiểm kho',
        'Một lượt kiểm kho vừa được ghi nhận.',
      ),
    );
    _watch(
      'inventory',
      '/inventory',
      (change) => _Activity(
        'Đã xóa tồn kho',
        'Dữ liệu tồn kho của một sản phẩm vừa được xóa.',
      ),
    );
    _watch(
      'daily_checklists',
      '/journal',
      (_) => const _Activity(
        'Checklist thay đổi',
        'Checklist hàng ngày vừa được cập nhật.',
      ),
    );
    _watch(
      'products',
      '/catalog/products',
      (_) => const _Activity(
        'Sản phẩm thay đổi',
        'Danh mục sản phẩm vừa được cập nhật.',
      ),
    );
    _watch(
      'customers',
      '/catalog/customers',
      (_) => const _Activity(
        'Khách hàng thay đổi',
        'Thông tin khách hàng vừa được cập nhật.',
      ),
    );
    _watch(
      'warehouses',
      '/warehouses',
      (_) => const _Activity(
        'Kho hàng thay đổi',
        'Thông tin kho hàng vừa được cập nhật.',
      ),
    );
    _watch(
      'product_formulas',
      '/catalog/formulas',
      (_) => const _Activity(
        'Công thức thay đổi',
        'Một công thức sản phẩm vừa được cập nhật.',
      ),
    );
  }

  void _watch(
    String collection,
    String path,
    _Activity Function(DocumentChange<Map<String, dynamic>>) describe,
  ) {
    final subscription = FirebaseFirestore.instance
        .collection(collection)
        .snapshots()
        .listen(
          (snapshot) {
            if (snapshot.metadata.isFromCache) return;
            if (_initializedCollections[collection] != true) {
              _initializedCollections[collection] = true;
              return; // Ignore the initial snapshot of existing data.
            }
            for (final change in snapshot.docChanges) {
              // Inventory updates caused by normal transactions or stocktaking are
              // already represented by their transaction/reconciliation record.
              if (collection == 'inventory' &&
                  change.type != DocumentChangeType.removed) {
                continue;
              }
              final eventId =
                  '$collection:${change.type}:${change.doc.id}:'
                  '${change.doc.data().hashCode}';
              if (!_seenChanges.add(eventId)) continue;
              if (_seenChanges.length > 500) _seenChanges.clear();
              final activity = describe(change);
              _queue(activity, path);
            }
          },
          onError: (Object error) => debugPrint(
            'Could not watch $collection for browser notifications: $error',
          ),
        );
    _subscriptions.add(subscription);
  }

  void _queue(_Activity activity, String path) {
    _pendingActivities.add(activity);
    _pendingTimer?.cancel();
    _pendingTimer = Timer(const Duration(milliseconds: 500), () {
      final activities = List<_Activity>.of(_pendingActivities);
      _pendingActivities.clear();
      if (activities.isEmpty) return;
      if (activities.length == 1) {
        _show(activities.single.title, activities.single.body, path);
      } else {
        _show(
          'Dữ liệu vừa thay đổi',
          '${activities.length} mục dữ liệu vừa được cập nhật hoặc xóa.',
          path,
        );
      }
    });
  }

  _Activity _transactionMessage(DocumentChange<Map<String, dynamic>> change) {
    final data = change.doc.data();
    final kind = data?['type'] == 'nhap' ? 'nhập kho' : 'xuất kho';
    switch (change.type) {
      case DocumentChangeType.added:
        return _Activity('Có phiếu $kind mới', 'Một phiếu $kind vừa được tạo.');
      case DocumentChangeType.modified:
        return _Activity(
          'Đã chỉnh sửa phiếu $kind',
          'Thông tin phiếu $kind vừa được cập nhật.',
        );
      case DocumentChangeType.removed:
        return _Activity('Đã xóa phiếu', 'Một phiếu giao dịch vừa được xóa.');
    }
  }

  void _show(String title, String body, String path) {
    if (FirebaseAuth.instance.currentUser == null) return;
    if (browser.isPageVisible()) {
      notificationMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('$title\n$body'),
          duration: const Duration(seconds: 8),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Mở',
            onPressed: () => _openPath?.call(path),
          ),
        ),
      );
    } else {
      if (browser.isSupported()) {
        browser.show(title, body, path, _openPath);
      }
    }
  }

  void _stopListeners() {
    for (final subscription in _subscriptions) {
      unawaited(subscription.cancel());
    }
    _subscriptions.clear();
    _initializedCollections.clear();
    _seenChanges.clear();
    _pendingTimer?.cancel();
    _pendingActivities.clear();
    _userId = null;
  }
}

class _Activity {
  final String title;
  final String body;
  const _Activity(this.title, this.body);
}
