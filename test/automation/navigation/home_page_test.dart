import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:phao_hoa/domain/entities/app_user.dart';
import 'package:phao_hoa/domain/entities/warehouse_stock.dart';
import 'package:phao_hoa/presentation/auth/auth_bloc.dart';
import 'package:phao_hoa/presentation/dashboard/dashboard_bloc.dart';
import 'package:phao_hoa/presentation/dashboard/dashboard_page.dart';
import 'package:phao_hoa/presentation/journal/transaction_bloc.dart';
import 'package:phao_hoa/presentation/customer/customer_bloc.dart';
import 'package:phao_hoa/presentation/category/category_bloc.dart';
import 'package:phao_hoa/presentation/checklist/checklist_bloc.dart';
import 'package:phao_hoa/presentation/home_page.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}
class MockDashboardBloc extends MockBloc<DashboardEvent, DashboardState>
    implements DashboardBloc {}
class MockTransactionBloc extends MockBloc<TransactionEvent, TransactionState>
    implements TransactionBloc {}
class MockCustomerBloc extends MockBloc<CustomerEvent, CustomerState>
    implements CustomerBloc {}
class MockCategoryBloc extends MockBloc<CategoryEvent, CategoryState>
    implements CategoryBloc {}
class MockChecklistBloc extends MockBloc<ChecklistEvent, ChecklistState>
    implements ChecklistBloc {}


void main() {
  late MockAuthBloc mockAuthBloc;
  late MockDashboardBloc mockDashboardBloc;
  late MockTransactionBloc mockTransactionBloc;
  late MockCustomerBloc mockCustomerBloc;
  late MockCategoryBloc mockCategoryBloc;
  late MockChecklistBloc mockChecklistBloc;

  const tUser = AppUser(uid: 'u1', email: 'test@example.com', displayName: 'Test');

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
    mockAuthBloc = MockAuthBloc();
    mockDashboardBloc = MockDashboardBloc();
    mockTransactionBloc = MockTransactionBloc();
    mockCustomerBloc = MockCustomerBloc();
    mockCategoryBloc = MockCategoryBloc();
    mockChecklistBloc = MockChecklistBloc();
  });

  Widget buildApp() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: mockAuthBloc),
        BlocProvider<DashboardBloc>.value(value: mockDashboardBloc),
        BlocProvider<TransactionBloc>.value(value: mockTransactionBloc),
        BlocProvider<CustomerBloc>.value(value: mockCustomerBloc),
        BlocProvider<CategoryBloc>.value(value: mockCategoryBloc),
        BlocProvider<ChecklistBloc>.value(value: mockChecklistBloc),
      ],
      child: const MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('vi', 'VN')],
        locale: Locale('vi', 'VN'),
        home: HomePage(),
      ),
    );
  }

  group('HomePage - Navigation Flow', () {
    testWidgets('should show login page when unauthenticated', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthState.unauthenticated());

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // Should show login page
      expect(find.text('Quản lý Kho Pháo Hoa'), findsOneWidget);
      expect(find.byType(TextFormField), findsWidgets); // login fields
    });

    testWidgets('should show loading screen on initial state', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthState.initial());

      await tester.pumpWidget(buildApp());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show main app with bottom nav when authenticated',
        (tester) async {
      when(() => mockAuthBloc.state)
          .thenReturn(const AuthState.authenticated(tUser));
      when(() => mockDashboardBloc.state)
          .thenReturn(const DashboardState.initial());
      when(() => mockTransactionBloc.state)
          .thenReturn(const TransactionState.initial());
      when(() => mockCustomerBloc.state)
          .thenReturn(const CustomerState.initial());
      when(() => mockCategoryBloc.state)
          .thenReturn(const CategoryState.initial());
      when(() => mockChecklistBloc.state)
          .thenReturn(const ChecklistState.initial());

      await tester.pumpWidget(buildApp());
      await tester.pump();

      // Should show bottom navigation bar
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Tồn kho'), findsOneWidget);
      expect(find.text('Danh mục'), findsOneWidget);
      expect(find.text('Nhật ký'), findsOneWidget);
    });

    testWidgets('should navigate between tabs', (tester) async {
      when(() => mockAuthBloc.state)
          .thenReturn(const AuthState.authenticated(tUser));
      when(() => mockDashboardBloc.state)
          .thenReturn(DashboardState.loaded(stocks: tStocks, totalValue: 15000000));
      when(() => mockTransactionBloc.state)
          .thenReturn(const TransactionState.initial());
      when(() => mockCustomerBloc.state)
          .thenReturn(const CustomerState.initial());
      when(() => mockCategoryBloc.state)
          .thenReturn(const CategoryState.initial());
      when(() => mockChecklistBloc.state)
          .thenReturn(const ChecklistState.initial());

      await tester.pumpWidget(buildApp());
      await tester.pump();

      // Default tab is Journal (index 2)
      // Tap on Dashboard (Tồn kho) tab
      await tester.tap(find.text('Tồn kho'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Dashboard should refresh
      verify(() => mockDashboardBloc.add(const DashboardEvent.refreshDashboard()))
          .called(1);

      // Tap on Catalog (Danh mục) tab
      await tester.tap(find.text('Danh mục'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Should show catalog tabs
      expect(find.text('Sản phẩm'), findsOneWidget);
      expect(find.text('Khách hàng'), findsOneWidget);
    });

    testWidgets('should show settings icon in app bar', (tester) async {
      when(() => mockAuthBloc.state)
          .thenReturn(const AuthState.authenticated(tUser));
      when(() => mockDashboardBloc.state)
          .thenReturn(const DashboardState.initial());
      when(() => mockTransactionBloc.state)
          .thenReturn(const TransactionState.initial());
      when(() => mockCustomerBloc.state)
          .thenReturn(const CustomerState.initial());
      when(() => mockCategoryBloc.state)
          .thenReturn(const CategoryState.initial());
      when(() => mockChecklistBloc.state)
          .thenReturn(const ChecklistState.initial());

      await tester.pumpWidget(buildApp());
      await tester.pump();

      // Settings button should be in app bar
      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    });

    testWidgets('should show report icon on Journal tab', (tester) async {
      when(() => mockAuthBloc.state)
          .thenReturn(const AuthState.authenticated(tUser));
      when(() => mockDashboardBloc.state)
          .thenReturn(const DashboardState.initial());
      when(() => mockTransactionBloc.state)
          .thenReturn(const TransactionState.initial());
      when(() => mockCustomerBloc.state)
          .thenReturn(const CustomerState.initial());
      when(() => mockCategoryBloc.state)
          .thenReturn(const CategoryState.initial());
      when(() => mockChecklistBloc.state)
          .thenReturn(const ChecklistState.initial());

      await tester.pumpWidget(buildApp());
      await tester.pump();

      // Journal is default tab → report icon visible
      expect(find.byIcon(Icons.assessment_outlined), findsOneWidget);
    });
  });
}
