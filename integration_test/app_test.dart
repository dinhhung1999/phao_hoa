import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'test_app.dart' as app;

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// Integration Test: Full E2E trên thiết bị thật
///
/// ⚠️ YÊU CẦU:
///   - Kết nối thiết bị hoặc chạy emulator
///   - Kết nối internet (Firebase)
///   - Tài khoản test: test@example.com / 123456
///
/// Chạy:
///   flutter test integration_test/app_test.dart -d DEVICE_ID
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// Tài khoản test
const kTestEmail = 'test@example.com';
const kTestPassword = '123456';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('E2E: Full App Flow', () {
    testWidgets('Luồng đầy đủ: Login → Navigation → Features', (tester) async {
      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━
      // KHỞI CHẠY APP
      // ━━━━━━━━━━━━━━━━━━━━━━━━━━━
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // ─────────────────────────────────────
      // TC01: Hiển thị form đăng nhập
      // ─────────────────────────────────────
      debugPrint('▶ TC01: Hiển thị form đăng nhập');
      expect(find.text('Quản lý Kho Pháo Hoa'), findsOneWidget);
      expect(find.text('Đăng nhập'), findsWidgets);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      debugPrint('  ✓ TC01 PASSED');

      // ─────────────────────────────────────
      // TC02: Validation khi submit rỗng
      // ─────────────────────────────────────
      debugPrint('▶ TC02: Validation khi submit rỗng');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Đăng nhập'));
      await tester.pumpAndSettle();
      expect(find.text('Vui lòng nhập email'), findsOneWidget);
      expect(find.text('Vui lòng nhập mật khẩu'), findsOneWidget);
      debugPrint('  ✓ TC02 PASSED');

      // ─────────────────────────────────────
      // TC03: Validation email không hợp lệ
      // ─────────────────────────────────────
      debugPrint('▶ TC03: Validation email không hợp lệ');
      await tester.enterText(find.byType(TextFormField).first, 'not-an-email');
      await tester.enterText(find.byType(TextFormField).last, '123456');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Đăng nhập'));
      await tester.pumpAndSettle();
      expect(find.text('Email không hợp lệ'), findsOneWidget);
      debugPrint('  ✓ TC03 PASSED');

      // ─────────────────────────────────────
      // TC04: Validation mật khẩu ngắn
      // ─────────────────────────────────────
      debugPrint('▶ TC04: Validation mật khẩu ngắn');
      // Clear & re-enter
      await tester.enterText(
          find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, '123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Đăng nhập'));
      await tester.pumpAndSettle();
      expect(find.text('Mật khẩu phải có ít nhất 6 ký tự'), findsOneWidget);
      debugPrint('  ✓ TC04 PASSED');

      // ─────────────────────────────────────
      // TC05: Toggle ẩn/hiện mật khẩu
      // ─────────────────────────────────────
      debugPrint('▶ TC05: Toggle ẩn/hiện mật khẩu');
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      // Toggle back
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      debugPrint('  ✓ TC05 PASSED');

      // ─────────────────────────────────────
      // TC06: Đăng nhập thành công
      // ─────────────────────────────────────
      debugPrint('▶ TC06: Đăng nhập thành công');
      await tester.enterText(find.byType(TextFormField).first, kTestEmail);
      await tester.enterText(find.byType(TextFormField).last, kTestPassword);
      await tester.tap(find.widgetWithText(ElevatedButton, 'Đăng nhập'));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify trang chính
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Tồn kho'), findsOneWidget);
      expect(find.text('Danh mục'), findsOneWidget);
      expect(find.text('Nhật ký'), findsOneWidget);
      debugPrint('  ✓ TC06 PASSED');

      // ─────────────────────────────────────
      // TC07: Default tab là Nhật ký
      // ─────────────────────────────────────
      debugPrint('▶ TC07: Default tab là Nhật ký');
      expect(find.byIcon(Icons.assessment_outlined), findsOneWidget);
      debugPrint('  ✓ TC07 PASSED');

      // ─────────────────────────────────────
      // TC08: Chuyển sang tab Tồn kho
      // ─────────────────────────────────────
      debugPrint('▶ TC08: Chuyển sang tab Tồn kho');
      await tester.tap(find.text('Tồn kho'));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.byIcon(Icons.bar_chart_outlined), findsOneWidget);
      expect(find.byIcon(Icons.assessment_outlined), findsNothing);
      debugPrint('  ✓ TC08 PASSED');

      // ─────────────────────────────────────
      // TC09: Mở trang Thống kê
      // ─────────────────────────────────────
      debugPrint('▶ TC09: Mở trang Thống kê');
      await tester.tap(find.byIcon(Icons.bar_chart_outlined));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.text('Thống kê'), findsWidgets);
      debugPrint('  ✓ TC09 PASSED');

      // Quay lại
      final backButton = find.byType(BackButton);
      if (backButton.evaluate().isNotEmpty) {
        await tester.tap(backButton.first);
      } else {
        await tester.tap(find.byIcon(Icons.arrow_back).first);
      }
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // ─────────────────────────────────────
      // TC10: Chuyển sang tab Danh mục
      // ─────────────────────────────────────
      debugPrint('▶ TC10: Chuyển sang tab Danh mục');
      await tester.tap(find.text('Danh mục'));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.text('Sản phẩm'), findsOneWidget);
      expect(find.text('Khách hàng'), findsOneWidget);
      debugPrint('  ✓ TC10 PASSED');

      // ─────────────────────────────────────
      // TC11: Sub-tab Khách hàng
      // ─────────────────────────────────────
      debugPrint('▶ TC11: Sub-tab Khách hàng');
      await tester.tap(find.text('Khách hàng'));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.byType(FloatingActionButton), findsOneWidget);
      debugPrint('  ✓ TC11 PASSED');

      // ─────────────────────────────────────
      // TC12: Mở form thêm khách hàng
      // ─────────────────────────────────────
      debugPrint('▶ TC12: Mở form thêm khách hàng');
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.text('Thêm khách hàng'), findsWidgets);
      debugPrint('  ✓ TC12 PASSED');

      // Đóng dialog/bottom sheet
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      // ─────────────────────────────────────
      // TC13: Quay lại sub-tab Sản phẩm
      // ─────────────────────────────────────
      debugPrint('▶ TC13: Quay lại sub-tab Sản phẩm');
      await tester.tap(find.text('Sản phẩm'));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.byType(FloatingActionButton), findsOneWidget);
      debugPrint('  ✓ TC13 PASSED');

      // ─────────────────────────────────────
      // TC14: Chuyển về tab Nhật ký
      // ─────────────────────────────────────
      debugPrint('▶ TC14: Chuyển về tab Nhật ký');
      await tester.tap(find.text('Nhật ký'));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.byIcon(Icons.assessment_outlined), findsOneWidget);
      debugPrint('  ✓ TC14 PASSED');

      // ─────────────────────────────────────
      // TC15: Mở Báo cáo hàng ngày
      // ─────────────────────────────────────
      debugPrint('▶ TC15: Mở Báo cáo hàng ngày');
      await tester.tap(find.byIcon(Icons.assessment_outlined));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.text('Báo cáo hàng ngày'), findsWidgets);
      debugPrint('  ✓ TC15 PASSED');

      // Quay lại
      final backBtn2 = find.byType(BackButton);
      if (backBtn2.evaluate().isNotEmpty) {
        await tester.tap(backBtn2.first);
      } else {
        await tester.tap(find.byIcon(Icons.arrow_back).first);
      }
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // ─────────────────────────────────────
      // TC16: Mở trang Cài đặt
      // ─────────────────────────────────────
      debugPrint('▶ TC16: Mở trang Cài đặt');
      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.text('Cài đặt'), findsWidgets);
      debugPrint('  ✓ TC16 PASSED');

      // ─────────────────────────────────────
      // TC17: Quay lại từ Cài đặt
      // ─────────────────────────────────────
      debugPrint('▶ TC17: Quay lại từ Cài đặt');
      final backBtn3 = find.byType(BackButton);
      if (backBtn3.evaluate().isNotEmpty) {
        await tester.tap(backBtn3.first);
      } else {
        await tester.tap(find.byIcon(Icons.arrow_back).first);
      }
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      debugPrint('  ✓ TC17 PASSED');

      debugPrint('');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('  ✅ ALL 17 TEST CASES PASSED');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    });
  });
}
