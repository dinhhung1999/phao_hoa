import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_widget.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../domain/entities/warehouse.dart';
import 'warehouse_bloc.dart';
import 'warehouse_form_page.dart';

/// Warehouse management list page
class WarehouseListPage extends StatefulWidget {
  const WarehouseListPage({super.key});

  @override
  State<WarehouseListPage> createState() => _WarehouseListPageState();
}

class _WarehouseListPageState extends State<WarehouseListPage> {
  @override
  void initState() {
    super.initState();
    context.read<WarehouseBloc>().add(const WarehouseEvent.loadWarehouses());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý Kho hàng')),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_warehouse',
        onPressed: () => _navigateToForm(context),
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<WarehouseBloc, WarehouseState>(
        listener: (context, state) {
          state.mapOrNull(
            actionSuccess: (s) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(s.message),
                backgroundColor: AppColors.success,
              ),
            ),
          );
        },
        builder: (context, state) {
          return state.map(
            initial: (_) => const AppLoadingIndicator(),
            loading: (_) => const AppLoadingIndicator(),
            loaded: (loaded) => _buildList(loaded.warehouses),
            actionSuccess: (_) => const AppLoadingIndicator(),
            error: (e) => AppErrorWidget(
              message: e.message,
              onRetry: () => context
                  .read<WarehouseBloc>()
                  .add(const WarehouseEvent.loadWarehouses()),
            ),
          );
        },
      ),
    );
  }

  Widget _buildList(List<Warehouse> warehouses) {
    if (warehouses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warehouse_outlined,
                size: 64, color: AppColors.textHint),
            const SizedBox(height: 12),
            const Text('Chưa có kho hàng',
                style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => _navigateToForm(context),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Thêm kho hàng'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context
            .read<WarehouseBloc>()
            .add(const WarehouseEvent.loadWarehouses());
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: warehouses.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) => _WarehouseCard(
          warehouse: warehouses[index],
          onEdit: () => _navigateToForm(context, warehouse: warehouses[index]),
          onDelete: () => _confirmDelete(context, warehouses[index]),
        ),
      ),
    );
  }

  void _navigateToForm(BuildContext context, {Warehouse? warehouse}) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<WarehouseBloc>(),
          child: WarehouseFormPage(warehouse: warehouse),
        ),
      ),
    );
    if (result == true && context.mounted) {
      context.read<WarehouseBloc>().add(const WarehouseEvent.loadWarehouses());
    }
  }

  void _confirmDelete(BuildContext context, Warehouse warehouse) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Xóa kho hàng',
      message: 'Bạn có chắc muốn xóa "${warehouse.name}"?\n'
          'Kho sẽ bị ẩn khỏi danh sách nhưng dữ liệu giao dịch cũ vẫn được giữ.',
      confirmText: 'Xóa',
      confirmColor: AppColors.error,
    );
    if (confirmed && context.mounted) {
      context
          .read<WarehouseBloc>()
          .add(WarehouseEvent.deleteWarehouse(warehouse.id));
    }
  }
}

class _WarehouseCard extends StatelessWidget {
  final Warehouse warehouse;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _WarehouseCard({
    required this.warehouse,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: const Icon(Icons.warehouse, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          warehouse.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        if (warehouse.address != null &&
                            warehouse.address!.isNotEmpty)
                          Text(
                            warehouse.address!,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (v) {
                      if (v == 'edit') onEdit();
                      if (v == 'delete') onDelete();
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 18),
                            SizedBox(width: 8),
                            Text('Sửa'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline,
                                size: 18, color: AppColors.error),
                            SizedBox(width: 8),
                            Text('Xóa',
                                style: TextStyle(color: AppColors.error)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Info chips row
              if (_hasDetails) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    if (warehouse.area != null)
                      _InfoChip(
                        icon: Icons.square_foot,
                        label: '${warehouse.area!.toStringAsFixed(0)} m²',
                      ),
                    if (warehouse.capacity != null)
                      _InfoChip(
                        icon: Icons.inventory_2_outlined,
                        label: '${warehouse.capacity} kiện',
                      ),
                  ],
                ),
              ],
              if (warehouse.notes != null && warehouse.notes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  warehouse.notes!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textHint,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  bool get _hasDetails => warehouse.area != null || warehouse.capacity != null;
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.info),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(fontSize: 12, color: AppColors.info)),
        ],
      ),
    );
  }
}
