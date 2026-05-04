import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_widget.dart';
import '../category/category_bloc.dart';
import '../customer/customer_bloc.dart';
import '../dashboard/dashboard_bloc.dart';
import 'create_transaction_page.dart';
import 'transaction_detail_page.dart';
import 'transaction_bloc.dart';

/// Tab 3: Nhật ký giao dịch (most-used tab)
class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final ScrollController _scrollCtl = ScrollController();

  // Filter state
  bool _showFilters = false;
  String? _filterType; // null = all, 'nhap', 'xuat'
  String? _filterWarehouse;
  DateTimeRange? _filterDateRange;
  bool _filterDebtOnly = false;

  @override
  void initState() {
    super.initState();
    _scrollCtl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtl
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<TransactionBloc>().add(const TransactionEvent.loadMoreHistory());
    }
  }

  bool get _isBottom {
    if (!_scrollCtl.hasClients) return false;
    final maxScroll = _scrollCtl.position.maxScrollExtent;
    final currentScroll = _scrollCtl.offset;
    return currentScroll >= (maxScroll - 200);
  }

  void _applyFilters() {
    context.read<TransactionBloc>().add(TransactionEvent.loadHistoryPaginated(
          startDate: _filterDateRange?.start,
          endDate: _filterDateRange?.end,
          type: _filterType,
          warehouseLocation: _filterWarehouse,
        ));
  }

  void _clearFilters() {
    setState(() {
      _filterType = null;
      _filterWarehouse = null;
      _filterDateRange = null;
      _filterDebtOnly = false;
    });
    context
        .read<TransactionBloc>()
        .add(const TransactionEvent.loadHistoryPaginated());
  }

  bool get _hasActiveFilters =>
      _filterType != null ||
      _filterWarehouse != null ||
      _filterDateRange != null ||
      _filterDebtOnly;

  void _onTransactionCreated() {
    // Reload journal history
    context.read<TransactionBloc>().add(const TransactionEvent.loadHistoryPaginated());
    // Also refresh dashboard so inventory tab shows updated stock
    context.read<DashboardBloc>().add(const DashboardEvent.refreshDashboard());
  }

  @override
  Widget build(BuildContext context) {
    // No Scaffold/AppBar here — HomePage handles the shared AppBar
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.arrow_downward,
                  label: 'NHẬP KHO',
                  color: AppColors.importColor,
                  onPressed: () async {
                    final result = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (_) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(value: context.read<TransactionBloc>()),
                            BlocProvider.value(value: context.read<CategoryBloc>()),
                            BlocProvider.value(value: context.read<CustomerBloc>()),
                          ],
                          child: const CreateTransactionPage(type: 'nhap'),
                        ),
                      ),
                    );
                    if (result == true && context.mounted) {
                      _onTransactionCreated();
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionButton(
                  icon: Icons.arrow_upward,
                  label: 'XUẤT KHO',
                  color: AppColors.exportColor,
                  onPressed: () async {
                    final result = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (_) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(value: context.read<TransactionBloc>()),
                            BlocProvider.value(value: context.read<CategoryBloc>()),
                            BlocProvider.value(value: context.read<CustomerBloc>()),
                          ],
                          child: const CreateTransactionPage(type: 'xuat'),
                        ),
                      ),
                    );
                    if (result == true && context.mounted) {
                      _onTransactionCreated();
                    }
                  },
                ),
              ),
            ],
          ),
        ),

        // Filter toggle row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              InkWell(
                onTap: () => setState(() => _showFilters = !_showFilters),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _showFilters
                            ? Icons.filter_list_off
                            : Icons.filter_list,
                        size: 18,
                        color: _hasActiveFilters
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Bộ lọc',
                        style: TextStyle(
                          fontSize: 13,
                          color: _hasActiveFilters
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontWeight: _hasActiveFilters
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_hasActiveFilters) ...[
                const SizedBox(width: 8),
                InkWell(
                  onTap: _clearFilters,
                  borderRadius: BorderRadius.circular(8),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Text(
                      'Xóa lọc',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

        // Collapsible filter section
        if (_showFilters)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              children: [
                // Date range picker
                InkWell(
                  onTap: () async {
                    final range = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2024),
                      lastDate: DateTime.now(),
                      initialDateRange: _filterDateRange,
                      locale: const Locale('vi', 'VN'),
                    );
                    if (range != null) {
                      setState(() => _filterDateRange = range);
                      _applyFilters();
                    }
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.divider),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.date_range,
                            size: 18, color: AppColors.textSecondaryOf(context)),
                        const SizedBox(width: 8),
                        Text(
                          _filterDateRange != null
                              ? '${DateFormatter.formatDate(_filterDateRange!.start)} - ${DateFormatter.formatDate(_filterDateRange!.end)}'
                              : 'Chọn khoảng thời gian',
                          style: TextStyle(
                            fontSize: 13,
                            color: _filterDateRange != null
                                ? AppColors.textPrimary
                                : AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Type filter chips + warehouse dropdown
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(
                        label: 'Tất cả',
                        selected: _filterType == null && !_filterDebtOnly,
                        onTap: () {
                          setState(() {
                            _filterType = null;
                            _filterDebtOnly = false;
                          });
                          _applyFilters();
                        },
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Nhập kho',
                        selected: _filterType == 'nhap',
                        color: AppColors.importColor,
                        onTap: () {
                          setState(() => _filterType = 'nhap');
                          _applyFilters();
                        },
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Xuất kho',
                        selected: _filterType == 'xuat',
                        color: AppColors.exportColor,
                        onTap: () {
                          setState(() => _filterType = 'xuat');
                          _applyFilters();
                        },
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Ghi nợ',
                        selected: _filterDebtOnly,
                        color: AppColors.debtActive,
                        onTap: () {
                          setState(() => _filterDebtOnly = !_filterDebtOnly);
                          _applyFilters();
                        },
                      ),
                      const SizedBox(width: 12),
                      // Warehouse dropdown
                      SizedBox(
                        width: 110,
                        child: DropdownButtonFormField<String>(
                          initialValue: _filterWarehouse,
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            border: OutlineInputBorder(),
                            hintText: 'Kho',
                          ),
                          style: TextStyle(
                              fontSize: 13, color: AppColors.textPrimaryOf(context)),
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('Tất cả', style: TextStyle(fontSize: 13)),
                            ),
                            ...AppConstants.warehouseLocationNames.map(
                              (name) => DropdownMenuItem(
                                value: name,
                                child: Text(name, style: const TextStyle(fontSize: 13)),
                              ),
                            ),
                          ],
                          onChanged: (v) {
                            setState(() => _filterWarehouse = v);
                            _applyFilters();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        Expanded(
          child: BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
              return state.map(
                initial: (_) {
                  context.read<TransactionBloc>().add(
                        const TransactionEvent.loadHistoryPaginated(),
                      );
                  return const AppLoadingIndicator();
                },
                loading: (_) => const AppLoadingIndicator(),
                historyLoaded: (loaded) => _buildTxList(
                  loaded.transactions, false, false,
                ),
                paginatedHistoryLoaded: (loaded) => _buildTxList(
                  loaded.transactions, loaded.hasMore, loaded.isLoadingMore,
                ),
                created: (_) => const AppLoadingIndicator(),
                debtUpdated: (_) {
                  // Refresh list after debt update
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _onTransactionCreated();
                  });
                  return const AppLoadingIndicator();
                },
                updated: (_) {
                  // Refresh list after transaction edit
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _onTransactionCreated();
                  });
                  return const AppLoadingIndicator();
                },
                error: (e) => AppErrorWidget(
                  message: e.message,
                  onRetry: () => context
                      .read<TransactionBloc>()
                      .add(const TransactionEvent.loadHistoryPaginated()),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTxList(
    List<dynamic> transactions, bool hasMore, bool isLoadingMore,
  ) {
    // Apply client-side debt filter
    var filteredTx = transactions;
    if (_filterDebtOnly) {
      filteredTx = transactions.where((tx) => tx.isDebt).toList();
    }

    if (filteredTx.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          context.read<TransactionBloc>().add(TransactionEvent.refreshHistory(
            startDate: _filterDateRange?.start,
            endDate: _filterDateRange?.end,
            type: _filterType,
            warehouseLocation: _filterWarehouse,
          ));
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 120),
            Center(child: Text('Chưa có giao dịch nào')),
          ],
        ),
      );
    }

    // Group transactions by date
    final grouped = _groupByDate(filteredTx);
    final dateKeys = grouped.keys.toList();

    // Build flat list of items: [header, tx, tx, header, tx, ...] + loading indicator
    final items = <_ListItem>[];
    for (final dateKey in dateKeys) {
      final txsForDate = grouped[dateKey]!;
      items.add(_ListItem.header(dateKey, txsForDate.length));
      for (final tx in txsForDate) {
        items.add(_ListItem.transaction(tx));
      }
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<TransactionBloc>().add(TransactionEvent.refreshHistory(
          startDate: _filterDateRange?.start,
          endDate: _filterDateRange?.end,
          type: _filterType,
          warehouseLocation: _filterWarehouse,
        ));
      },
      child: ListView.builder(
        controller: _scrollCtl,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length + (hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= items.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          }

          final item = items[index];
          if (item.isHeader) {
            return _buildDateHeader(item.dateLabel!, item.count!);
          }

          final tx = item.tx!;
          final isExport = tx.type == 'xuat';
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Card(
              margin: EdgeInsets.zero,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  final result = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<TransactionBloc>(),
                        child: TransactionDetailPage(transaction: tx),
                      ),
                    ),
                  );
                  if (result == true && context.mounted) {
                    _onTransactionCreated();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: icon + customer + total
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: isExport
                                ? AppColors.exportColor.withValues(alpha: 0.1)
                                : AppColors.importColor.withValues(alpha: 0.1),
                            child: Icon(
                              isExport ? Icons.arrow_upward : Icons.arrow_downward,
                              size: 16,
                              color: isExport ? AppColors.exportColor : AppColors.importColor,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tx.customerName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  DateFormatter.formatTime(tx.createdAt),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondaryOf(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                CurrencyFormatter.format(tx.totalValue),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: isExport ? AppColors.exportColor : AppColors.importColor,
                                ),
                              ),
                              if (tx.isDebt)
                                Container(
                                  margin: const EdgeInsets.only(top: 2),
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: AppColors.debtActive.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'GHI NỢ',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.debtActive,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      // Items list
                      if (tx.itemsSummary.isNotEmpty) ...[
                        const Divider(height: 16),
                        ...tx.itemsSummary.map((item) {
                          final name = item['name'] ?? '';
                          final qty = item['qty'] ?? 0;
                          final price = (item['price'] ?? 0).toDouble();
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                const SizedBox(width: 4),
                                Icon(Icons.circle, size: 5,
                                  color: isExport ? AppColors.exportColor : AppColors.importColor),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '$name',
                                    style: const TextStyle(fontSize: 13),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '$qty × ${CurrencyFormatter.format(price)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondaryOf(context),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Group transactions by date (yyyy-MM-dd)
  Map<String, List<dynamic>> _groupByDate(List<dynamic> transactions) {
    final Map<String, List<dynamic>> grouped = {};
    for (final tx in transactions) {
      final dateKey = DateFormatter.formatDate(tx.createdAt);
      grouped.putIfAbsent(dateKey, () => []).add(tx);
    }
    return grouped;
  }

  /// Build the date header
  Widget _buildDateHeader(String dateLabel, int count) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today, size: 14, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  dateLabel,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$count giao dịch',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondaryOf(context),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Divider(
              color: AppColors.primary.withValues(alpha: 0.2),
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper class for building grouped list items
class _ListItem {
  final bool isHeader;
  final String? dateLabel;
  final int? count;
  final dynamic tx;

  const _ListItem._({
    required this.isHeader,
    this.dateLabel,
    this.count,
    this.tx,
  });

  factory _ListItem.header(String dateLabel, int count) =>
      _ListItem._(isHeader: true, dateLabel: dateLabel, count: count);

  factory _ListItem.transaction(dynamic tx) =>
      _ListItem._(isHeader: false, tx: tx);
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color? color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppColors.primary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? chipColor.withValues(alpha: 0.15) : Colors.transparent,
          border: Border.all(
            color: selected ? chipColor : AppColors.divider,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            color: selected ? chipColor : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
