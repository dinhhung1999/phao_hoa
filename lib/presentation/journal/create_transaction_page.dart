import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/validators.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/transaction.dart' as entity;
import '../../domain/entities/transaction_item.dart';
import '../auth/auth_bloc.dart';
import '../category/category_bloc.dart';
import 'transaction_bloc.dart';

/// Create import/export transaction page
/// Kho dùng để quản lý hàng tồn — nhập/xuất là nội bộ, không gắn với khách hàng.
class CreateTransactionPage extends StatefulWidget {
  /// 'nhap' for import, 'xuat' for export
  final String type;

  const CreateTransactionPage({super.key, required this.type});

  bool get isExport => type == 'xuat';

  @override
  State<CreateTransactionPage> createState() => _CreateTransactionPageState();
}

class _CreateTransactionPageState extends State<CreateTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _sourceCtl = TextEditingController();
  final _noteCtl = TextEditingController();

  String _warehouseLocation = AppConstants.warehouseLocationNames.first;

  final List<_ItemEntry> _items = [];

  @override
  void initState() {
    super.initState();
    // Load products for the picker
    context.read<CategoryBloc>().add(const CategoryEvent.loadProducts());
  }

  @override
  void dispose() {
    _sourceCtl.dispose();
    _noteCtl.dispose();
    for (final item in _items) {
      item.quantityCtl.dispose();
    }
    super.dispose();
  }

  double get _totalValue {
    return _items.fold(0.0, (sum, item) {
      final qty = int.tryParse(item.quantityCtl.text) ?? 0;
      final price =
          widget.isExport ? item.product.exportPrice : item.product.importPrice;
      return sum + (qty * price);
    });
  }

  void _addItem(Product product) {
    // Check if product already added
    if (_items.any((e) => e.product.id == product.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sản phẩm đã được thêm')),
      );
      return;
    }
    setState(() {
      _items.add(_ItemEntry(
          product: product,
          quantityCtl: TextEditingController(text: '1')));
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items[index].quantityCtl.dispose();
      _items.removeAt(index);
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng thêm ít nhất một sản phẩm')),
      );
      return;
    }

    final now = DateTime.now();
    final items = _items.map((e) {
      final qty = int.tryParse(e.quantityCtl.text) ?? 0;
      final price =
          widget.isExport ? e.product.exportPrice : e.product.importPrice;
      return TransactionItem(
        id: '',
        productId: e.product.id,
        productName: e.product.name,
        category: e.product.category,
        regulationClass: e.product.regulationClass,
        quantity: qty,
        unitPriceAtTime: price,
        subtotal: qty * price,
      );
    }).toList();

    final sourceText = _sourceCtl.text.trim();
    // Get current user email for createdBy
    String userEmail = '';
    final authState = context.read<AuthBloc>().state;
    authState.mapOrNull(
      authenticated: (auth) => userEmail = auth.user.email,
    );

    final transaction = entity.Transaction(
      id: '',
      type: widget.type,
      // Dùng trường customer để lưu nguồn/đối tác (nếu có)
      customerName: sourceText.isNotEmpty
          ? sourceText
          : (widget.isExport ? 'Xuất kho' : 'Nhập kho'),
      customerType: 'noi_bo', // Nội bộ — không phải khách hàng
      warehouseLocation: _warehouseLocation,
      isDebt: false,
      totalValue: _totalValue,
      paidAmount: _totalValue,
      note: _noteCtl.text.trim().isNotEmpty ? _noteCtl.text.trim() : null,
      createdAt: now,
      createdBy: userEmail,
      items: items,
    );

    final bloc = context.read<TransactionBloc>();
    if (widget.isExport) {
      bloc.add(TransactionEvent.createExport(
          transaction: transaction, items: items));
    } else {
      bloc.add(TransactionEvent.createImport(
          transaction: transaction, items: items));
    }
  }

  @override
  Widget build(BuildContext context) {
    final color =
        widget.isExport ? AppColors.exportColor : AppColors.importColor;

    return BlocListener<TransactionBloc, TransactionState>(
      listener: (context, state) {
        state.mapOrNull(
          created: (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(widget.isExport
                    ? 'Đã tạo phiếu xuất kho'
                    : 'Đã tạo phiếu nhập kho'),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.of(context).pop(true);
          },
          error: (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.message),
                backgroundColor: AppColors.error,
              ),
            );
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title:
              Text(widget.isExport ? 'Tạo phiếu xuất kho' : 'Tạo phiếu nhập kho'),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // ── Type indicator ──
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Icon(
                      widget.isExport
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      color: color,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      widget.isExport
                          ? 'Phiếu xuất — Hàng ra khỏi kho'
                          : 'Phiếu nhập — Hàng vào kho',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Warehouse selector ──
              DropdownButtonFormField<String>(
                initialValue: _warehouseLocation,
                decoration: const InputDecoration(
                  labelText: 'Chọn kho *',
                  prefixIcon: Icon(Icons.warehouse_outlined),
                ),
                items: AppConstants.warehouseLocationNames.map((name) {
                  return DropdownMenuItem(value: name, child: Text(name));
                }).toList(),
                onChanged: (v) => setState(
                    () => _warehouseLocation = v ?? _warehouseLocation),
              ),
              const SizedBox(height: 16),

              // ── Source / Destination (optional) ──
              TextFormField(
                controller: _sourceCtl,
                decoration: InputDecoration(
                  labelText: widget.isExport
                      ? 'Nơi nhận / Lý do xuất'
                      : 'Nguồn nhập / Nhà cung cấp',
                  prefixIcon: Icon(
                    widget.isExport
                        ? Icons.local_shipping_outlined
                        : Icons.business_outlined,
                  ),
                  hintText: widget.isExport
                      ? 'VD: Chuyển kho, Trưng bày, ...'
                      : 'VD: Nhà cung cấp A, Nhập bổ sung, ...',
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 8),

              const Divider(),
              const SizedBox(height: 8),

              // ── Products section ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sản phẩm',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  TextButton.icon(
                    onPressed: () => _showProductPicker(context),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Thêm'),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              if (_items.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.inventory_2_outlined,
                              size: 40, color: AppColors.textHint),
                          const SizedBox(height: 8),
                          Text(
                            'Chưa có sản phẩm nào\nNhấn "Thêm" để chọn sản phẩm',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                ...List.generate(_items.length, (i) {
                  final item = _items[i];
                  final price = widget.isExport
                      ? item.product.exportPrice
                      : item.product.importPrice;
                  final qty = int.tryParse(item.quantityCtl.text) ?? 0;
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  'Đơn giá: ${CurrencyFormatter.format(price)}',
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 70,
                            child: TextFormField(
                              controller: item.quantityCtl,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                              ),
                              validator: Validators.validateQuantity,
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            CurrencyFormatter.format(qty * price),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: color,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: () => _removeItem(i),
                            color: AppColors.error,
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                    ),
                  );
                }),

              const SizedBox(height: 12),

              // Total
              if (_items.isNotEmpty)
                Card(
                  color: color.withValues(alpha: 0.05),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('TỔNG CỘNG',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(
                          CurrencyFormatter.format(_totalValue),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // Note
              TextFormField(
                controller: _noteCtl,
                decoration: const InputDecoration(
                  labelText: 'Ghi chú',
                  prefixIcon: Icon(Icons.note_outlined),
                  hintText: 'Ghi chú thêm (tùy chọn)',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),

              // Submit
              SizedBox(
                height: 50,
                child: BlocBuilder<TransactionBloc, TransactionState>(
                  builder: (context, state) {
                    final isLoading =
                        state.mapOrNull(loading: (_) => true) ?? false;
                    return ElevatedButton.icon(
                      onPressed: isLoading ? null : _submit,
                      icon: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : Icon(widget.isExport
                              ? Icons.arrow_upward
                              : Icons.arrow_downward),
                      label: Text(widget.isExport
                          ? 'Xác nhận xuất kho'
                          : 'Xác nhận nhập kho'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProductPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.85,
        expand: false,
        builder: (context, scrollController) {
          return BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              return state.map(
                initial: (_) => const Center(
                    child: CircularProgressIndicator.adaptive()),
                loading: (_) => const Center(
                    child: CircularProgressIndicator.adaptive()),
                loaded: (loaded) => Column(
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text('Chọn sản phẩm',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    Expanded(
                      child: loaded.products.isEmpty
                          ? const Center(
                              child: Text('Chưa có sản phẩm nào'))
                          : ListView.builder(
                              controller: scrollController,
                              itemCount: loaded.products.length,
                              itemBuilder: (context, index) {
                                final product = loaded.products[index];
                                final alreadyAdded = _items
                                    .any((e) => e.product.id == product.id);
                                final price = widget.isExport
                                    ? product.exportPrice
                                    : product.importPrice;
                                return ListTile(
                                  title: Text(product.name),
                                  subtitle: Text(
                                    '${product.category} • ${CurrencyFormatter.format(price)}',
                                  ),
                                  trailing: alreadyAdded
                                      ? const Icon(Icons.check,
                                          color: AppColors.success)
                                      : const Icon(
                                          Icons.add_circle_outline),
                                  onTap: alreadyAdded
                                      ? null
                                      : () {
                                          _addItem(product);
                                          Navigator.pop(context);
                                        },
                                );
                              },
                            ),
                    ),
                  ],
                ),
                actionSuccess: (_) => const Center(
                    child: CircularProgressIndicator.adaptive()),
                error: (e) => Center(child: Text(e.message)),
              );
            },
          );
        },
      ),
    );
  }
}

class _ItemEntry {
  final Product product;
  final TextEditingController quantityCtl;

  _ItemEntry({required this.product, required this.quantityCtl});
}
