import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth/auth_bloc.dart';
import 'auth/login_page.dart';
import 'dashboard/dashboard_page.dart';
import 'catalog/catalog_page.dart';
import 'journal/journal_page.dart';
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
            body: IndexedStack(index: _currentIndex, children: _pages),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
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
