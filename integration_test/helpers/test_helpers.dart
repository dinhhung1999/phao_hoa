import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phao_hoa/main.dart' as app;

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// Shared Helpers for Integration Tests
///
/// ⚠️ Cấu hình tài khoản test:
///   Email: test@example.com
///   Password: 123456
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// Tài khoản test - thay đổi nếu cần
const kTestEmail = 'test@example.com';
const kTestPassword = '123456';

/// Khởi chạy app và đợi load xong
Future<void> launchApp(WidgetTester tester) async {
  app.main();
  await tester.pumpAndSettle(const Duration(seconds: 3));
}

/// Đăng nhập bằng tài khoản test
Future<void> login(WidgetTester tester) async {
  // Tìm fields
  final emailField = find.byType(TextFormField).first;
  final passwordField = find.byType(TextFormField).last;

  // Nhập credentials
  await tester.enterText(emailField, kTestEmail);
  await tester.enterText(passwordField, kTestPassword);

  // Tap đăng nhập
  await tester.tap(find.widgetWithText(ElevatedButton, 'Đăng nhập'));
  await tester.pumpAndSettle(const Duration(seconds: 5));
}

/// Chuyển sang tab theo tên
Future<void> navigateToTab(WidgetTester tester, String tabName) async {
  await tester.tap(find.text(tabName));
  await tester.pumpAndSettle(const Duration(seconds: 2));
}

/// Cuộn xuống tìm widget
Future<void> scrollUntilVisible(
  WidgetTester tester,
  Finder finder, {
  Finder? scrollable,
  double delta = 300,
}) async {
  final scrollableFinder = scrollable ?? find.byType(Scrollable).first;
  await tester.scrollUntilVisible(finder, delta,
      scrollable: scrollableFinder);
  await tester.pumpAndSettle();
}

/// Đợi thêm thời gian cho network requests
Future<void> waitForNetwork(WidgetTester tester,
    {int seconds = 2}) async {
  await tester.pumpAndSettle(Duration(seconds: seconds));
}

/// Tap nút back / quay lại
Future<void> goBack(WidgetTester tester) async {
  final backButton = find.byType(BackButton);
  if (backButton.evaluate().isNotEmpty) {
    await tester.tap(backButton);
  } else {
    // Fallback: icon back
    await tester.tap(find.byIcon(Icons.arrow_back));
  }
  await tester.pumpAndSettle();
}
