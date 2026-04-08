import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../domain/entities/product.dart';
import 'category_bloc.dart';
import 'price_history_page.dart';
import 'product_form_page.dart';

/// Product detail page — displays full info with edit/delete actions
class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late Product _product;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoryBloc, CategoryState>(
      listener: (context, state) {
        state.mapOrNull(
          actionSuccess: (s) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(s.message),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.of(context).pop(true);
          },
          // When products are reloaded, update our local product
          paginatedLoaded: (loaded) {
            final updated = loaded.products.where((p) => p.id == _product.id);
            if (updated.isNotEmpty) {
              setState(() => _product = updated.first);
            }
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chi tiết sản phẩm'),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Sửa',
              onPressed: () => _navigateToEdit(context),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Xóa',
              onPressed: () => _confirmDelete(context),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Header card
            Card(
              color: AppColors.primary,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _product.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_product.unit.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      _chip(_product.unit),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Info rows
            _infoTile(
              icon: Icons.straighten,
              label: 'Đơn vị',
              value: _product.unit,
            ),
            const Divider(),
            _infoTile(
              icon: Icons.arrow_downward,
              label: 'Giá nhập',
              value: CurrencyFormatter.format(_product.importPrice),
              valueColor: AppColors.importColor,
            ),
            const Divider(),
            _infoTile(
              icon: Icons.arrow_upward,
              label: 'Giá xuất',
              value: CurrencyFormatter.format(_product.exportPrice),
              valueColor: AppColors.exportColor,
            ),
            const Divider(),
            _infoTile(
              icon: Icons.trending_up,
              label: 'Lợi nhuận / đơn vị',
              value: CurrencyFormatter.format(
                _product.exportPrice - _product.importPrice,
              ),
              valueColor: AppColors.success,
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<CategoryBloc>(),
                        child: PriceHistoryPage(product: _product),
                      ),
                    ),
                  );
                  // Refresh product data when returning from price history
                  if (mounted) {
                    context.read<CategoryBloc>().add(
                      const CategoryEvent.refreshProducts(),
                    );
                  }
                },
                icon: const Icon(Icons.show_chart, size: 18),
                label: const Text('Xem lịch sử giá & biểu đồ'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.info,
                  side: const BorderSide(color: AppColors.info),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Divider(),
            _infoTile(
              icon: Icons.circle,
              label: 'Trạng thái',
              value: _product.isActive ? 'Đang kinh doanh' : 'Ngừng kinh doanh',
              valueColor: _product.isActive ? AppColors.success : AppColors.textSecondary,
            ),
            const Divider(),
            _infoTile(
              icon: Icons.calendar_today,
              label: 'Ngày tạo',
              value: DateFormatter.formatDateTime(_product.createdAt),
            ),
            _infoTile(
              icon: Icons.update,
              label: 'Cập nhật lần cuối',
              value: DateFormatter.formatDateTime(_product.updatedAt),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToEdit(BuildContext context) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<CategoryBloc>(),
          child: ProductFormPage(product: _product),
        ),
      ),
    );
    if (result == true && context.mounted) {
      Navigator.of(context).pop(true); // Return to list to refresh
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Xóa sản phẩm',
      message: 'Bạn có chắc muốn xóa "${_product.name}"?',
      confirmText: 'Xóa',
      confirmColor: AppColors.error,
    );
    if (confirmed && context.mounted) {
      context.read<CategoryBloc>().add(CategoryEvent.deleteProduct(_product.id));
    }
  }
}
