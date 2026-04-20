import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_widget.dart';
import '../../core/utils/date_formatter.dart';
import '../../domain/entities/warehouse_stock.dart';
import '../../domain/entities/inventory_snapshot.dart';
import '../../domain/usecases/inventory/inventory_usecases.dart';
import '../../injection_container.dart';
import '../dashboard/dashboard_bloc.dart';
import 'reconciliation_history_page.dart';

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
  bool _isCompleting = false;
  InventorySnapshot? _lastReconciliation;
  bool _historyLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadLastReconciliation();
  }

  Future<void> _loadLastReconciliation() async {
    final result = await sl<GetReconciliationHistory>().call();
    result.fold(
      (_) {},
      (history) {
        if (mounted) {
          setState(() {
            _lastReconciliation = history.isNotEmpty ? history.first : null;
            _historyLoaded = true;
          });
        }
      },
    );
  }

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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ReconciliationHistoryPage(),
                ),
              );
            },
            icon: const Icon(Icons.history),
            tooltip: 'Lịch sử đối soát',
          ),
        ],
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

        // Last reconciliation info — always visible at top for reference
        if (_historyLoaded && _lastReconciliation != null)
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ReconciliationHistoryPage(),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.history, color: AppColors.primary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Đối soát gần nhất',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${DateFormatter.formatDateTime(_lastReconciliation!.date)} • '
                          '${_lastReconciliation!.hasDiscrepancy ? "Có chênh lệch" : "Khớp tất cả"}'
                          '${_lastReconciliation!.notes != null ? " • ${_lastReconciliation!.notes}" : ""}',
                          style: TextStyle(
                            fontSize: 12,
                            color: _lastReconciliation!.hasDiscrepancy
                                ? AppColors.error
                                : AppColors.textSecondaryOf(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _lastReconciliation!.hasDiscrepancy
                        ? Icons.warning_amber
                        : Icons.check_circle,
                    size: 18,
                    color: _lastReconciliation!.hasDiscrepancy
                        ? AppColors.error
                        : AppColors.success,
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: AppColors.textHintOf(context),
                  ),
                ],
              ),
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
                      onPressed: _isCompleting ? null : () => setState(() => _submitted = false),
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
                    onPressed: _isCompleting
                        ? null
                        : _submitted
                            ? () => _completeReconciliation(stocks, locationKeysToShow)
                            : () => setState(() => _submitted = true),
                    icon: _isCompleting
                        ? const SizedBox(
                            width: 18, height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                          )
                        : Icon(
                            _submitted ? Icons.check : Icons.fact_check,
                            size: 20),
                    label: Text(_isCompleting
                        ? 'Đang lưu...'
                        : _submitted ? 'Hoàn thành đối soát' : 'So sánh'),
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

  /// Perform actual reconciliation — save to Firestore and show report
  Future<void> _completeReconciliation(
    List<WarehouseStock> stocks,
    List<String> locationKeysToShow,
  ) async {
    // Build reconciliation items
    final items = <ReconciliationItem>[];
    bool hasDiscrepancy = false;

    for (final stock in stocks) {
      for (final locationKey in locationKeysToShow) {
        final systemQty = stock.getStockAt(locationKey);
        final ctl = _actualQuantityCtls[stock.productId]?[locationKey];
        final actualQty = int.tryParse(ctl?.text ?? '') ?? 0;
        final diff = actualQty - systemQty;

        items.add(ReconciliationItem(
          productId: stock.productId,
          productName: stock.productName,
          warehouseLocation: locationKey,
          systemQuantity: systemQty,
          actualQuantity: actualQty,
          difference: diff,
          isMatched: diff == 0,
        ));

        if (diff != 0) hasDiscrepancy = true;
      }
    }

    // Ask if user wants to adjust inventory when there are discrepancies
    bool shouldAdjust = false;
    if (hasDiscrepancy) {
      final result = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 24),
              SizedBox(width: 8),
              Expanded(child: Text('Có chênh lệch tồn kho', style: TextStyle(fontSize: 16))),
            ],
          ),
          content: const Text(
            'Bạn có muốn điều chỉnh tồn kho hệ thống theo số lượng thực tế không?\n\n'
            '• Chọn "Điều chỉnh" để cập nhật tồn kho theo thực tế\n'
            '• Chọn "Chỉ lưu" để ghi nhận chênh lệch mà không thay đổi',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Chỉ lưu'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Điều chỉnh'),
            ),
          ],
        ),
      );
      if (result == null) return; // Cancelled
      shouldAdjust = result;
    }

    // Perform reconciliation
    setState(() => _isCompleting = true);

    final userId = FirebaseAuth.instance.currentUser?.email ?? 'unknown';
    final warehouseLocation = _selectedWarehouse == 'all'
        ? 'all'
        : AppConstants.getLocationKey(_selectedWarehouse);

    final reconResult = await sl<PerformStockReconciliation>().call(
      userId: userId,
      warehouseLocation: warehouseLocation,
      items: items,
      shouldAdjust: shouldAdjust,
    );

    setState(() => _isCompleting = false);

    reconResult.fold(
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi: ${failure.message}'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      (reconId) {
        _showReconciliationReport(items, hasDiscrepancy, shouldAdjust);
      },
    );
  }

  /// Show reconciliation report dialog
  void _showReconciliationReport(
    List<ReconciliationItem> items,
    bool hasDiscrepancy,
    bool adjusted,
  ) {
    final matched = items.where((i) => i.isMatched).length;
    final discrepancies = items.where((i) => !i.isMatched).toList();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(
              hasDiscrepancy ? Icons.assignment_turned_in : Icons.check_circle,
              color: hasDiscrepancy ? AppColors.warning : AppColors.success,
              size: 24,
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text('Báo cáo đối soát', style: TextStyle(fontSize: 17)),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary stats
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    _reportRow('Tổng vị trí kiểm tra', '${items.length}'),
                    const SizedBox(height: 6),
                    _reportRow('Khớp', '$matched', color: AppColors.success),
                    const SizedBox(height: 6),
                    _reportRow('Chênh lệch', '${discrepancies.length}',
                        color: discrepancies.isNotEmpty ? AppColors.error : AppColors.success),
                  ],
                ),
              ),
              if (hasDiscrepancy) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: adjusted
                        ? AppColors.success.withValues(alpha: 0.08)
                        : AppColors.warning.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: adjusted
                          ? AppColors.success.withValues(alpha: 0.2)
                          : AppColors.warning.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        adjusted ? Icons.check_circle : Icons.info_outline,
                        size: 18,
                        color: adjusted ? AppColors.success : AppColors.warning,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          adjusted
                              ? 'Đã điều chỉnh tồn kho theo thực tế'
                              : 'Chưa điều chỉnh tồn kho',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: adjusted ? AppColors.success : AppColors.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Chi tiết chênh lệch:',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 8),
                ...discrepancies.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${item.productName} (${AppConstants.getDisplayName(item.warehouseLocation)})',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      Text(
                        '${item.difference > 0 ? '+' : ''}${item.difference}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: item.difference > 0 ? AppColors.success : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx); // close dialog
              Navigator.pop(context); // go back to dashboard
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  Widget _reportRow(String label, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13)),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
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