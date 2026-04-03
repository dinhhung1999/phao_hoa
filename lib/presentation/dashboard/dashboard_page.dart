import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_widget.dart';
import '../../domain/entities/warehouse_stock.dart';
import 'dashboard_bloc.dart';
import 'inventory_detail_sheet.dart';
import 'reconciliation_page.dart';

/// Tab 1: Dashboard / Tồn kho — redesigned for clarity & visual impact
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  String _searchQuery = '';

  // Location keys from central constants
  static List<String> get _locationKeys => AppConstants.warehouseLocationKeys;

  // Stock level thresholds
  static const int _criticalThreshold = 5;
  static const int _lowThreshold = 20;

  @override
  void initState() {
    super.initState();
    // Tabs: Tất cả + each warehouse
    _tabController = TabController(
      length: 1 + AppConstants.warehouseLocationNames.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Get the relevant quantity for a stock given the selected tab
  int _getDisplayQuantity(WarehouseStock stock, int tabIndex) {
    if (tabIndex == 0) return stock.totalQuantity;
    final key = _locationKeys[tabIndex - 1];
    return stock.getStockAt(key);
  }

  /// Filter & search stocks
  List<WarehouseStock> _filterStocks(
      List<WarehouseStock> stocks, int tabIndex) {
    var filtered = stocks;

    // Filter by warehouse if a specific tab is selected
    if (tabIndex > 0) {
      final key = _locationKeys[tabIndex - 1];
      filtered =
          filtered.where((s) => s.getStockAt(key) > 0).toList();
    }

    // Search
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      filtered =
          filtered.where((s) => s.productName.toLowerCase().contains(q)).toList();
    }

    return filtered;
  }

  int _getLowStockCount(List<WarehouseStock> stocks) {
    return stocks.where((s) => s.totalQuantity < _criticalThreshold && s.totalQuantity > 0).length;
  }

  int _getOutOfStockCount(List<WarehouseStock> stocks) {
    return stocks.where((s) => s.totalQuantity == 0).length;
  }

  @override
  Widget build(BuildContext context) {
    // No Scaffold/AppBar here — HomePage handles the shared AppBar
    return Stack(
      children: [
        BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            return state.map(
              initial: (_) {
                context
                    .read<DashboardBloc>()
                    .add(const DashboardEvent.loadDashboard());
                return const AppLoadingIndicator();
              },
              loading: (_) => const AppLoadingIndicator(
                message: 'Đang tải dữ liệu...',
              ),
              loaded: (loaded) => _buildBody(loaded.stocks, loaded.totalValue),
              error: (e) => AppErrorWidget(
                message: e.message,
                onRetry: () => context
                    .read<DashboardBloc>()
                    .add(const DashboardEvent.loadDashboard()),
              ),
            );
          },
        ),
        // Floating action button for reconciliation
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton.extended(
            heroTag: 'fab_dashboard',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<DashboardBloc>(),
                    child: const ReconciliationPage(),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.fact_check_outlined),
            label: const Text('Đối soát'),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildBody(List<WarehouseStock> stocks, double totalValue) {
    final lowCount = _getLowStockCount(stocks);
    final outOfStockCount = _getOutOfStockCount(stocks);

    return RefreshIndicator(
      onRefresh: () async {
        context
            .read<DashboardBloc>()
            .add(const DashboardEvent.refreshDashboard());
      },
      child: Column(
        children: [
          // ── Summary Cards ──
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                _SummaryCard(
                  icon: Icons.inventory_2,
                  label: 'Tổng sản phẩm',
                  value: '${stocks.length}',
                  color: AppColors.info,
                ),
                const SizedBox(width: 10),
                _SummaryCard(
                  icon: Icons.account_balance_wallet,
                  label: 'Giá trị kho',
                  value: CurrencyFormatter.format(totalValue),
                  color: AppColors.primary,
                  wide: true,
                ),
                const SizedBox(width: 10),
                _SummaryCard(
                  icon: Icons.warning_amber_rounded,
                  label: 'Sắp hết',
                  value: '$lowCount',
                  color: lowCount > 0 ? AppColors.warning : AppColors.success,
                ),
                const SizedBox(width: 10),
                _SummaryCard(
                  icon: Icons.remove_shopping_cart,
                  label: 'Hết hàng',
                  value: '$outOfStockCount',
                  color: outOfStockCount > 0
                      ? AppColors.error
                      : AppColors.success,
                ),
              ],
            ),
          ),

          // ── Search Bar ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm sản phẩm trong kho...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () => setState(() => _searchQuery = ''),
                      )
                    : null,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withValues(alpha: 0.5),
              ),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),

          // ── Warehouse Tabs ──
          TabBar(
            controller: _tabController,
            onTap: (_) => setState(() {}),
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            tabs: [
              _buildTab(Icons.select_all, 'Tất cả', stocks.length),
              ...List.generate(AppConstants.warehouseLocationNames.length, (i) {
                final key = _locationKeys[i];
                final count =
                    stocks.where((s) => s.getStockAt(key) > 0).length;
                return _buildTab(
                    Icons.warehouse_outlined,
                    AppConstants.warehouseLocationNames[i],
                    count);
              }),
            ],
          ),

          // ── Stock List ──
          Expanded(
            child: Builder(
              builder: (context) {
                final filtered =
                    _filterStocks(stocks, _tabController.index);
                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_outlined,
                            size: 64, color: AppColors.textHint),
                        const SizedBox(height: 12),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'Không tìm thấy "$_searchQuery"'
                              : 'Chưa có dữ liệu tồn kho',
                          style:
                              const TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final stock = filtered[index];
                    return _StockCard(
                      stock: stock,
                      tabIndex: _tabController.index,
                      displayQuantity: _getDisplayQuantity(
                          stock, _tabController.index),
                      criticalThreshold: _criticalThreshold,
                      lowThreshold: _lowThreshold,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (_) => InventoryDetailSheet(stock: stock),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(IconData icon, String label, int count) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(label),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Summary Card Widget
// ─────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool wide;

  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.wide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: wide ? 160 : 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.12),
            color.withValues(alpha: 0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: wide ? 14 : 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Stock Card Widget — visual & color-coded
// ─────────────────────────────────────────────

class _StockCard extends StatelessWidget {
  final WarehouseStock stock;
  final int tabIndex;
  final int displayQuantity;
  final int criticalThreshold;
  final int lowThreshold;
  final VoidCallback onTap;

  const _StockCard({
    required this.stock,
    required this.tabIndex,
    required this.displayQuantity,
    required this.criticalThreshold,
    required this.lowThreshold,
    required this.onTap,
  });

  Color get _statusColor {
    if (displayQuantity == 0) return AppColors.error;
    if (displayQuantity < criticalThreshold) return AppColors.error;
    if (displayQuantity < lowThreshold) return AppColors.warning;
    return AppColors.success;
  }

  String get _statusLabel {
    if (displayQuantity == 0) return 'Hết hàng';
    if (displayQuantity < criticalThreshold) return 'Sắp hết';
    if (displayQuantity < lowThreshold) return 'Thấp';
    return 'Đủ hàng';
  }

  IconData get _statusIcon {
    if (displayQuantity == 0) return Icons.error_outline;
    if (displayQuantity < criticalThreshold) return Icons.warning_amber;
    if (displayQuantity < lowThreshold) return Icons.info_outline;
    return Icons.check_circle_outline;
  }

  @override
  Widget build(BuildContext context) {
    final isCritical = displayQuantity < criticalThreshold;
    final locationKeys = AppConstants.warehouseLocationKeys;

    return Card(
      elevation: isCritical ? 2 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: isCritical
            ? BorderSide(color: _statusColor.withValues(alpha: 0.4), width: 1.5)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Name + Status badge + Total quantity
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stock.productName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_statusIcon, size: 14, color: _statusColor),
                        const SizedBox(width: 4),
                        Text(
                          _statusLabel,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Total quantity
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$displayQuantity',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: _statusColor,
                        ),
                      ),
                      Text(
                        tabIndex == 0 ? 'Tổng' : 'Tồn',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Warehouse breakdown bars (show all when on "Tất cả" tab)
              if (tabIndex == 0)
                ...List.generate(locationKeys.length, (i) {
                  final key = locationKeys[i];
                  final qty = stock.getStockAt(key);
                  final total = stock.totalQuantity;
                  final ratio = total > 0 ? qty / total : 0.0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: _WarehouseBar(
                      name: AppConstants.warehouseLocationNames[i],
                      quantity: qty,
                      ratio: ratio,
                      criticalThreshold: criticalThreshold,
                      lowThreshold: lowThreshold,
                    ),
                  );
                })
              else
                // Single warehouse bar
                _WarehouseBar(
                  name: AppConstants.warehouseLocationNames[tabIndex - 1],
                  quantity: displayQuantity,
                  ratio: 1.0,
                  criticalThreshold: criticalThreshold,
                  lowThreshold: lowThreshold,
                ),

              // Tap hint
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Xem chi tiết',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.primary.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    Icons.chevron_right,
                    size: 14,
                    color: AppColors.primary.withValues(alpha: 0.7),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Warehouse Progress Bar
// ─────────────────────────────────────────────

class _WarehouseBar extends StatelessWidget {
  final String name;
  final int quantity;
  final double ratio;
  final int criticalThreshold;
  final int lowThreshold;

  const _WarehouseBar({
    required this.name,
    required this.quantity,
    required this.ratio,
    required this.criticalThreshold,
    required this.lowThreshold,
  });

  Color get _barColor {
    if (quantity == 0) return AppColors.textHint;
    if (quantity < criticalThreshold) return AppColors.error;
    if (quantity < lowThreshold) return AppColors.warning;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 48,
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: AppColors.divider.withValues(alpha: 0.5),
              valueColor: AlwaysStoppedAnimation<Color>(_barColor),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 32,
          child: Text(
            '$quantity',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _barColor,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
