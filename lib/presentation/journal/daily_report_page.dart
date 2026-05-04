import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_widget.dart';
import '../../domain/entities/transaction.dart' as entity;
import 'transaction_bloc.dart';

/// Daily import/export report page
class DailyReportPage extends StatefulWidget {
  const DailyReportPage({super.key});

  @override
  State<DailyReportPage> createState() => _DailyReportPageState();
}

class _DailyReportPageState extends State<DailyReportPage> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _loadReport();
  }

  void _loadReport() {
    final start = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    final end = start.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));
    context.read<TransactionBloc>().add(TransactionEvent.loadHistory(
          startDate: start,
          endDate: end,
        ));
  }

  void _changeDate(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
    });
    _loadReport();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      locale: const Locale('vi', 'VN'),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
      _loadReport();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isToday = DateUtils.isSameDay(_selectedDate, DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Báo cáo hàng ngày'),
      ),
      body: Column(
        children: [
          // Date selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: const Border(
                bottom: BorderSide(color: AppColors.divider, width: 0.5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => _changeDate(-1),
                  tooltip: 'Ngày trước',
                ),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: Column(
                      children: [
                        Text(
                          isToday
                              ? 'Hôm nay'
                              : DateFormatter.formatDate(_selectedDate),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isToday)
                          Text(
                            DateFormatter.formatDate(_selectedDate),
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondaryOf(context),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: isToday ? null : () => _changeDate(1),
                  tooltip: 'Ngày sau',
                ),
              ],
            ),
          ),

          // Report content
          Expanded(
            child: BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                return state.map(
                  initial: (_) {
                    _loadReport();
                    return const AppLoadingIndicator();
                  },
                  loading: (_) => const AppLoadingIndicator(
                      message: 'Đang tải báo cáo...'),
                  historyLoaded: (loaded) =>
                      _buildReport(loaded.transactions),
                  paginatedHistoryLoaded: (loaded) =>
                      _buildReport(loaded.transactions),
                  created: (_) => const AppLoadingIndicator(),
                  debtUpdated: (_) {
                    _loadReport();
                    return const AppLoadingIndicator();
                  },
                  updated: (_) {
                    _loadReport();
                    return const AppLoadingIndicator();
                  },
                  error: (e) => AppErrorWidget(
                    message: e.message,
                    onRetry: _loadReport,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReport(List<entity.Transaction> transactions) {
    // Separate imports and exports
    final imports =
        transactions.where((t) => t.type == 'nhap').toList();
    final exports =
        transactions.where((t) => t.type == 'xuat').toList();

    final totalImport =
        imports.fold<double>(0, (sum, t) => sum + t.totalValue);
    final totalExport =
        exports.fold<double>(0, (sum, t) => sum + t.totalValue);
    final totalImportQty =
        imports.fold<int>(0, (sum, t) => sum + t.totalQuantity);
    final totalExportQty =
        exports.fold<int>(0, (sum, t) => sum + t.totalQuantity);
    final totalDebt = transactions
        .where((t) => t.isDebt)
        .fold<double>(0, (sum, t) => sum + t.unpaidAmount);

    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined,
                size: 64, color: AppColors.textHintOf(context)),
            SizedBox(height: 12),
            Text(
              'Không có giao dịch ngày ${DateFormatter.formatDate(_selectedDate)}',
              style: TextStyle(color: AppColors.textSecondaryOf(context)),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Summary cards
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                title: 'Tổng nhập',
                value: totalImport,
                count: imports.length,
                totalQuantity: totalImportQty,
                color: AppColors.importColor,
                icon: Icons.arrow_downward,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                title: 'Tổng xuất',
                value: totalExport,
                count: exports.length,
                totalQuantity: totalExportQty,
                color: AppColors.exportColor,
                icon: Icons.arrow_upward,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Profit / Debt summary
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Chênh lệch',
                          style: TextStyle(
                              color: AppColors.textSecondaryOf(context), fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(
                        CurrencyFormatter.format(totalExport - totalImport),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: totalExport >= totalImport
                              ? AppColors.success
                              : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: AppColors.divider,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ghi nợ',
                            style: TextStyle(
                                color: AppColors.textSecondaryOf(context), fontSize: 13)),
                        const SizedBox(height: 4),
                        Text(
                          CurrencyFormatter.format(totalDebt),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: totalDebt > 0
                                ? AppColors.debtActive
                                : AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Import section
        if (imports.isNotEmpty) ...[
          _sectionTitle('Nhập kho (${imports.length})', AppColors.importColor),
          const SizedBox(height: 8),
          ...imports.map((tx) => _TransactionTile(transaction: tx)),
          const SizedBox(height: 16),
        ],

        // Export section
        if (exports.isNotEmpty) ...[
          _sectionTitle('Xuất kho (${exports.length})', AppColors.exportColor),
          const SizedBox(height: 8),
          ...exports.map((tx) => _TransactionTile(transaction: tx)),
        ],
      ],
    );
  }

  Widget _sectionTitle(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final double value;
  final int count;
  final int totalQuantity;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.count,
    required this.totalQuantity,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              CurrencyFormatter.format(value),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '$count phiếu${totalQuantity > 0 ? ' • $totalQuantity SP' : ''}',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondaryOf(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final entity.Transaction transaction;

  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isExport = transaction.type == 'xuat';
    final color = isExport ? AppColors.exportColor : AppColors.importColor;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        dense: true,
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(
            isExport ? Icons.arrow_upward : Icons.arrow_downward,
            size: 18,
            color: color,
          ),
        ),
        title: Text(
          transaction.customerName,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        subtitle: Text(
          '${transaction.warehouseLocation} • ${DateFormatter.formatTime(transaction.createdAt)}${transaction.totalQuantity > 0 ? ' • ${transaction.totalQuantity} SP' : ''}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              CurrencyFormatter.format(transaction.totalValue),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: color,
              ),
            ),
            if (transaction.isDebt)
              Text(
                'GHI NỢ',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.debtActive,
                ),
              ),
          ],
        ),
      ),
    );
  }
}