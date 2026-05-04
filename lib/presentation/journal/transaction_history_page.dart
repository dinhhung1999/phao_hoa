import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_widget.dart';
import '../../domain/entities/transaction.dart' as entity;
import '../../injection_container.dart';
import 'transaction_bloc.dart';
import 'transaction_detail_page.dart';

/// Shared transaction history page — filters by warehouse or product
class TransactionHistoryPage extends StatelessWidget {
  final String title;
  final String? warehouseLocation; // filter by warehouse name
  final String? productId; // filter by product ID

  const TransactionHistoryPage({
    super.key,
    required this.title,
    this.warehouseLocation,
    this.productId,
  }) : assert(
          warehouseLocation != null || productId != null,
          'Must provide warehouseLocation or productId',
        );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = sl<TransactionBloc>();
        if (productId != null) {
          bloc.add(TransactionEvent.loadByProductId(productId: productId!));
        } else if (warehouseLocation != null) {
          bloc.add(TransactionEvent.loadHistory(
            warehouseLocation: warehouseLocation,
          ));
        }
        return bloc;
      },
      child: _TransactionHistoryView(
        title: title,
        warehouseLocation: warehouseLocation,
        productId: productId,
      ),
    );
  }
}

class _TransactionHistoryView extends StatelessWidget {
  final String title;
  final String? warehouseLocation;
  final String? productId;

  const _TransactionHistoryView({
    required this.title,
    this.warehouseLocation,
    this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          return state.map(
            initial: (_) => const AppLoadingIndicator(),
            loading: (_) => const AppLoadingIndicator(
              message: 'Đang tải lịch sử...',
            ),
            historyLoaded: (loaded) => _buildList(context, loaded.transactions),
            paginatedHistoryLoaded: (loaded) =>
                _buildList(context, loaded.transactions),
            created: (_) => const SizedBox.shrink(),
            debtUpdated: (_) => const SizedBox.shrink(),
            updated: (_) => const SizedBox.shrink(),
            error: (e) => AppErrorWidget(
              message: e.message,
              onRetry: () => _reload(context),
            ),
          );
        },
      ),
    );
  }

  void _reload(BuildContext context) {
    if (productId != null) {
      context
          .read<TransactionBloc>()
          .add(TransactionEvent.loadByProductId(productId: productId!));
    } else if (warehouseLocation != null) {
      context.read<TransactionBloc>().add(TransactionEvent.loadHistory(
            warehouseLocation: warehouseLocation,
          ));
    }
  }

  Widget _buildList(BuildContext context, List<entity.Transaction> transactions) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined,
                size: 64, color: AppColors.textHintOf(context)),
            const SizedBox(height: 12),
            Text(
              'Chưa có giao dịch nào',
              style: TextStyle(color: AppColors.textSecondaryOf(context)),
            ),
            const SizedBox(height: 8),
            Text(
              productId != null
                  ? 'Sản phẩm này chưa có giao dịch'
                  : 'Kho này chưa có giao dịch',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textHintOf(context),
              ),
            ),
          ],
        ),
      );
    }

    // Group transactions by date
    final grouped = <String, List<entity.Transaction>>{};
    for (final tx in transactions) {
      final dateKey = DateFormatter.formatDate(tx.createdAt);
      grouped.putIfAbsent(dateKey, () => []).add(tx);
    }
    final dateKeys = grouped.keys.toList();

    // Build flat list: [header, tx, tx, header, tx, ...]
    final items = <_ListItem>[];
    for (final dateKey in dateKeys) {
      final txsForDate = grouped[dateKey]!;
      items.add(_ListItem.header(dateKey, txsForDate.length));
      for (final tx in txsForDate) {
        items.add(_ListItem.transaction(tx));
      }
    }

    // Summary card
    final totalImport = transactions
        .where((tx) => tx.type == 'nhap')
        .fold<double>(0, (sum, tx) => sum + tx.totalValue);
    final totalExport = transactions
        .where((tx) => tx.type == 'xuat')
        .fold<double>(0, (sum, tx) => sum + tx.totalValue);
    final importCount = transactions.where((tx) => tx.type == 'nhap').length;
    final exportCount = transactions.where((tx) => tx.type == 'xuat').length;

    return Column(
      children: [
        // Summary header
        Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.08),
                AppColors.primary.withValues(alpha: 0.02),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _SummaryItem(
                  icon: Icons.arrow_downward,
                  label: 'Nhập kho',
                  count: '$importCount',
                  value: CurrencyFormatter.format(totalImport),
                  color: AppColors.importColor,
                ),
              ),
              Container(
                width: 1,
                height: 48,
                color: AppColors.divider,
              ),
              Expanded(
                child: _SummaryItem(
                  icon: Icons.arrow_upward,
                  label: 'Xuất kho',
                  count: '$exportCount',
                  value: CurrencyFormatter.format(totalExport),
                  color: AppColors.exportColor,
                ),
              ),
            ],
          ),
        ),

        // Transaction list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              if (item.isHeader) {
                return _buildDateHeader(context, item.dateLabel!, item.count!);
              }

              final tx = item.tx!;
              final isExport = tx.type == 'xuat';
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Card(
                  margin: EdgeInsets.zero,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<TransactionBloc>(),
                            child: TransactionDetailPage(transaction: tx),
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header row
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: isExport
                                    ? AppColors.exportColor
                                        .withValues(alpha: 0.1)
                                    : AppColors.importColor
                                        .withValues(alpha: 0.1),
                                child: Icon(
                                  isExport
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  size: 16,
                                  color: isExport
                                      ? AppColors.exportColor
                                      : AppColors.importColor,
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
                                    Row(
                                      children: [
                                        Text(
                                          DateFormatter.formatTime(tx.createdAt),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondaryOf(
                                                context),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: (isExport
                                                    ? AppColors.exportColor
                                                    : AppColors.importColor)
                                                .withValues(alpha: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            tx.warehouseLocation,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: isExport
                                                  ? AppColors.exportColor
                                                  : AppColors.importColor,
                                            ),
                                          ),
                                        ),
                                      ],
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
                                      color: isExport
                                          ? AppColors.exportColor
                                          : AppColors.importColor,
                                    ),
                                  ),
                                  if (tx.isDebt)
                                    Container(
                                      margin: const EdgeInsets.only(top: 2),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: AppColors.debtActive
                                            .withValues(alpha: 0.1),
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
                                    Icon(Icons.circle,
                                        size: 5,
                                        color: isExport
                                            ? AppColors.exportColor
                                            : AppColors.importColor),
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
                                        color:
                                            AppColors.textSecondaryOf(context),
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
        ),
      ],
    );
  }

  Widget _buildDateHeader(BuildContext context, String dateLabel, int count) {
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
                const Icon(Icons.calendar_today,
                    size: 14, color: AppColors.primary),
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

// ─────────────────────────────────────────────
// Helper widgets
// ─────────────────────────────────────────────

class _ListItem {
  final bool isHeader;
  final String? dateLabel;
  final int? count;
  final entity.Transaction? tx;

  const _ListItem._({
    required this.isHeader,
    this.dateLabel,
    this.count,
    this.tx,
  });

  factory _ListItem.header(String dateLabel, int count) =>
      _ListItem._(isHeader: true, dateLabel: dateLabel, count: count);

  factory _ListItem.transaction(entity.Transaction tx) =>
      _ListItem._(isHeader: false, tx: tx);
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String count;
  final String value;
  final Color color;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.count,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                count,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
