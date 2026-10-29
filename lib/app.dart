import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'injection_container.dart';
import 'presentation/auth/auth_bloc.dart';
import 'presentation/dashboard/dashboard_bloc.dart';
import 'presentation/category/category_bloc.dart';
import 'presentation/journal/transaction_bloc.dart';
import 'presentation/customer/customer_bloc.dart';
import 'presentation/checklist/checklist_bloc.dart';
import 'presentation/formula/formula_bloc.dart';
import 'presentation/home_page.dart';
import 'core/services/notification_service.dart';
import 'core/services/web_push_service.dart';
import 'presentation/auth/login_page.dart';
import 'presentation/auth/access_gate.dart';
import 'presentation/staff/staff_page.dart';
import 'presentation/dashboard/statistics_page.dart';
import 'presentation/journal/daily_report_page.dart';
import 'presentation/settings/settings_page.dart';
import 'presentation/warehouse/warehouse_bloc.dart';
import 'presentation/warehouse/warehouse_list_page.dart';

class PhaoHoaApp extends StatelessWidget {
  const PhaoHoaApp({super.key});

  static final GoRouter _router = GoRouter(
    initialLocation: '/journal',
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Không tìm thấy trang')),
      body: Center(
        child: FilledButton.icon(
          onPressed: () => context.go('/journal'),
          icon: const Icon(Icons.home_outlined),
          label: const Text('Về trang chính'),
        ),
      ),
    ),
    routes: [
      GoRoute(path: '/', redirect: (_, __) => '/journal'),
      GoRoute(
        path: '/inventory',
        pageBuilder: (context, state) =>
            _routePage(state, const HomePage(initialIndex: 0)),
      ),
      GoRoute(path: '/catalog', redirect: (_, __) => '/catalog/products'),
      GoRoute(
        path: '/catalog/products',
        pageBuilder: (context, state) => _routePage(
          state,
          const HomePage(initialIndex: 1, initialCatalogTab: 0),
        ),
      ),
      GoRoute(
        path: '/catalog/customers',
        pageBuilder: (context, state) => _routePage(
          state,
          const HomePage(initialIndex: 1, initialCatalogTab: 1),
        ),
      ),
      GoRoute(
        path: '/catalog/formulas',
        pageBuilder: (context, state) => _routePage(
          state,
          const HomePage(initialIndex: 1, initialCatalogTab: 2),
        ),
      ),
      GoRoute(
        path: '/journal',
        pageBuilder: (context, state) =>
            _routePage(state, const HomePage(initialIndex: 2)),
      ),
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) =>
            _routePage(state, const _AuthenticatedRoute(child: SettingsPage())),
      ),
      GoRoute(
        path: '/staff',
        pageBuilder: (context, state) => _routePage(
          state,
          const _AuthenticatedRoute(
            child: AccessGate(ownerOnly: true, child: StaffPage()),
          ),
        ),
      ),
      GoRoute(
        path: '/statistics',
        pageBuilder: (context, state) => _routePage(
          state,
          _AuthenticatedRoute(
            child: BlocProvider.value(
              value: context.read<TransactionBloc>(),
              child: const StatisticsPage(),
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/daily-report',
        pageBuilder: (context, state) => _routePage(
          state,
          _AuthenticatedRoute(
            child: BlocProvider.value(
              value: context.read<TransactionBloc>(),
              child: const DailyReportPage(),
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/warehouses',
        pageBuilder: (context, state) => _routePage(
          state,
          _AuthenticatedRoute(
            child: BlocProvider(
              create: (_) => sl<WarehouseBloc>(),
              child: const WarehouseListPage(),
            ),
          ),
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()),
        BlocProvider(create: (_) => sl<DashboardBloc>()),
        BlocProvider(create: (_) => sl<CategoryBloc>()),
        BlocProvider(create: (_) => sl<TransactionBloc>()),
        BlocProvider(create: (_) => sl<CustomerBloc>()),
        BlocProvider(create: (_) => sl<ChecklistBloc>()),
        BlocProvider(create: (_) => sl<FormulaBloc>()),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          state.mapOrNull(
            authenticated: (_) {
              WebPushService().listenInForeground(onOpen: _router.go);
            },
          );
        },
        child: MaterialApp.router(
          routerConfig: _router,
          title: 'Quản lý Kho Pháo Hoa',
          scaffoldMessengerKey: notificationMessengerKey,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('vi', 'VN'), Locale('en', 'US')],
          locale: const Locale('vi', 'VN'),
        ),
      ),
    );
  }
}

Page<void> _routePage(GoRouterState state, Widget child) {
  final name = state.name ?? state.path;
  final arguments = <String, String>{
    ...state.pathParameters,
    ...state.uri.queryParameters,
  };
  final key = state.pageKey;
  final restorationId = key.value;

  if (kIsWeb) {
    return NoTransitionPage<void>(
      key: key,
      name: name,
      arguments: arguments,
      restorationId: restorationId,
      child: _NotificationPermissionGate(child: child),
    );
  }

  return MaterialPage<void>(
    key: key,
    name: name,
    arguments: arguments,
    restorationId: restorationId,
    child: _NotificationPermissionGate(child: child),
  );
}

class _NotificationPermissionGate extends StatelessWidget {
  final Widget child;

  const _NotificationPermissionGate({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.mapOrNull(
          authenticated: (_) =>
              unawaited(WebPushService().requestPermissionIfNeeded(context)),
        );
      },
      child: child,
    );
  }
}

class _AuthenticatedRoute extends StatelessWidget {
  final Widget child;

  const _AuthenticatedRoute({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) => authState.map(
        initial: (_) {
          context.read<AuthBloc>().add(const AuthEvent.checkAuthStatus());
          return const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          );
        },
        loading: (_) => const Scaffold(
          body: Center(child: CircularProgressIndicator.adaptive()),
        ),
        authenticated: (_) => AccessGate(child: child),
        unauthenticated: (_) => const LoginPage(),
        error: (_) => const LoginPage(),
      ),
    );
  }
}
