import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../domain/entities/product.dart';
import 'category_bloc.dart';
import 'product_form_page.dart';

/// Product detail page — displays full info with edit/delete actions
class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

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
                      product.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (product.unit.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      _chip(product.unit),
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
              value: product.unit,
            ),
            const Divider(),
            _infoTile(
              icon: Icons.arrow_downward,
              label: 'Giá nhập',
              value: CurrencyFormatter.format(product.importPrice),
              valueColor: AppColors.importColor,
            ),
            const Divider(),
            _infoTile(
              icon: Icons.arrow_upward,
              label: 'Giá xuất',
              value: CurrencyFormatter.format(product.exportPrice),
              valueColor: AppColors.exportColor,
            ),
            const Divider(),
            _infoTile(
              icon: Icons.trending_up,
              label: 'Lợi nhuận / đơn vị',
              value: CurrencyFormatter.format(
                product.exportPrice - product.importPrice,
              ),
              valueColor: AppColors.success,
            ),
            const Divider(),
            _infoTile(
              icon: Icons.circle,
              label: 'Trạng thái',
              value: product.isActive ? 'Đang kinh doanh' : 'Ngừng kinh doanh',
              valueColor: product.isActive ? AppColors.success : AppColors.textSecondary,
            ),
            const Divider(),
            _infoTile(
              icon: Icons.calendar_today,
              label: 'Ngày tạo',
              value: DateFormatter.formatDateTime(product.createdAt),
            ),
            _infoTile(
              icon: Icons.update,
              label: 'Cập nhật lần cuối',
              value: DateFormatter.formatDateTime(product.updatedAt),
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
          child: ProductFormPage(product: product),
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
      message: 'Bạn có chắc muốn xóa "${product.name}"?',
      confirmText: 'Xóa',
      confirmColor: AppColors.error,
    );
    if (confirmed && context.mounted) {
      context.read<CategoryBloc>().add(CategoryEvent.deleteProduct(product.id));
    }
  }
}
