import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'auth/auth_bloc.dart';
import 'auth/login_page.dart';
import 'dashboard/dashboard_bloc.dart';
import 'dashboard/dashboard_page.dart';
import 'catalog/catalog_page.dart';
import 'journal/journal_page.dart';

/// Root page that handles auth gate and bottom navigation
class HomePage extends StatefulWidget {
  final int initialIndex;
  final int initialCatalogTab;

  const HomePage({
    super.key,
    this.initialIndex = 2,
    this.initialCatalogTab = 0,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIndex != widget.initialIndex) {
      _currentIndex = widget.initialIndex;
    }
  }

  List<Widget> get _pages => [
    const DashboardPage(),
    CatalogPage(
      key: ValueKey(widget.initialCatalogTab),
      initialTabIndex: widget.initialCatalogTab,
    ),
    const JournalPage(),
  ];

  static const _sectionPaths = ['/inventory', '/catalog/products', '/journal'];

  void _openSection(BuildContext context, int index) {
    if (index == _currentIndex) return;
    if (index == 0) {
      context.read<DashboardBloc>().add(
        const DashboardEvent.refreshDashboard(),
      );
    }
    if (!kIsWeb) {
      setState(() => _currentIndex = index);
      return;
    }
    context.go(_sectionPaths[index]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        return authState.map(
          initial: (_) {
            context.read<AuthBloc>().add(const AuthEvent.checkAuthStatus());
            return const Scaffold(
              body: Center(child: CircularProgressIndicator.adaptive()),
            );
          },
          loading: (_) => const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          ),
          authenticated: (_) => LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 1100;
              final isWide = constraints.maxWidth >= 840;
              final pages = _pages;
              final pageStack = kIsWeb
                  ? pages[_currentIndex]
                  : IndexedStack(index: _currentIndex, children: pages);
              return Scaffold(
                appBar: AppBar(
                  toolbarHeight: isWide ? 76 : null,
                  centerTitle: !isWide,
                  title: isWide
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              const [
                                'Tồn kho',
                                'Danh mục',
                                'Nhật ký giao dịch',
                              ][_currentIndex],
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              const [
                                'Theo dõi số lượng và giá trị hàng hóa',
                                'Quản lý sản phẩm, khách hàng và công thức',
                                'Xem lịch sử và tạo giao dịch mới',
                              ][_currentIndex],
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        )
                      : const Text('Quản lý Kho Pháo Hoa'),
                  actions: [
                    // Show statistics button on Dashboard tab
                    if (_currentIndex == 0)
                      isWide
                          ? TextButton.icon(
                              onPressed: () => context.push('/statistics'),
                              icon: const Icon(Icons.bar_chart_outlined),
                              label: const Text('Thống kê'),
                            )
                          : IconButton(
                              icon: const Icon(Icons.bar_chart_outlined),
                              tooltip: 'Thống kê',
                              onPressed: () => context.push('/statistics'),
                            ),
                    // Show report button only on Journal tab
                    if (_currentIndex == 2)
                      isWide
                          ? TextButton.icon(
                              onPressed: () => context.push('/daily-report'),
                              icon: const Icon(Icons.assessment_outlined),
                              label: const Text('Báo cáo'),
                            )
                          : IconButton(
                              icon: const Icon(Icons.assessment_outlined),
                              tooltip: 'Báo cáo hàng ngày',
                              onPressed: () => context.push('/daily-report'),
                            ),
                    if (!isDesktop)
                      IconButton(
                        icon: const Icon(Icons.settings_outlined),
                        tooltip: 'Cài đặt',
                        onPressed: () => context.push('/settings'),
                      ),
                    if (isWide) const SizedBox(width: 20),
                  ],
                ),
                body: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  behavior: HitTestBehavior.translucent,
                  child: isDesktop
                      ? Row(
                          children: [
                            SizedBox(
                              width: 272,
                              child: _DesktopSidebar(
                                currentIndex: _currentIndex,
                                onDestinationSelected: (index) =>
                                    _openSection(context, index),
                              ),
                            ),
                            const VerticalDivider(width: 1),
                            Expanded(
                              child: Center(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 1440,
                                  ),
                                  child: SizedBox.expand(child: pageStack),
                                ),
                              ),
                            ),
                          ],
                        )
                      : isWide
                      ? Row(
                          children: [
                            NavigationRail(
                              selectedIndex: _currentIndex,
                              labelType: NavigationRailLabelType.all,
                              onDestinationSelected: (index) =>
                                  _openSection(context, index),
                              destinations: const [
                                NavigationRailDestination(
                                  icon: Icon(Icons.dashboard_outlined),
                                  selectedIcon: Icon(Icons.dashboard),
                                  label: Text('Tồn kho'),
                                ),
                                NavigationRailDestination(
                                  icon: Icon(Icons.category_outlined),
                                  selectedIcon: Icon(Icons.category),
                                  label: Text('Danh mục'),
                                ),
                                NavigationRailDestination(
                                  icon: Icon(Icons.menu_book_outlined),
                                  selectedIcon: Icon(Icons.menu_book),
                                  label: Text('Nhật ký'),
                                ),
                              ],
                            ),
                            const VerticalDivider(width: 1),
                            Expanded(
                              child: Center(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 1440,
                                  ),
                                  child: SizedBox.expand(child: pageStack),
                                ),
                              ),
                            ),
                          ],
                        )
                      : pageStack,
                ),
                bottomNavigationBar: isWide
                    ? null
                    : BottomNavigationBar(
                        currentIndex: _currentIndex,
                        onTap: (index) => _openSection(context, index),
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
              );
            },
          ),
          unauthenticated: (_) => const LoginPage(),
          error: (_) => const LoginPage(),
        );
      },
    );
  }
}

class _DesktopSidebar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  const _DesktopSidebar({
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ColoredBox(
      color: scheme.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 20, 28),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.celebration_outlined,
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PHAO HOA',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                        ),
                        Text(
                          'Quản lý kho hàng',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _sectionLabel(context, 'KHÔNG GIAN LÀM VIỆC'),
                  const SizedBox(height: 8),
                  _destination(context, 0, Icons.dashboard_outlined, 'Tồn kho'),
                  _destination(context, 1, Icons.category_outlined, 'Danh mục'),
                  _destination(
                    context,
                    2,
                    Icons.menu_book_outlined,
                    'Nhật ký giao dịch',
                  ),
                  const SizedBox(height: 24),
                  _sectionLabel(context, 'CÔNG CỤ'),
                  const SizedBox(height: 8),
                  _shortcut(
                    context,
                    Icons.bar_chart_outlined,
                    'Thống kê',
                    '/statistics',
                  ),
                  _shortcut(
                    context,
                    Icons.assessment_outlined,
                    'Báo cáo hàng ngày',
                    '/daily-report',
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(12),
              child: _shortcut(
                context,
                Icons.settings_outlined,
                'Cài đặt',
                '/settings',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String label) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Text(
      label,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: 1,
      ),
    ),
  );

  Widget _destination(
    BuildContext context,
    int index,
    IconData icon,
    String label,
  ) {
    final selected = currentIndex == index;
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: selected ? scheme.primaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onDestinationSelected(index),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: selected
                      ? scheme.onPrimaryContainer
                      : scheme.onSurfaceVariant,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected
                          ? scheme.onPrimaryContainer
                          : scheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _shortcut(
    BuildContext context,
    IconData icon,
    String label,
    String path,
  ) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      dense: true,
      leading: Icon(icon, size: 20, color: scheme.onSurfaceVariant),
      title: Text(label),
      onTap: () => context.push(path),
    );
  }
}
