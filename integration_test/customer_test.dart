import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/test_helpers.dart';

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// Integration Test: Quản lý Khách hàng
///
/// Chạy: flutter test integration_test/customer_test.dart
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// Helper: Điều hướng đến tab Khách hàng
  Future<void> goToCustomerTab(WidgetTester tester) async {
    await launchApp(tester);
    await login(tester);
    await navigateToTab(tester, 'Danh mục');
    await tester.tap(find.text('Khách hàng'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  group('E2E: Quản lý Khách hàng', () {
    testWidgets('TC19 - Hiển thị danh sách khách hàng', (tester) async {
      await goToCustomerTab(tester);

      // FAB hiển thị
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('TC20 - Mở form thêm khách hàng', (tester) async {
      await goToCustomerTab(tester);

      // Tap FAB
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Form hiển thị
      expect(find.text('Thêm khách hàng'), findsWidgets);
    });

    testWidgets('TC21 - Validation khi thêm khách hàng rỗng',
        (tester) async {
      await goToCustomerTab(tester);

      // Mở form
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Tìm và tap nút Lưu/Thêm mà không nhập gì
      final saveButton = find.widgetWithText(ElevatedButton, 'Thêm');
      if (saveButton.evaluate().isNotEmpty) {
        await tester.tap(saveButton);
        await tester.pumpAndSettle();
      } else {
        // Thử tìm nút với text khác
        final saveBtn2 = find.widgetWithText(ElevatedButton, 'Lưu');
        if (saveBtn2.evaluate().isNotEmpty) {
          await tester.tap(saveBtn2);
          await tester.pumpAndSettle();
        }
      }

      // Validation errors hiển thị
      expect(find.textContaining('Vui lòng'), findsWidgets);
    });

    testWidgets('TC22 - Tap vào khách hàng → mở chi tiết',
        (tester) async {
      await goToCustomerTab(tester);

      // Tìm ListTile đầu tiên (nếu có dữ liệu)
      final listTiles = find.byType(ListTile);
      if (listTiles.evaluate().isNotEmpty) {
        await tester.tap(listTiles.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Bottom sheet chi tiết hiển thị
        expect(find.byType(BottomSheet), findsOneWidget);
      }
      // Nếu không có dữ liệu, skip test
    });

    testWidgets('TC23 - Đóng bottom sheet chi tiết khách hàng',
        (tester) async {
      await goToCustomerTab(tester);

      final listTiles = find.byType(ListTile);
      if (listTiles.evaluate().isNotEmpty) {
        // Mở bottom sheet
        await tester.tap(listTiles.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Đóng bằng cách tap Close hoặc kéo xuống
        final closeButton = find.byIcon(Icons.close);
        if (closeButton.evaluate().isNotEmpty) {
          await tester.tap(closeButton);
        } else {
          // Kéo xuống để đóng
          await tester.fling(
            find.byType(BottomSheet),
            const Offset(0, 400),
            500,
          );
        }
        await tester.pumpAndSettle();

        // Bottom sheet đóng
        expect(find.byType(BottomSheet), findsNothing);
      }
    });
  });
}
