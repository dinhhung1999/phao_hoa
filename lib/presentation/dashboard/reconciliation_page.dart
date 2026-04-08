import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_widget.dart';
import '../../domain/entities/warehouse_stock.dart';
import '../dashboard/dashboard_bloc.dart';

/// Reconciliation page — physically count inventory and compare with system
class ReconciliationPage extends StatefulWidget {
  const ReconciliationPage({super.key});

  @override
  State<ReconciliationPage> createState() => _ReconciliationPageState();
}

class _ReconciliationPageState extends State<ReconciliationPage> {
  final Map<String, Map<String, TextEditingController>> _actualQuantityCtls =
      {};
  bool _submitted = false;
  String _selectedWarehouse = 'all';

  @override
  void dispose() {
    for (final map in _actualQuantityCtls.values) {
      for (final ctl in map.values) {
        ctl.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đối soát tồn kho'),
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          return state.map(
            initial: (_) {
              context
                  .read<DashboardBloc>()
                  .add(const DashboardEvent.loadDashboard());
              return const AppLoadingIndicator();
            },
            loading: (_) =>
                const AppLoadingIndicator(message: 'Đang tải dữ liệu...'),
            loaded: (loaded) => _buildReconciliation(loaded.stocks),
            error: (e) => AppErrorWidget(
              message: e.message,
              onRetry: () => context
                  .read<DashboardBloc>()
                  .add(const DashboardEvent.loadDashboard()),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReconciliation(List<WarehouseStock> stocks) {
    if (stocks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined,
                size: 64, color: AppColors.textHintOf(context)),
            SizedBox(height: 12),
            Text('Chưa có dữ liệu tồn kho để đối soát',
                style: TextStyle(color: AppColors.textSecondaryOf(context))),
          ],
        ),
      );
    }

    // Determine which locations to show based on filter
    final allNames = AppConstants.warehouseLocationNames;
    final allKeys = AppConstants.warehouseLocationKeys;
    List<String> locationsToShow;
    List<String> locationKeysToShow;

    if (_selectedWarehouse == 'all') {
      locationsToShow = allNames;
      locationKeysToShow = allKeys;
    } else {
      final idx = allNames.indexOf(_selectedWarehouse);
      locationsToShow = [_selectedWarehouse];
      locationKeysToShow = idx >= 0 ? [allKeys[idx]] : [_selectedWarehouse.toLowerCase().replaceAll(' ', '_')];
    }

    // Initialize controllers for each product/location combination
    for (final stock in stocks) {
      if (!_actualQuantityCtls.containsKey(stock.productId)) {
        _actualQuantityCtls[stock.productId] = {};
        for (int i = 0; i < allNames.length; i++) {
          final locationKey = allKeys[i];
          _actualQuantityCtls[stock.productId]![locationKey] =
              TextEditingController(
            text: _submitted ? null : stock.getStockAt(locationKey).toString(),
          );
        }
      }
    }

    // Calculate progress & summary
    int totalItems = stocks.length * locationKeysToShow.length;
    int matchedCount = 0;
    int discrepancyCount = 0;
    int totalDifference = 0;

    if (_submitted) {
      for (final stock in stocks) {
        for (final locationKey in locationKeysToShow) {
          final systemQty = stock.getStockAt(locationKey);
          final ctl = _actualQuantityCtls[stock.productId]?[locationKey];
          final actualQty = int.tryParse(ctl?.text ?? '') ?? 0;
          final diff = actualQty - systemQty;
          if (diff == 0) {
            matchedCount++;
          } else {
            discrepancyCount++;
            totalDifference += diff.abs();
          }
        }
      }
    }

    return Column(
      children: [
        // ── Warehouse filter ──
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.05),
            border: Border(
              bottom: BorderSide(color: AppColors.divider.withValues(alpha: 0.5)),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.warehouse_outlined,
                  size: 18, color: AppColors.info),
              SizedBox(width: 8),
              Text(
                'Kho:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.textSecondaryOf(context),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _WarehouseChip(
                        label: 'Tất cả',
                        selected: _selectedWarehouse == 'all',
                        onTap: () =>
                            setState(() => _selectedWarehouse = 'all'),
                      ),
                      const SizedBox(width: 6),
                      ...AppConstants.warehouseLocationNames.map((name) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: _WarehouseChip(
                            label: name,
                            selected: _selectedWarehouse == name,
                            onTap: () =>
                                setState(() => _selectedWarehouse = name),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Progress / Summary ──
        if (_submitted)
          _buildSummaryPanel(
            totalItems: totalItems,
            matchedCount: matchedCount,
            discrepancyCount: discrepancyCount,
            totalDifference: totalDifference,
          )
        else
          // Instructions
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.info.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.info, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Nhập số lượng thực tế kiểm đếm vào ô bên phải, '
                    'sau đó nhấn "So sánh" để xem chênh lệch.',
                    style:
                        TextStyle(color: AppColors.textSecondaryOf(context), fontSize: 13),
                  ),
                ),
              ],
            ),
          ),

        // Product list
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            itemCount: stocks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final stock = stocks[index];
              return _buildStockCard(stock, locationsToShow, locationKeysToShow);
            },
          ),
        ),

        // Action buttons
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                if (_submitted) ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => setState(() => _submitted = false),
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Nhập lại'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  flex: _submitted ? 2 : 1,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() => _submitted = true);
                    },
                    icon: Icon(
                        _submitted ? Icons.check : Icons.fact_check,
                        size: 20),
                    label: Text(_submitted ? 'Hoàn thành đối soát' : 'So sánh'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _submitted ? AppColors.success : AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryPanel({
    required int totalItems,
    required int matchedCount,
    required int discrepancyCount,
    required int totalDifference,
  }) {
    final allMatch = discrepancyCount == 0;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: allMatch
              ? [
                  AppColors.success.withValues(alpha: 0.12),
                  AppColors.success.withValues(alpha: 0.04),
                ]
              : [
                  AppColors.error.withValues(alpha: 0.12),
                  AppColors.warning.withValues(alpha: 0.04),
                ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: allMatch
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.error.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Icon(
                allMatch ? Icons.check_circle : Icons.warning_amber_rounded,
                color: allMatch ? AppColors.success : AppColors.error,
                size: 24,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  allMatch
                      ? 'Tất cả hàng hóa khớp!'
                      : 'Có $discrepancyCount vị trí chênh lệch',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: allMatch ? AppColors.success : AppColors.error,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Stats row
          Row(
            children: [
              _StatItem(
                icon: Icons.check_circle_outline,
                label: 'Khớp',
                value: '$matchedCount',
                color: AppColors.success,
              ),
              _StatItem(
                icon: Icons.error_outline,
                label: 'Lệch',
                value: '$discrepancyCount',
                color:
                    discrepancyCount > 0 ? AppColors.error : AppColors.success,
              ),
              _StatItem(
                icon: Icons.swap_vert,
                label: 'Tổng lệch',
                value: '$totalDifference',
                color: totalDifference > 0
                    ? AppColors.warning
                    : AppColors.success,
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: totalItems > 0 ? matchedCount / totalItems : 0,
              minHeight: 6,
              backgroundColor: AppColors.error.withValues(alpha: 0.2),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.success),
            ),
          ),
          SizedBox(height: 4),
          Text(
            '$matchedCount / $totalItems vị trí đã kiểm khớp',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondaryOf(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockCard(
    WarehouseStock stock,
    List<String> locationsToShow,
    List<String> locationKeysToShow,
  ) {
    // Check if any location has discrepancy (for card highlighting)
    bool hasAnyDiscrepancy = false;
    if (_submitted) {
      for (final locationKey in locationKeysToShow) {
        final systemQty = stock.getStockAt(locationKey);
        final ctl = _actualQuantityCtls[stock.productId]?[locationKey];
        final actualQty = int.tryParse(ctl?.text ?? '') ?? 0;
        if (actualQty - systemQty != 0) {
          hasAnyDiscrepancy = true;
          break;
        }
      }
    }

    return Card(
      elevation: hasAnyDiscrepancy ? 2 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: hasAnyDiscrepancy
            ? BorderSide(
                color: AppColors.error.withValues(alpha: 0.4), width: 1.5)
            : (_submitted
                ? BorderSide(
                    color: AppColors.success.withValues(alpha: 0.3), width: 1)
                : BorderSide.none),
      ),
      color: hasAnyDiscrepancy
          ? AppColors.error.withValues(alpha: 0.03)
          : null,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product name + system total
            Row(
              children: [
                Expanded(
                  child: Text(
                    stock.productName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                if (_submitted)
                  Icon(
                    hasAnyDiscrepancy
                        ? Icons.warning_amber
                        : Icons.check_circle,
                    size: 20,
                    color: hasAnyDiscrepancy
                        ? AppColors.error
                        : AppColors.success,
                  ),
              ],
            ),
            Text(
              'Tổng hệ thống: ${stock.totalQuantity}',
              style: TextStyle(
                  color: AppColors.textSecondaryOf(context), fontSize: 12),
            ),
            const SizedBox(height: 12),

            // Column headers
            Row(
              children: [
                SizedBox(
                    width: 70,
                    child: Text('Kho',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondaryOf(context)))),
                SizedBox(
                    width: 50,
                    child: Text('Hệ thống',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondaryOf(context)),
                        textAlign: TextAlign.center)),
                SizedBox(width: 24), // arrow space
                SizedBox(
                    width: 70,
                    child: Text('Thực tế',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondaryOf(context)),
                        textAlign: TextAlign.center)),
                Expanded(
                    child: Text('Kết quả',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondaryOf(context)),
                        textAlign: TextAlign.center)),
              ],
            ),
            const Divider(height: 12),

            // Location rows
            ...List.generate(locationsToShow.length, (i) {
              final location = locationsToShow[i];
              final locationKey = locationKeysToShow[i];
              final systemQty = stock.getStockAt(locationKey);
              final ctl =
                  _actualQuantityCtls[stock.productId]?[locationKey];
              final actualQty = int.tryParse(ctl?.text ?? '') ?? 0;
              final diff = actualQty - systemQty;
              final hasDiscrepancy = _submitted && diff != 0;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 70,
                      child: Text(location,
                          style: const TextStyle(fontSize: 13)),
                    ),
                    // System qty
                    SizedBox(
                      width: 50,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 6),
                        decoration: BoxDecoration(
                          color: AppColors.info.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '$systemQty',
                          style: const TextStyle(
                            color: AppColors.info,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(Icons.arrow_forward,
                          size: 14, color: AppColors.textHintOf(context)),
                    ),
                    // Actual qty input
                    SizedBox(
                      width: 70,
                      child: TextFormField(
                        controller: ctl,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: hasDiscrepancy
                              ? AppColors.error
                              : AppColors.textPrimaryOf(context),
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: hasDiscrepancy
                                  ? AppColors.error
                                  : AppColors.divider,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: hasDiscrepancy
                                  ? AppColors.error
                                  : AppColors.divider,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: hasDiscrepancy
                                  ? AppColors.error
                                  : AppColors.primary,
                              width: 1.5,
                            ),
                          ),
                        ),
                        onChanged: (_) {
                          if (_submitted) setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Discrepancy indicator
                    if (_submitted)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                            color: hasDiscrepancy
                                ? AppColors.error.withValues(alpha: 0.1)
                                : AppColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                hasDiscrepancy
                                    ? Icons.error_outline
                                    : Icons.check,
                                size: 14,
                                color: hasDiscrepancy
                                    ? AppColors.error
                                    : AppColors.success,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  hasDiscrepancy
                                      ? '${diff > 0 ? '+' : ''}$diff'
                                      : 'Khớp',
                                  style: TextStyle(
                                    color: hasDiscrepancy
                                        ? AppColors.error
                                        : AppColors.success,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      const Expanded(child: SizedBox()),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _WarehouseChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _WarehouseChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.15)
              : Colors.transparent,
          border: Border.all(
            color:
                selected ? AppColors.primary : AppColors.divider,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            color:
                selected ? AppColors.primary : AppColors.textSecondaryOf(context),
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondaryOf(context),
            ),
          ),
        ],
      ),
    );
  }
}