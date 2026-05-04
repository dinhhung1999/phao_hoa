import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../category/category_page.dart';
import '../customer/customer_list_page.dart';
import '../formula/formula_list_page.dart';

/// Combined "Danh mục" tab with sub-tabs: Sản phẩm, Khách hàng & Công thức
class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Material(
            color: Theme.of(context).appBarTheme.backgroundColor ??
                Theme.of(context).colorScheme.surface,
            elevation: 0,
            child: TabBar(
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
          const Expanded(
            child: TabBarView(
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
