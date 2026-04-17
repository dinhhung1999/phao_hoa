import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:phao_hoa/domain/entities/warehouse_stock.dart';
import 'package:phao_hoa/presentation/dashboard/dashboard_bloc.dart';
import 'package:phao_hoa/presentation/dashboard/dashboard_page.dart';

class MockDashboardBloc extends MockBloc<DashboardEvent, DashboardState>
    implements DashboardBloc {}


Widget buildTestApp({
  required Widget child,
  required DashboardBloc dashboardBloc,
}) {
  return MaterialApp(
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('vi', 'VN')],
    locale: const Locale('vi', 'VN'),
    home: BlocProvider<DashboardBloc>.value(
      value: dashboardBloc,
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  late MockDashboardBloc mockBloc;

  final tStocks = [
    const WarehouseStock(
      productId: 'p1',
      productName: 'Pháo hoa ABC',
      totalQuantity: 100,
      stockByLocation: {'kho_1': 60, 'kho_2': 40},
    ),
    const WarehouseStock(
      productId: 'p2',
      productName: 'Pháo hoa XYZ',
      totalQuantity: 50,
      stockByLocation: {'kho_1': 50},
    ),
  ];

  setUp(() {
    mockBloc = MockDashboardBloc();
  });

  group('DashboardPage - UI Flow', () {
    testWidgets('should show loading indicator when loading', (tester) async {
      when(() => mockBloc.state).thenReturn(const DashboardState.loading());

      await tester.pumpWidget(buildTestApp(
        child: const DashboardPage(),
        dashboardBloc: mockBloc,
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display stock items when loaded', (tester) async {
      when(() => mockBloc.state).thenReturn(
        DashboardState.loaded(stocks: tStocks, totalValue: 15000000),
      );

      await tester.pumpWidget(buildTestApp(
        child: const DashboardPage(),
        dashboardBloc: mockBloc,
      ));
      await tester.pumpAndSettle();

      // Product names should appear
      expect(find.text('Pháo hoa ABC'), findsOneWidget);
      expect(find.text('Pháo hoa XYZ'), findsOneWidget);
    });

    testWidgets('should show error message when error', (tester) async {
      when(() => mockBloc.state)
          .thenReturn(const DashboardState.error('Lỗi tải dữ liệu'));

      await tester.pumpWidget(buildTestApp(
        child: const DashboardPage(),
        dashboardBloc: mockBloc,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Lỗi tải dữ liệu'), findsOneWidget);
    });

    testWidgets('should dispatch loadDashboard on init', (tester) async {
      when(() => mockBloc.state).thenReturn(const DashboardState.initial());

      await tester.pumpWidget(buildTestApp(
        child: const DashboardPage(),
        dashboardBloc: mockBloc,
      ));

      verify(() => mockBloc.add(const DashboardEvent.loadDashboard())).called(1);
    });
  });
}
