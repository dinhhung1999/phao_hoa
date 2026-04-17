import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/warehouse_stock.dart';
import '../journal/transaction_history_page.dart';

/// Bottom sheet showing detailed stock breakdown for a specific product.
class InventoryDetailSheet extends StatelessWidget {
  final WarehouseStock stock;

  const InventoryDetailSheet({super.key, required this.stock});

  static List<String> get _locationKeys => AppConstants.warehouseLocationKeys;

  /// Dynamic color palette that scales to any number of warehouses
  static const _colorPalette = [
    Color(0xFF2196F3), // Blue
    Color(0xFF9C27B0), // Purple
    Color(0xFFFF9800), // Orange
    Color(0xFF4CAF50), // Green
    Color(0xFFE91E63), // Pink
    Color(0xFF00BCD4), // Cyan
    Color(0xFF795548), // Brown
    Color(0xFF607D8B), // Blue Grey
  ];

  /// Dynamic icon palette that scales to any number of warehouses
  static const _iconPalette = [
    Icons.warehouse,
    Icons.warehouse_outlined,
    Icons.store,
    Icons.storefront,
    Icons.local_shipping,
    Icons.inventory,
    Icons.home_work,
    Icons.business,
  ];

  Color _colorAt(int i) => _colorPalette[i % _colorPalette.length];
  IconData _iconAt(int i) => _iconPalette[i % _iconPalette.length];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      maxChildSize: 0.8,
      minChildSize: 0.35,
      expand: false,
      builder: (context, scrollController) {
        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            // Drag handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 16),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Product header
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.15),
                        AppColors.primary.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.inventory_2,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stock.productName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Tổng tồn kho: ${stock.totalQuantity}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(),
              ],
            ),
            const SizedBox(height: 24),

            // Section: Phân bổ theo kho
            const Text(
              'Phân bổ theo kho',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: AppColors.info,
              ),
            ),
            const SizedBox(height: 12),

            // Warehouse cards with visual bars
            ...List.generate(_locationKeys.length, (i) {
              final key = _locationKeys[i];
              final qty = stock.getStockAt(key);
              final total = stock.totalQuantity;
              final isNegative = qty < 0;

              String percentage;
              double ratio;
              if (total > 0) {
                percentage = (qty / total * 100).toStringAsFixed(0);
                ratio = (qty.abs() / total).clamp(0.0, 1.0);
              } else {
                percentage = '0';
                ratio = 0.0;
              }

              final color = _colorAt(i);
              final barColor = isNegative ? AppColors.error : color;

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isNegative
                        ? AppColors.error.withValues(alpha: 0.3)
                        : color.withValues(alpha: 0.15),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          _iconAt(i),
                          size: 20,
                          color: color,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            AppConstants.warehouseLocationNames[i],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: color,
                            ),
                          ),
                        ),
                        Text(
                          '$qty',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isNegative ? AppColors.error : color,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '($percentage%)',
                          style: TextStyle(
                            fontSize: 12,
                            color: color.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: ratio,
                        minHeight: 6,
                        backgroundColor:
                            color.withValues(alpha: 0.12),
                        valueColor: AlwaysStoppedAnimation<Color>(barColor),
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 20),

            // Visual quick overview
            const Text(
              'Tổng quan nhanh',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: AppColors.info,
              ),
            ),
            const SizedBox(height: 12),
            _buildQuickOverview(context),

            const SizedBox(height: 20),

            // Transaction history button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop(); // Close bottom sheet
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TransactionHistoryPage(
                        title: 'Lịch sử: ${stock.productName}',
                        productId: stock.productId,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.history, size: 18),
                label: const Text('Xem lịch sử giao dịch'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  Widget _buildStatusBadge() {
    final total = stock.totalQuantity;
    Color color;
    String label;
    IconData icon;

    if (total < 0) {
      color = AppColors.error;
      label = 'Âm kho';
      icon = Icons.trending_down;
    } else if (total == 0) {
      color = AppColors.error;
      label = 'Hết hàng';
      icon = Icons.error_outline;
    } else if (total < 5) {
      color = AppColors.error;
      label = 'Sắp hết';
      icon = Icons.warning_amber;
    } else if (total < 20) {
      color = AppColors.warning;
      label = 'Thấp';
      icon = Icons.info_outline;
    } else {
      color = AppColors.success;
      label = 'Đủ hàng';
      icon = Icons.check_circle_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickOverview(BuildContext context) {
    final total = stock.totalQuantity;
    if (total == 0) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.remove_shopping_cart,
                color: AppColors.error, size: 24),
            SizedBox(width: 10),
            Text(
              'Sản phẩm hiện đã hết hàng',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    // Use Wrap for dynamic number of warehouses to avoid overflow
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 12,
        alignment: WrapAlignment.spaceEvenly,
        children: List.generate(_locationKeys.length, (i) {
          final key = _locationKeys[i];
          final qty = stock.getStockAt(key);
          final isNegative = qty < 0;
          final percentage =
              total != 0 ? (qty / total * 100).toStringAsFixed(0) : '0';
          final color = _colorAt(i);

          return SizedBox(
            width: 72,
            child: Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isNegative
                        ? AppColors.error.withValues(alpha: 0.15)
                        : color.withValues(alpha: 0.15),
                  ),
                  child: Center(
                    child: Text(
                      '$qty',
                      style: TextStyle(
                        fontSize: qty.abs() > 999 ? 12 : 16,
                        fontWeight: FontWeight.bold,
                        color: isNegative ? AppColors.error : color,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  AppConstants.warehouseLocationNames[i],
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  '$percentage%',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isNegative ? AppColors.error : color,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
