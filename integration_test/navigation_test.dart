import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/test_helpers.dart';

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// Integration Test: Điều hướng (Navigation)
///
/// Chạy: flutter test integration_test/navigation_test.dart
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('E2E: Điều hướng', () {
    testWidgets('TC08 - Bottom nav hiển thị đầy đủ 3 tab', (tester) async {
      await launchApp(tester);
      await login(tester);

      expect(find.byType(BottomNavigationBar), findsOneWidget);

      // 3 tabs
      expect(find.text('Tồn kho'), findsOneWidget);
      expect(find.text('Danh mục'), findsOneWidget);
      expect(find.text('Nhật ký'), findsOneWidget);

      // Icons
      expect(find.byIcon(Icons.dashboard_outlined), findsOneWidget);
      expect(find.byIcon(Icons.category_outlined), findsOneWidget);
    });

    testWidgets('TC09 - Default tab là Nhật ký', (tester) async {
      await launchApp(tester);
      await login(tester);

      // Nhật ký là default → report icon visible
      expect(find.byIcon(Icons.assessment_outlined), findsOneWidget);
    });

    testWidgets('TC10 - Chuyển sang tab Tồn kho', (tester) async {
      await launchApp(tester);
      await login(tester);

      await navigateToTab(tester, 'Tồn kho');

      // Statistics icon hiển thị trên tab Tồn kho
      expect(find.byIcon(Icons.bar_chart_outlined), findsOneWidget);

      // Report icon ẩn (chỉ có trên tab Nhật ký)
      expect(find.byIcon(Icons.assessment_outlined), findsNothing);
    });

    testWidgets('TC11 - Chuyển sang tab Danh mục → sub-tabs', (tester) async {
      await launchApp(tester);
      await login(tester);

      await navigateToTab(tester, 'Danh mục');

      // Sub-tabs hiển thị
      expect(find.text('Sản phẩm'), findsOneWidget);
      expect(find.text('Khách hàng'), findsOneWidget);
    });

    testWidgets('TC12 - Chuyển giữa sub-tabs Sản phẩm ↔ Khách hàng',
        (tester) async {
      await launchApp(tester);
      await login(tester);

      await navigateToTab(tester, 'Danh mục');

      // Tap "Khách hàng" sub-tab
      await tester.tap(find.text('Khách hàng'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // FAB hiển thị (trang khách hàng)
      expect(find.byType(FloatingActionButton), findsOneWidget);

      // Quay lại "Sản phẩm" sub-tab
      await tester.tap(find.text('Sản phẩm'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // FAB vẫn hiển thị (trang sản phẩm)
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('TC13 - Mở trang Cài đặt', (tester) async {
      await launchApp(tester);
      await login(tester);

      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Cài đặt'), findsWidgets);
    });

    testWidgets('TC14 - Quay lại từ trang Cài đặt', (tester) async {
      await launchApp(tester);
      await login(tester);

      // Mở cài đặt
      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Quay lại
      await goBack(tester);

      // Bottom nav hiển thị lại
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });
  });
}
