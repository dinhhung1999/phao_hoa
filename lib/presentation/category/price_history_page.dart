import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../domain/entities/price_record.dart';
import '../../domain/entities/product.dart';
import 'category_bloc.dart';

/// Page displaying price history chart and records for a product
class PriceHistoryPage extends StatefulWidget {
  final Product product;

  const PriceHistoryPage({super.key, required this.product});

  @override
  State<PriceHistoryPage> createState() => _PriceHistoryPageState();
}

class _PriceHistoryPageState extends State<PriceHistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(
      CategoryEvent.loadPriceHistory(widget.product.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử giá — ${widget.product.name}'),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_update_price',
        onPressed: () => _showUpdatePriceDialog(context),
        child: const Icon(Icons.edit),
      ),
      body: BlocConsumer<CategoryBloc, CategoryState>(
        listener: (context, state) {
          state.mapOrNull(
            actionSuccess: (s) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(s.message),
                  backgroundColor: AppColors.success,
                ),
              );
              // Reload price history
              context.read<CategoryBloc>().add(
                CategoryEvent.loadPriceHistory(widget.product.id),
              );
            },
          );
        },
        builder: (context, state) {
          return state.maybeMap(
            loading: (_) => const AppLoadingIndicator(),
            priceHistoryLoaded: (loaded) =>
                _buildContent(loaded.records, loaded.product),
            error: (e) => Center(child: Text(e.message)),
            orElse: () => const AppLoadingIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildContent(List<PriceRecord> records, Product product) {
    if (records.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.show_chart, size: 64, color: AppColors.textHint),
            const SizedBox(height: 12),
            const Text(
              'Chưa có dữ liệu lịch sử giá',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            const Text(
              'Cập nhật giá để bắt đầu theo dõi',
              style: TextStyle(color: AppColors.textHint, fontSize: 13),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _showUpdatePriceDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Cập nhật giá'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Current price summary card
        _buildCurrentPriceCard(product),
        const SizedBox(height: 16),

        // Hint when only 1 record
        if (records.length == 1)
          Card(
            color: AppColors.info.withValues(alpha: 0.08),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 18, color: AppColors.info),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Cập nhật giá bằng nút ✏️ để bắt đầu theo dõi biến động giá trên biểu đồ.',
                      style: TextStyle(fontSize: 13, color: AppColors.info),
                    ),
                  ),
                ],
              ),
            ),
          ),

        if (records.length == 1) const SizedBox(height: 16),

        // Price chart (show with any records)
        if (records.isNotEmpty) ...[
          _buildChartSection(records),
          const SizedBox(height: 16),
        ],

        // Profit/loss summary (needs at least 2 to compare)
        if (records.length >= 2) ...[
          _buildProfitSummary(records),
          const SizedBox(height: 16),
        ],

        // Price history list
        _buildHistoryList(records),
      ],
    );
  }

  Widget _buildCurrentPriceCard(Product product) {
    final profit = product.exportPrice - product.importPrice;
    final margin = product.importPrice > 0
        ? (profit / product.importPrice) * 100
        : 0.0;

    return Card(
      color: AppColors.primary,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Giá hiện tại',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Giá nhập',
                          style: TextStyle(color: Colors.white60, fontSize: 11)),
                      Text(
                        CurrencyFormatter.format(product.importPrice),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Giá xuất',
                          style: TextStyle(color: Colors.white60, fontSize: 11)),
                      Text(
                        CurrencyFormatter.format(product.exportPrice),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Lãi/đơn vị',
                        style: TextStyle(color: Colors.white60, fontSize: 11)),
                    Text(
                      CurrencyFormatter.format(profit),
                      style: TextStyle(
                        color: profit >= 0
                            ? const Color(0xFF81C784)
                            : const Color(0xFFEF9A9A),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${margin.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: profit >= 0
                            ? const Color(0xFF81C784)
                            : const Color(0xFFEF9A9A),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection(List<PriceRecord> records) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Biểu đồ giá',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _legendItem('Giá nhập', AppColors.importColor),
                const SizedBox(width: 16),
                _legendItem('Giá xuất', AppColors.exportColor),
                const SizedBox(width: 16),
                _legendItem('Lợi nhuận', AppColors.info),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: _buildLineChart(records),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildLineChart(List<PriceRecord> records) {
    final importSpots = <FlSpot>[];
    final exportSpots = <FlSpot>[];
    final profitSpots = <FlSpot>[];

    for (int i = 0; i < records.length; i++) {
      importSpots.add(FlSpot(i.toDouble(), records[i].importPrice));
      exportSpots.add(FlSpot(i.toDouble(), records[i].exportPrice));
      profitSpots.add(FlSpot(i.toDouble(), records[i].profitPerUnit));
    }

    // Find min/max for Y axis
    double minY = double.infinity;
    double maxY = double.negativeInfinity;
    for (final r in records) {
      final values = [r.importPrice, r.exportPrice, r.profitPerUnit];
      for (final v in values) {
        if (v < minY) minY = v;
        if (v > maxY) maxY = v;
      }
    }
    // Handle single record or equal values
    if (minY == maxY) {
      minY = (minY * 0.8).clamp(0, double.infinity);
      maxY = maxY * 1.2;
      if (maxY == 0) maxY = 100;
    }
    final padding = (maxY - minY) * 0.1;
    minY = (minY - padding).clamp(0, double.infinity);
    maxY = maxY + padding;

    final yRange = maxY - minY;
    final horizontalInterval = yRange > 0 ? yRange / 4 : 1.0;

    final dateFormat = DateFormat('dd/MM');

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: horizontalInterval,
          getDrawingHorizontalLine: (value) => FlLine(
            color: AppColors.divider.withValues(alpha: 0.5),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: records.length > 6 ? (records.length / 5).ceilToDouble() : 1,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= records.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    dateFormat.format(records[i].recordedAt),
                    style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (value, meta) {
                return Text(
                  _formatShortPrice(value),
                  style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (records.length - 1).toDouble(),
        minY: minY,
        maxY: maxY,
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                String label;
                switch (spot.barIndex) {
                  case 0:
                    label = 'Nhập: ';
                  case 1:
                    label = 'Xuất: ';
                  default:
                    label = 'Lãi: ';
                }
                return LineTooltipItem(
                  '$label${CurrencyFormatter.format(spot.y)}',
                  TextStyle(
                    color: spot.bar.color ?? Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: importSpots,
            isCurved: true,
            color: AppColors.importColor,
            barWidth: 2.5,
            dotData: FlDotData(show: records.length <= 20),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.importColor.withValues(alpha: 0.05),
            ),
          ),
          LineChartBarData(
            spots: exportSpots,
            isCurved: true,
            color: AppColors.exportColor,
            barWidth: 2.5,
            dotData: FlDotData(show: records.length <= 20),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.exportColor.withValues(alpha: 0.05),
            ),
          ),
          LineChartBarData(
            spots: profitSpots,
            isCurved: true,
            color: AppColors.info,
            barWidth: 2,
            dashArray: [5, 3],
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  String _formatShortPrice(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toStringAsFixed(0);
  }

  Widget _buildProfitSummary(List<PriceRecord> records) {
    final first = records.first;
    final last = records.last;

    final importChange = last.importPrice - first.importPrice;
    final exportChange = last.exportPrice - first.exportPrice;
    final profitChange = last.profitPerUnit - first.profitPerUnit;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thay đổi so với lần đầu',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 12),
            _changeRow('Giá nhập', importChange, first.importPrice),
            const Divider(height: 16),
            _changeRow('Giá xuất', exportChange, first.exportPrice),
            const Divider(height: 16),
            _changeRow('Lợi nhuận', profitChange, first.profitPerUnit),
          ],
        ),
      ),
    );
  }

  Widget _changeRow(String label, double change, double base) {
    final pct = base > 0 ? (change / base) * 100 : 0.0;
    final isPositive = change >= 0;
    final color = isPositive ? AppColors.success : AppColors.error;
    final icon = isPositive ? Icons.trending_up : Icons.trending_down;

    return Row(
      children: [
        Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          '${isPositive ? '+' : ''}${CurrencyFormatter.format(change)}',
          style: TextStyle(color: color, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '${isPositive ? '+' : ''}${pct.toStringAsFixed(1)}%',
            style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryList(List<PriceRecord> records) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final reversed = records.reversed.toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chi tiết lịch sử (${records.length} lần)',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ...List.generate(reversed.length, (i) {
              final record = reversed[i];
              final prevRecord = i < reversed.length - 1 ? reversed[i + 1] : null;

              return Column(
                children: [
                  if (i > 0) const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dateFormat.format(record.recordedAt),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              if (record.updatedBy != null)
                                Text(
                                  record.updatedBy!,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textHint,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // Prices
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'N: ${CurrencyFormatter.format(record.importPrice)}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'X: ${CurrencyFormatter.format(record.exportPrice)}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Lãi: ${CurrencyFormatter.format(record.profitPerUnit)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: record.profitPerUnit >= 0
                                          ? AppColors.success
                                          : AppColors.error,
                                    ),
                                  ),
                                  if (prevRecord != null) ...[
                                    const SizedBox(width: 6),
                                    _buildChangeChip(record, prevRecord),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildChangeChip(PriceRecord current, PriceRecord previous) {
    final change = current.profitPerUnit - previous.profitPerUnit;
    if (change == 0) return const SizedBox.shrink();

    final isPositive = change > 0;
    final color = isPositive ? AppColors.success : AppColors.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.arrow_upward : Icons.arrow_downward,
            size: 10,
            color: color,
          ),
          Text(
            CurrencyFormatter.format(change.abs()),
            style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _showUpdatePriceDialog(BuildContext context) {
    final importCtl = TextEditingController(
      text: widget.product.importPrice.toInt().toString(),
    );
    final exportCtl = TextEditingController(
      text: widget.product.exportPrice.toInt().toString(),
    );
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cập nhật giá hiện tại'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: importCtl,
                decoration: const InputDecoration(
                  labelText: 'Giá nhập mới (₫)',
                  prefixIcon: Icon(Icons.arrow_downward),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final parsed = double.tryParse(
                    (v ?? '').replaceAll(RegExp(r'[^\d]'), ''),
                  );
                  if (parsed == null || parsed <= 0) return 'Giá > 0';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: exportCtl,
                decoration: const InputDecoration(
                  labelText: 'Giá xuất mới (₫)',
                  prefixIcon: Icon(Icons.arrow_upward),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final parsed = double.tryParse(
                    (v ?? '').replaceAll(RegExp(r'[^\d]'), ''),
                  );
                  if (parsed == null || parsed <= 0) return 'Giá > 0';
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              final newImport = double.parse(
                importCtl.text.replaceAll(RegExp(r'[^\d]'), ''),
              );
              final newExport = double.parse(
                exportCtl.text.replaceAll(RegExp(r'[^\d]'), ''),
              );
              context.read<CategoryBloc>().add(
                CategoryEvent.updatePrice(
                  productId: widget.product.id,
                  newImportPrice: newImport,
                  newExportPrice: newExport,
                ),
              );
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cập nhật'),
          ),
        ],
      ),
    );
  }
}
