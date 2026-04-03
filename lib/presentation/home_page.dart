import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth/auth_bloc.dart';
import 'auth/login_page.dart';
import 'dashboard/dashboard_bloc.dart';
import 'dashboard/dashboard_page.dart';
import 'catalog/catalog_page.dart';
import 'journal/journal_page.dart';
import 'journal/daily_report_page.dart';
import 'journal/transaction_bloc.dart';
import 'dashboard/statistics_page.dart';
import 'settings/settings_page.dart';

/// Root page that handles auth gate and bottom navigation
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 2; // Default to Journal (most used)

  final _pages = const [
    DashboardPage(),
    CatalogPage(),
    JournalPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        return authState.map(
          initial: (_) {
            context
                .read<AuthBloc>()
                .add(const AuthEvent.checkAuthStatus());
            return const Scaffold(
              body: Center(child: CircularProgressIndicator.adaptive()),
            );
          },
          loading: (_) => const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          ),
          authenticated: (_) => Scaffold(
            appBar: AppBar(
              title: const Text('Quản lý Kho Pháo Hoa'),
              actions: [
                // Show statistics button on Dashboard tab
                if (_currentIndex == 0)
                  IconButton(
                    icon: const Icon(Icons.bar_chart_outlined),
                    tooltip: 'Thống kê',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<TransactionBloc>(),
                            child: const StatisticsPage(),
                          ),
                        ),
                      );
                    },
                  ),
                // Show report button only on Journal tab
                if (_currentIndex == 2)
                  IconButton(
                    icon: const Icon(Icons.assessment_outlined),
                    tooltip: 'Báo cáo hàng ngày',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<TransactionBloc>(),
                            child: const DailyReportPage(),
                          ),
                        ),
                      );
                    },
                  ),
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  tooltip: 'Cài đặt',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const SettingsPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              behavior: HitTestBehavior.translucent,
              child: IndexedStack(index: _currentIndex, children: _pages),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() => _currentIndex = index);
                // Auto-refresh dashboard when switching to inventory tab
                if (index == 0) {
                  context
                      .read<DashboardBloc>()
                      .add(const DashboardEvent.refreshDashboard());
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard_outlined),
                  activeIcon: Icon(Icons.dashboard),
                  label: 'Tồn kho',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.category_outlined),
                  activeIcon: Icon(Icons.category),
                  label: 'Danh mục',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu_book_outlined),
                  activeIcon: Icon(Icons.menu_book),
                  label: 'Nhật ký',
                ),
              ],
            ),
          ),
          unauthenticated: (_) => const LoginPage(),
          error: (_) => const LoginPage(),
        );
      },
    );
  }
}
