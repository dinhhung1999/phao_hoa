import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/test_helpers.dart';

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// Integration Test: Đăng nhập (Authentication)
///
/// Chạy: flutter test integration_test/auth_test.dart
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('E2E: Đăng nhập', () {
    testWidgets('TC01 - Hiển thị form đăng nhập khi chưa login',
        (tester) async {
      await launchApp(tester);

      // Kiểm tra hiển thị
      expect(find.text('Quản lý Kho Pháo Hoa'), findsOneWidget);
      expect(find.text('Đăng nhập'), findsWidgets);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      expect(find.byIcon(Icons.celebration_rounded), findsOneWidget);
    });

    testWidgets('TC02 - Hiển thị lỗi validation khi submit rỗng',
        (tester) async {
      await launchApp(tester);

      // Tap nút đăng nhập mà không nhập gì
      await tester.tap(find.widgetWithText(ElevatedButton, 'Đăng nhập'));
      await tester.pumpAndSettle();

      // Hiển thị validation errors
      expect(find.text('Vui lòng nhập email'), findsOneWidget);
      expect(find.text('Vui lòng nhập mật khẩu'), findsOneWidget);
    });

    testWidgets('TC03 - Hiển thị lỗi khi nhập email không hợp lệ',
        (tester) async {
      await launchApp(tester);

      await tester.enterText(find.byType(TextFormField).first, 'not-an-email');
      await tester.enterText(find.byType(TextFormField).last, '123456');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Đăng nhập'));
      await tester.pumpAndSettle();

      expect(find.text('Email không hợp lệ'), findsOneWidget);
    });

    testWidgets('TC04 - Hiển thị lỗi khi mật khẩu quá ngắn',
        (tester) async {
      await launchApp(tester);

      await tester.enterText(
          find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, '123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Đăng nhập'));
      await tester.pumpAndSettle();

      expect(find.text('Mật khẩu phải có ít nhất 6 ký tự'), findsOneWidget);
    });

    testWidgets('TC05 - Toggle ẩn/hiện mật khẩu', (tester) async {
      await launchApp(tester);

      // Nhập mật khẩu
      await tester.enterText(find.byType(TextFormField).last, 'mypassword');

      // Ban đầu: icon visibility_off (đang ẩn)
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      // Tap toggle → hiện mật khẩu
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.visibility), findsOneWidget);

      // Tap toggle lần nữa → ẩn lại
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('TC06 - Hiển thị lỗi khi đăng nhập sai credentials',
        (tester) async {
      await launchApp(tester);

      await tester.enterText(
          find.byType(TextFormField).first, 'wrong@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'wrongpassword');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Đăng nhập'));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Hiện SnackBar thông báo lỗi
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('TC07 - Đăng nhập thành công → vào trang chính',
        (tester) async {
      await launchApp(tester);
      await login(tester);

      // Verify trang chính hiển thị
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Tồn kho'), findsOneWidget);
      expect(find.text('Danh mục'), findsOneWidget);
      expect(find.text('Nhật ký'), findsOneWidget);
      expect(find.text('Quản lý Kho Pháo Hoa'), findsOneWidget);
    });
  });
}
