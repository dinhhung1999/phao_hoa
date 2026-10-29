import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../category/category_page.dart';
import '../customer/customer_list_page.dart';
import '../formula/formula_list_page.dart';

/// Combined "Danh mục" tab with sub-tabs: Sản phẩm, Khách hàng & Công thức
class CatalogPage extends StatefulWidget {
  final int initialTabIndex;

  const CatalogPage({super.key, this.initialTabIndex = 0});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  late int _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTabIndex;
  }

  @override
  void didUpdateWidget(CatalogPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTabIndex != widget.initialTabIndex) {
      _selectedTab = widget.initialTabIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      key: ValueKey(widget.initialTabIndex),
      length: 3,
      initialIndex: widget.initialTabIndex,
      child: Column(
        children: [
          Material(
            color:
                Theme.of(context).appBarTheme.backgroundColor ??
                Theme.of(context).colorScheme.surface,
            elevation: 0,
            child: TabBar(
              isScrollable: kIsWeb,
              tabAlignment: kIsWeb ? TabAlignment.start : null,
              padding: kIsWeb
                  ? const EdgeInsets.symmetric(horizontal: 16)
                  : EdgeInsets.zero,
              onTap: (index) {
                if (!kIsWeb) return;
                setState(() => _selectedTab = index);
                const paths = [
                  '/catalog/products',
                  '/catalog/customers',
                  '/catalog/formulas',
                ];
                context.go(paths[index]);
              },
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              tabs: const [
                Tab(
                  icon: Icon(Icons.inventory_2_outlined, size: 20),
                  text: 'Sản phẩm',
                  iconMargin: EdgeInsets.only(bottom: 4),
                ),
                Tab(
                  icon: Icon(Icons.people_outline, size: 20),
                  text: 'Khách hàng',
                  iconMargin: EdgeInsets.only(bottom: 4),
                ),
                Tab(
                  icon: Icon(Icons.science_outlined, size: 20),
                  text: 'Công thức',
                  iconMargin: EdgeInsets.only(bottom: 4),
                ),
              ],
            ),
          ),
          Expanded(
            child: kIsWeb
                ? IndexedStack(
                    index: _selectedTab,
                    children: const [
                      CategoryPage(showAppBar: false),
                      CustomerListPage(showAppBar: false),
                      FormulaListPage(showAppBar: false),
                    ],
                  )
                : const TabBarView(
                    children: [
                      CategoryPage(showAppBar: false),
                      CustomerListPage(showAppBar: false),
                      FormulaListPage(showAppBar: false),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
