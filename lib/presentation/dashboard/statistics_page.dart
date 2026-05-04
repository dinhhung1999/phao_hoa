import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../domain/entities/transaction.dart' as entity;
import '../journal/transaction_bloc.dart';

/// Statistics page with bar/pie charts showing import/export trends
class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  int _selectedDays = 7; // 7, 14, 30

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: _selectedDays - 1));
    context.read<TransactionBloc>().add(TransactionEvent.loadHistory(
          startDate: start,
          endDate: now,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống kê'),
      ),
      body: Column(
        children: [
          // Period selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _PeriodChip(
                  label: '7 ngày',
                  selected: _selectedDays == 7,
                  onTap: () => _selectPeriod(7),
                ),
                const SizedBox(width: 8),
                _PeriodChip(
                  label: '14 ngày',
                  selected: _selectedDays == 14,
                  onTap: () => _selectPeriod(14),
                ),
                const SizedBox(width: 8),
                _PeriodChip(
                  label: '30 ngày',
                  selected: _selectedDays == 30,
                  onTap: () => _selectPeriod(30),
                ),
              ],
            ),
          ),

          Expanded(
            child: BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                return state.map(
                  initial: (_) => const Center(
                      child: CircularProgressIndicator.adaptive()),
                  loading: (_) => const Center(
                      child: CircularProgressIndicator.adaptive()),
                  historyLoaded: (loaded) =>
                      _buildCharts(loaded.transactions),
                  paginatedHistoryLoaded: (loaded) =>
                      _buildCharts(loaded.transactions),
                  created: (_) => const SizedBox(),
                  debtUpdated: (_) {
                    _loadData();
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  },
                  updated: (_) {
                    _loadData();
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  },
                  error: (e) => Center(child: Text(e.message)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _selectPeriod(int days) {
    setState(() => _selectedDays = days);
    _loadData();
  }

  Widget _buildCharts(List<entity.Transaction> transactions) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart_outlined, size: 64,
                color: AppColors.textHintOf(context)),
            SizedBox(height: 12),
            Text('Chưa có giao dịch trong kỳ',
                style: TextStyle(color: AppColors.textSecondaryOf(context))),
          ],
        ),
      );
    }

    final dailyData = _aggregateDaily(transactions);
    final totalImport = transactions
        .where((t) => t.type == 'nhap')
        .fold(0.0, (sum, t) => sum + t.totalValue);
    final totalExport = transactions
        .where((t) => t.type == 'xuat')
        .fold(0.0, (sum, t) => sum + t.totalValue);
    final totalDebt = transactions
        .where((t) => t.isDebt)
        .fold(0.0, (sum, t) => sum + t.unpaidAmount);
    final profit = totalExport - totalImport;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Summary cards
        Row(
          children: [
            _SummaryCard(
              icon: Icons.arrow_downward,
              label: 'Tổng nhập',
              value: CurrencyFormatter.format(totalImport),
              color: AppColors.importColor,
            ),
            const SizedBox(width: 8),
            _SummaryCard(
              icon: Icons.arrow_upward,
              label: 'Tổng xuất',
              value: CurrencyFormatter.format(totalExport),
              color: AppColors.exportColor,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _SummaryCard(
              icon: Icons.trending_up,
              label: 'Lợi nhuận',
              value: CurrencyFormatter.format(profit),
              color: profit >= 0 ? AppColors.success : AppColors.error,
            ),
            const SizedBox(width: 8),
            _SummaryCard(
              icon: Icons.account_balance_wallet,
              label: 'Ghi nợ',
              value: CurrencyFormatter.format(totalDebt),
              color: AppColors.debtActive,
            ),
          ],
        ),
        SizedBox(height: 24),

        // BAR CHART — Daily Import vs Export
        Text('Nhập / Xuất theo ngày',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                )),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: _buildBarChart(dailyData),
        ),
        SizedBox(height: 24),

        // PIE CHART — Import vs Export ratio
        Text('Tỷ lệ Nhập / Xuất',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                )),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: _buildPieChart(totalImport, totalExport),
        ),
        SizedBox(height: 24),

        // TOP PRODUCTS
        Text('Sản phẩm giao dịch nhiều nhất',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                )),
        const SizedBox(height: 12),
        _buildTopProducts(transactions),
      ],
    );
  }

  // Aggregate transactions by day
  Map<String, _DailyAggregate> _aggregateDaily(
      List<entity.Transaction> transactions) {
    final map = <String, _DailyAggregate>{};
    for (final tx in transactions) {
      final key =
          '${tx.createdAt.month}/${tx.createdAt.day}';
      map.putIfAbsent(key, () => _DailyAggregate(key));
      if (tx.type == 'nhap') {
        map[key]!.importValue += tx.totalValue;
      } else {
        map[key]!.exportValue += tx.totalValue;
      }
    }

    // Sort by date
    final sorted = map.values.toList();
    // Keep only last N entries for readable chart
    if (sorted.length > 10) {
      return Map.fromEntries(
          sorted.skip(sorted.length - 10).map((e) => MapEntry(e.label, e)));
    }
    return Map.fromEntries(sorted.map((e) => MapEntry(e.label, e)));
  }

  Widget _buildBarChart(Map<String, _DailyAggregate> data) {
    if (data.isEmpty) {
      return const Center(child: Text('Không có dữ liệu'));
    }

    final entries = data.values.toList();
    final maxY = entries.fold(0.0, (max, e) {
      final m = e.importValue > e.exportValue ? e.importValue : e.exportValue;
      return m > max ? m : max;
    });

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
        child: BarChart(
          BarChartData(
            maxY: maxY * 1.2,
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                tooltipPadding: const EdgeInsets.all(6),
                tooltipMargin: 4,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final label = rodIndex == 0 ? 'Nhập' : 'Xuất';
                  return BarTooltipItem(
                    '$label\n${CurrencyFormatter.format(rod.toY)}',
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final idx = value.toInt();
                    if (idx >= 0 && idx < entries.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          entries[idx].label,
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 50,
                  getTitlesWidget: (value, meta) {
                    if (value == 0) return const SizedBox();
                    return Text(
                      _formatShortCurrency(value),
                      style: const TextStyle(fontSize: 9),
                    );
                  },
                ),
              ),
              topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              drawVerticalLine: false,
              horizontalInterval: maxY > 0 ? maxY / 4 : 1,
            ),
            barGroups: entries.asMap().entries.map((entry) {
              final i = entry.key;
              final d = entry.value;
              return BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: d.importValue,
                    color: AppColors.importColor,
                    width: 10,
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4)),
                  ),
                  BarChartRodData(
                    toY: d.exportValue,
                    color: AppColors.exportColor,
                    width: 10,
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4)),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildPieChart(double totalImport, double totalExport) {
    final total = totalImport + totalExport;
    if (total == 0) return const Center(child: Text('Không có dữ liệu'));

    return Card(
      child: Row(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 40,
                sections: [
                  PieChartSectionData(
                    value: totalImport,
                    title:
                        '${(totalImport / total * 100).toStringAsFixed(0)}%',
                    color: AppColors.importColor,
                    radius: 50,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: totalExport,
                    title:
                        '${(totalExport / total * 100).toStringAsFixed(0)}%',
                    color: AppColors.exportColor,
                    radius: 50,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LegendItem(
                    color: AppColors.importColor, label: 'Nhập kho'),
                const SizedBox(height: 8),
                _LegendItem(
                    color: AppColors.exportColor, label: 'Xuất kho'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopProducts(List<entity.Transaction> transactions) {
    // Aggregate by product using itemsSummary (denormalized data)
    // since tx.items is not loaded during history queries
    final productMap = <String, double>{};
    for (final tx in transactions) {
      for (final item in tx.itemsSummary) {
        final name = (item['name'] ?? '') as String;
        final qty = (item['qty'] ?? 0);
        final price = (item['price'] ?? 0).toDouble();
        final subtotal = qty * price;
        if (name.isNotEmpty) {
          productMap.update(
            name,
            (v) => v + subtotal,
            ifAbsent: () => subtotal,
          );
        }
      }
    }

    final sorted = productMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top5 = sorted.take(5).toList();

    if (top5.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Chưa có dữ liệu chi tiết sản phẩm'),
        ),
      );
    }

    return Card(
      child: Column(
        children: top5.asMap().entries.map((entry) {
          final i = entry.key;
          final e = entry.value;
          return ListTile(
            leading: CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Text('${i + 1}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  )),
            ),
            title: Text(e.key, style: const TextStyle(fontSize: 14)),
            trailing: Text(
              CurrencyFormatter.format(e.value),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _formatShortCurrency(double value) {
    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)}B';
    } else if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toStringAsFixed(0);
  }
}

class _DailyAggregate {
  final String label;
  double importValue = 0;
  double exportValue = 0;

  _DailyAggregate(this.label);
}

class _PeriodChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PeriodChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primary.withValues(alpha: 0.15),
      checkmarkColor: AppColors.primary,
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 16, color: color),
                  const SizedBox(width: 6),
                  Text(label,
                      style: TextStyle(
                        fontSize: 12,
                        color: color,
                      )),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}