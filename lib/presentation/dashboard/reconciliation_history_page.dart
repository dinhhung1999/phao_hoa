import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../domain/entities/inventory_snapshot.dart';
import '../../domain/usecases/inventory/inventory_usecases.dart';
import '../../data/datasources/inventory_remote_datasource.dart';
import '../../injection_container.dart';

/// Page to view reconciliation history list with drill-down details
class ReconciliationHistoryPage extends StatefulWidget {
  const ReconciliationHistoryPage({super.key});

  @override
  State<ReconciliationHistoryPage> createState() =>
      _ReconciliationHistoryPageState();
}

class _ReconciliationHistoryPageState extends State<ReconciliationHistoryPage> {
  List<InventorySnapshot>? _history;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _error = null;
      _history = null;
    });
    final result = await sl<GetReconciliationHistory>().call();
    if (!mounted) return;
    result.fold(
      (failure) => setState(() => _error = failure.message),
      (history) => setState(() => _history = history),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử đối soát'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 12),
            Text(_error!, style: TextStyle(color: AppColors.textSecondaryOf(context))),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadHistory,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (_history == null) {
      return const AppLoadingIndicator(message: 'Đang tải lịch sử...');
    }

    if (_history!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fact_check_outlined,
                size: 64, color: AppColors.textHintOf(context)),
            const SizedBox(height: 12),
            Text(
              'Chưa có lịch sử đối soát nào',
              style: TextStyle(color: AppColors.textSecondaryOf(context)),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadHistory,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _history!.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final snapshot = _history![index];
          return _ReconciliationCard(
            snapshot: snapshot,
            onTap: () => _showDetail(snapshot),
          );
        },
      ),
    );
  }

  void _showDetail(InventorySnapshot snapshot) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _ReconciliationDetailPage(snapshot: snapshot),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Reconciliation History Card
// ─────────────────────────────────────────────

class _ReconciliationCard extends StatelessWidget {
  final InventorySnapshot snapshot;
  final VoidCallback onTap;

  const _ReconciliationCard({
    required this.snapshot,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasDiscrepancy = snapshot.hasDiscrepancy;
    final statusColor = hasDiscrepancy ? AppColors.error : AppColors.success;
    final statusLabel = hasDiscrepancy ? 'Có chênh lệch' : 'Khớp tất cả';
    final statusIcon =
        hasDiscrepancy ? Icons.warning_amber_rounded : Icons.check_circle;

    return Card(
      elevation: hasDiscrepancy ? 2 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: hasDiscrepancy
            ? BorderSide(color: AppColors.error.withValues(alpha: 0.3), width: 1)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Date/time icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(statusIcon, color: statusColor, size: 24),
              ),
              const SizedBox(width: 14),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormatter.formatDateTime(snapshot.date),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        // Status badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            statusLabel,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Created by
                        Expanded(
                          child: Text(
                            snapshot.createdBy,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondaryOf(context),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (snapshot.notes != null && snapshot.notes!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        snapshot.notes!,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondaryOf(context),
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              // Chevron
              Icon(
                Icons.chevron_right,
                color: AppColors.textHintOf(context),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Reconciliation Detail Page — shows items
// ─────────────────────────────────────────────

class _ReconciliationDetailPage extends StatefulWidget {
  final InventorySnapshot snapshot;

  const _ReconciliationDetailPage({required this.snapshot});

  @override
  State<_ReconciliationDetailPage> createState() =>
      _ReconciliationDetailPageState();
}

class _ReconciliationDetailPageState extends State<_ReconciliationDetailPage> {
  List<Map<String, dynamic>>? _items;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final items = await sl<InventoryRemoteDatasource>()
          .getReconciliationItems(widget.snapshot.id);
      if (!mounted) return;
      setState(() {
        _items = items;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = widget.snapshot;
    final hasDiscrepancy = snapshot.hasDiscrepancy;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đối soát'),
      ),
      body: Column(
        children: [
          // Header info
          _buildHeader(snapshot, hasDiscrepancy),
          // Items list
          Expanded(child: _buildItemsList()),
        ],
      ),
    );
  }

  Widget _buildHeader(InventorySnapshot snapshot, bool hasDiscrepancy) {
    final statusColor = hasDiscrepancy ? AppColors.error : AppColors.success;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            statusColor.withValues(alpha: 0.1),
            statusColor.withValues(alpha: 0.03),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: statusColor.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                hasDiscrepancy
                    ? Icons.warning_amber_rounded
                    : Icons.check_circle,
                color: statusColor,
                size: 22,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  hasDiscrepancy ? 'Có chênh lệch' : 'Khớp tất cả',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _infoRow(Icons.calendar_today, 'Ngày',
              DateFormatter.formatDateTime(snapshot.date)),
          const SizedBox(height: 4),
          _infoRow(Icons.person_outline, 'Người thực hiện',
              snapshot.createdBy),
          if (snapshot.notes != null && snapshot.notes!.isNotEmpty) ...[
            const SizedBox(height: 4),
            _infoRow(Icons.note_outlined, 'Ghi chú', snapshot.notes!),
          ],
          if (_items != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                _summaryChip(
                  '${_items!.length} vị trí',
                  AppColors.info,
                ),
                const SizedBox(width: 8),
                _summaryChip(
                  '${_items!.where((i) => i['is_matched'] == true).length} khớp',
                  AppColors.success,
                ),
                const SizedBox(width: 8),
                _summaryChip(
                  '${_items!.where((i) => i['is_matched'] != true).length} lệch',
                  _items!.any((i) => i['is_matched'] != true)
                      ? AppColors.error
                      : AppColors.success,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondaryOf(context)),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondaryOf(context),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _summaryChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildItemsList() {
    if (_loading) {
      return const AppLoadingIndicator(message: 'Đang tải chi tiết...');
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 40, color: AppColors.error),
            const SizedBox(height: 8),
            Text(_error!, style: TextStyle(color: AppColors.textSecondaryOf(context))),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: _loadItems,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (_items == null || _items!.isEmpty) {
      return Center(
        child: Text(
          'Không có dữ liệu chi tiết',
          style: TextStyle(color: AppColors.textSecondaryOf(context)),
        ),
      );
    }

    // Group items by product
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final item in _items!) {
      final productName = item['product_name'] as String? ?? 'Không rõ';
      grouped.putIfAbsent(productName, () => []).add(item);
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: grouped.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final productName = grouped.keys.elementAt(index);
        final items = grouped[productName]!;
        final hasAnyDiscrepancy = items.any((i) => i['is_matched'] != true);

        return Card(
          elevation: hasAnyDiscrepancy ? 2 : 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: hasAnyDiscrepancy
                ? BorderSide(
                    color: AppColors.error.withValues(alpha: 0.3), width: 1)
                : BorderSide.none,
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product name
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        productName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Icon(
                      hasAnyDiscrepancy
                          ? Icons.warning_amber
                          : Icons.check_circle,
                      size: 18,
                      color: hasAnyDiscrepancy
                          ? AppColors.error
                          : AppColors.success,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Column headers
                Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text('Kho',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondaryOf(context))),
                    ),
                    SizedBox(
                      width: 55,
                      child: Text('Hệ thống',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondaryOf(context)),
                          textAlign: TextAlign.center),
                    ),
                    SizedBox(
                      width: 55,
                      child: Text('Thực tế',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondaryOf(context)),
                          textAlign: TextAlign.center),
                    ),
                    Expanded(
                      child: Text('Kết quả',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondaryOf(context)),
                          textAlign: TextAlign.center),
                    ),
                  ],
                ),
                const Divider(height: 12),
                // Location rows
                ...items.map((item) {
                  final locationKey =
                      item['warehouse_location'] as String? ?? '';
                  final locationName =
                      AppConstants.getDisplayName(locationKey);
                  final systemQty = item['system_quantity'] as int? ?? 0;
                  final actualQty = item['actual_quantity'] as int? ?? 0;
                  final diff = item['difference'] as int? ?? (actualQty - systemQty);
                  final isMatched = item['is_matched'] as bool? ?? (diff == 0);

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 80,
                          child: Text(
                            locationName,
                            style: const TextStyle(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // System qty
                        SizedBox(
                          width: 55,
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
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        // Actual qty
                        SizedBox(
                          width: 55,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 6),
                            decoration: BoxDecoration(
                              color: isMatched
                                  ? AppColors.success.withValues(alpha: 0.08)
                                  : AppColors.error.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '$actualQty',
                              style: TextStyle(
                                color: isMatched
                                    ? AppColors.success
                                    : AppColors.error,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Diff badge
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isMatched
                                  ? AppColors.success.withValues(alpha: 0.1)
                                  : AppColors.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isMatched
                                  ? 'Khớp'
                                  : '${diff > 0 ? '+' : ''}$diff',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isMatched
                                    ? AppColors.success
                                    : AppColors.error,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
