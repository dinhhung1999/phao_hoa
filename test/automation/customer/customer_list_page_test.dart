import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:phao_hoa/domain/entities/customer.dart';
import 'package:phao_hoa/presentation/customer/customer_bloc.dart';
import 'package:phao_hoa/presentation/customer/customer_list_page.dart';

class MockCustomerBloc extends MockBloc<CustomerEvent, CustomerState>
    implements CustomerBloc {}


Widget buildTestApp({
  required Widget child,
  required CustomerBloc customerBloc,
}) {
  return MaterialApp(
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('vi', 'VN')],
    locale: const Locale('vi', 'VN'),
    home: BlocProvider<CustomerBloc>.value(
      value: customerBloc,
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  late MockCustomerBloc mockBloc;

  final now = DateTime(2026, 4, 10);
  final tCustomers = [
    Customer(
      id: 'c1',
      name: 'Nguyễn Văn A',
      phone: '0912345678',
      type: 'khach_quen',
      totalDebt: 500000,
      createdAt: now,
      updatedAt: now,
    ),
    Customer(
      id: 'c2',
      name: 'Trần Thị B',
      phone: '0987654321',
      type: 'khach_le',
      totalDebt: 0,
      createdAt: now,
      updatedAt: now,
    ),
  ];

  setUp(() {
    mockBloc = MockCustomerBloc();
  });

  group('CustomerListPage - UI Flow', () {
    testWidgets('should show loading indicator when loading', (tester) async {
      when(() => mockBloc.state).thenReturn(const CustomerState.loading());

      await tester.pumpWidget(buildTestApp(
        child: const CustomerListPage(showAppBar: false),
        customerBloc: mockBloc,
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display customer list when loaded', (tester) async {
      when(() => mockBloc.state).thenReturn(CustomerState.paginatedLoaded(
        customers: tCustomers,
        hasMore: false,
      ));

      await tester.pumpWidget(buildTestApp(
        child: const CustomerListPage(showAppBar: false),
        customerBloc: mockBloc,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Nguyễn Văn A'), findsOneWidget);
      expect(find.text('Trần Thị B'), findsOneWidget);
    });

    testWidgets('should show debt indicator for customers with debt',
        (tester) async {
      when(() => mockBloc.state).thenReturn(CustomerState.paginatedLoaded(
        customers: tCustomers,
        hasMore: false,
      ));

      await tester.pumpWidget(buildTestApp(
        child: const CustomerListPage(showAppBar: false),
        customerBloc: mockBloc,
      ));
      await tester.pumpAndSettle();

      // Customer 1 has debt
      expect(find.textContaining('500.000'), findsWidgets);
    });

    testWidgets('should dispatch loadCustomersPaginated on init',
        (tester) async {
      when(() => mockBloc.state).thenReturn(const CustomerState.initial());

      await tester.pumpWidget(buildTestApp(
        child: const CustomerListPage(showAppBar: false),
        customerBloc: mockBloc,
      ));

      verify(() => mockBloc.add(const CustomerEvent.loadCustomersPaginated()))
          .called(1);
    });

    testWidgets('should show empty state when no customers', (tester) async {
      when(() => mockBloc.state).thenReturn(const CustomerState.paginatedLoaded(
        customers: [],
        hasMore: false,
      ));

      await tester.pumpWidget(buildTestApp(
        child: const CustomerListPage(showAppBar: false),
        customerBloc: mockBloc,
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('Chưa có khách hàng'), findsOneWidget);
    });

    testWidgets('should show FAB to add customer', (tester) async {
      when(() => mockBloc.state).thenReturn(CustomerState.paginatedLoaded(
        customers: tCustomers,
        hasMore: false,
      ));

      await tester.pumpWidget(buildTestApp(
        child: const CustomerListPage(showAppBar: false),
        customerBloc: mockBloc,
      ));
      await tester.pumpAndSettle();

      // FAB should exist
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('should show add customer dialog on FAB tap', (tester) async {
      when(() => mockBloc.state).thenReturn(CustomerState.paginatedLoaded(
        customers: tCustomers,
        hasMore: false,
      ));

      await tester.pumpWidget(buildTestApp(
        child: const CustomerListPage(showAppBar: false),
        customerBloc: mockBloc,
      ));
      await tester.pumpAndSettle();

      // Tap FAB
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Add customer dialog/bottom sheet should appear
      expect(find.text('Thêm khách hàng'), findsWidgets);
    });

    testWidgets('should show success snackbar after adding customer',
        (tester) async {
      when(() => mockBloc.state).thenReturn(const CustomerState.initial());

      whenListen(
        mockBloc,
        Stream.fromIterable([
          const CustomerState.loading(),
          const CustomerState.actionSuccess('Đã thêm khách hàng'),
        ]),
        initialState: const CustomerState.initial(),
      );

      await tester.pumpWidget(buildTestApp(
        child: const CustomerListPage(showAppBar: false),
        customerBloc: mockBloc,
      ));

      // Pump to process the stream events and show snackbar
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Đã thêm khách hàng'), findsOneWidget);
    });

    testWidgets('should open debt bottom sheet on customer tap',
        (tester) async {
      when(() => mockBloc.state).thenReturn(CustomerState.paginatedLoaded(
        customers: tCustomers,
        hasMore: false,
      ));

      await tester.pumpWidget(buildTestApp(
        child: const CustomerListPage(showAppBar: false),
        customerBloc: mockBloc,
      ));
      await tester.pumpAndSettle();

      // Tap on first customer
      await tester.tap(find.text('Nguyễn Văn A'));
      await tester.pumpAndSettle();

      // Debt bottom sheet should open — verify the debt loading was triggered
      verify(() => mockBloc.add(CustomerEvent.loadDebts(
            customerId: 'c1',
            customer: tCustomers[0],
          ))).called(1);
    });
  });
}
