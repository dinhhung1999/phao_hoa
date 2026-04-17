import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/test_helpers.dart';

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// Integration Test: Nhật ký giao dịch & Báo cáo
///
/// Chạy: flutter test integration_test/journal_test.dart
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('E2E: Nhật ký giao dịch', () {
    testWidgets('TC24 - Default ở tab Nhật ký', (tester) async {
      await launchApp(tester);
      await login(tester);

      // Report icon chỉ hiển thị trên tab Nhật ký
      expect(find.byIcon(Icons.assessment_outlined), findsOneWidget);
    });

    testWidgets('TC25 - Mở trang Báo cáo hàng ngày', (tester) async {
      await launchApp(tester);
      await login(tester);

      // Tap icon báo cáo
      await tester.tap(find.byIcon(Icons.assessment_outlined));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Trang báo cáo hiển thị
      expect(find.text('Báo cáo hàng ngày'), findsWidgets);
    });

    testWidgets('TC26 - Quay lại từ Báo cáo hàng ngày', (tester) async {
      await launchApp(tester);
      await login(tester);

      // Mở báo cáo
      await tester.tap(find.byIcon(Icons.assessment_outlined));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Quay lại
      await goBack(tester);

      // Bottom nav hiển thị
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.byIcon(Icons.assessment_outlined), findsOneWidget);
    });

    testWidgets('TC27 - Hiển thị FAB tạo giao dịch', (tester) async {
      await launchApp(tester);
      await login(tester);

      // FAB trên trang nhật ký
      expect(find.byType(FloatingActionButton), findsWidgets);
    });
  });
}
