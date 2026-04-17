import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/test_helpers.dart';

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// Integration Test: Tồn kho & Dashboard
///
/// Chạy: flutter test integration_test/dashboard_test.dart
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('E2E: Dashboard - Tồn kho', () {
    testWidgets('TC15 - Hiển thị danh sách tồn kho', (tester) async {
      await launchApp(tester);
      await login(tester);

      await navigateToTab(tester, 'Tồn kho');

      // Dashboard hiển thị (không trống)
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      // Giá trị tồn kho tổng hiển thị
      expect(find.textContaining('₫'), findsWidgets);
    });

    testWidgets('TC16 - Mở trang Thống kê từ Dashboard', (tester) async {
      await launchApp(tester);
      await login(tester);

      await navigateToTab(tester, 'Tồn kho');

      // Tap icon thống kê
      await tester.tap(find.byIcon(Icons.bar_chart_outlined));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Trang thống kê hiển thị
      expect(find.text('Thống kê'), findsWidgets);
    });

    testWidgets('TC17 - Quay lại từ trang Thống kê', (tester) async {
      await launchApp(tester);
      await login(tester);

      await navigateToTab(tester, 'Tồn kho');

      // Mở thống kê
      await tester.tap(find.byIcon(Icons.bar_chart_outlined));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Quay lại
      await goBack(tester);

      // Dashboard hiển thị
      expect(find.byIcon(Icons.bar_chart_outlined), findsOneWidget);
    });

    testWidgets('TC18 - Pull-to-refresh trên Dashboard', (tester) async {
      await launchApp(tester);
      await login(tester);

      await navigateToTab(tester, 'Tồn kho');

      // Pull to refresh (kéo xuống)
      await tester.fling(
        find.byType(Scrollable).first,
        const Offset(0, 400),
        1000,
      );
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Dashboard vẫn hiển thị
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });
  });
}
