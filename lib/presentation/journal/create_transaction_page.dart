import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/expression_evaluator.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/customer.dart';
import '../../domain/entities/transaction.dart' as entity;
import '../../domain/entities/transaction_item.dart';
import '../auth/auth_bloc.dart';
import '../category/category_bloc.dart';
import '../customer/customer_bloc.dart';
import 'transaction_bloc.dart';

/// Create import/export transaction page
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
  final _customerNameCtl = TextEditingController();

  String _warehouseLocation = AppConstants.warehouseLocationNames.first;

  // Customer selection for export
  String _customerType = 'khach_le'; // 'khach_le' | 'khach_quen'
  Customer? _selectedCustomer;

  final List<_ItemEntry> _items = [];

  @override
  void initState() {
    super.initState();
    // Load products for the picker
    context.read<CategoryBloc>().add(const CategoryEvent.loadProducts());
    // Load customers for export orders
    if (widget.isExport) {
      context.read<CustomerBloc>().add(const CustomerEvent.loadCustomers());
    }
  }

  @override
  void dispose() {
    _sourceCtl.dispose();
    _noteCtl.dispose();
    _customerNameCtl.dispose();
    for (final item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  double get _totalValue {
    return _items.fold(0.0, (sum, item) {
      final qty = _resolveQuantity(item.quantityCtl.text);
      final price = _resolvePrice(item);
      return sum + (qty * price);
    });
  }

  /// Resolve quantity from text, supporting expressions like 7*24
  int _resolveQuantity(String text) {
    return ExpressionEvaluator.tryEvaluate(text) ?? 0;
  }

  /// Resolve price from the editable price controller
  double _resolvePrice(_ItemEntry item) {
    final text = item.priceCtl.text.replaceAll(RegExp(r'[^\d]'), '');
    return double.tryParse(text) ?? 0;
  }

  void _addItem(Product product) {
    // Check if product already added
    if (_items.any((e) => e.product.id == product.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sản phẩm đã được thêm')),
      );
      return;
    }
    final defaultPrice =
        widget.isExport ? product.exportPrice : product.importPrice;
    setState(() {
      _items.add(_ItemEntry(
        product: product,
        quantityCtl: TextEditingController(text: '1'),
        priceCtl: TextEditingController(
          text: CurrencyFormatter.formatPlain(defaultPrice),
        ),
      ));
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items[index].dispose();
      _items.removeAt(index);
    });
  }

  /// Evaluate expression in quantity field when user finishes editing
  void _evaluateQuantityExpression(_ItemEntry item) {
    final text = item.quantityCtl.text.trim();
    if (ExpressionEvaluator.isExpression(text)) {
      final result = ExpressionEvaluator.tryEvaluate(text);
      if (result != null && result > 0) {
        item.quantityCtl.text = result.toString();
        setState(() {});
      }
    }
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
      final qty = _resolveQuantity(e.quantityCtl.text);
      final price = _resolvePrice(e);
      return TransactionItem(
        id: '',
        productId: e.product.id,
        productName: e.product.name,
        quantity: qty,
        unitPriceAtTime: price,
        subtotal: qty * price,
      );
    }).toList();

    // Get current user email for createdBy
    String userEmail = '';
    final authState = context.read<AuthBloc>().state;
    authState.mapOrNull(
      authenticated: (auth) => userEmail = auth.user.email,
    );

    // Determine customer info based on transaction type
    String customerName;
    String customerType;
    String? customerId;

    if (widget.isExport) {
      customerType = _customerType;
      if (_customerType == 'khach_quen' && _selectedCustomer != null) {
        customerName = _selectedCustomer!.name;
        customerId = _selectedCustomer!.id;
      } else {
        final nameText = _customerNameCtl.text.trim();
        customerName = nameText.isNotEmpty ? nameText : 'Khách lẻ';
      }
    } else {
      // Import: use source field
      final sourceText = _sourceCtl.text.trim();
      customerName = sourceText.isNotEmpty ? sourceText : 'Nhập kho';
      customerType = 'noi_bo';
    }

    final transaction = entity.Transaction(
      id: '',
      type: widget.type,
      customerId: customerId,
      customerName: customerName,
      customerType: customerType,
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
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
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

                // ── Customer selection (export) / Source (import) ──
                if (widget.isExport) ...[
                  _buildCustomerSection(),
                ] else ...[
                  // Import: Nguồn nhập / Nhà cung cấp
                  TextFormField(
                    controller: _sourceCtl,
                    decoration: const InputDecoration(
                      labelText: 'Nguồn nhập / Nhà cung cấp',
                      prefixIcon: Icon(Icons.business_outlined),
                      hintText: 'VD: Nhà cung cấp A, Nhập bổ sung, ...',
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ],
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
                    final price = _resolvePrice(item);
                    final qty = _resolveQuantity(item.quantityCtl.text);
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Row 1: Product name + remove button
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.product.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, size: 18),
                                  onPressed: () => _removeItem(i),
                                  color: AppColors.error,
                                  visualDensity: VisualDensity.compact,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Row 2: Price + Quantity + Subtotal
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Editable price field
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Đơn giá',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    SizedBox(
                                      width: 110,
                                      child: TextFormField(
                                        controller: item.priceCtl,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.end,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 8),
                                          suffixText: 'đ',
                                          suffixStyle: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        style: const TextStyle(fontSize: 13),
                                        validator: (v) {
                                          final parsed = double.tryParse(
                                              (v ?? '').replaceAll(
                                                  RegExp(r'[^\d]'), ''));
                                          if (parsed == null || parsed <= 0) {
                                            return 'Giá > 0';
                                          }
                                          return null;
                                        },
                                        onChanged: (_) => setState(() {}),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 8),
                                // Quantity field with expression support
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Số lượng',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    SizedBox(
                                      width: 80,
                                      child: TextFormField(
                                        controller: item.quantityCtl,
                                        keyboardType: TextInputType.text,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 8),
                                          hintText: 'VD: 7*24',
                                          hintStyle: TextStyle(
                                            fontSize: 11,
                                            color: AppColors.textHint,
                                          ),
                                        ),
                                        style: const TextStyle(fontSize: 13),
                                        validator: (v) {
                                          if (v == null || v.trim().isEmpty) {
                                            return 'Nhập SL';
                                          }
                                          final result =
                                              ExpressionEvaluator.tryEvaluate(v);
                                          if (result == null || result <= 0) {
                                            return 'SL > 0';
                                          }
                                          return null;
                                        },
                                        onChanged: (_) => setState(() {}),
                                        onEditingComplete: () {
                                          _evaluateQuantityExpression(item);
                                          FocusScope.of(context).nextFocus();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 8),
                                // Subtotal
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Thành tiền',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        CurrencyFormatter.format(qty * price),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
      ),
    );
  }

  /// Build customer selection section for export orders
  Widget _buildCustomerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Customer type toggle
        Row(
          children: [
            const Icon(Icons.person_outline, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            const Text('Khách hàng', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _CustomerTypeChip(
                label: 'Khách lẻ',
                icon: Icons.person_outline,
                selected: _customerType == 'khach_le',
                onTap: () => setState(() {
                  _customerType = 'khach_le';
                  _selectedCustomer = null;
                }),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _CustomerTypeChip(
                label: 'Khách quen',
                icon: Icons.people_outline,
                selected: _customerType == 'khach_quen',
                onTap: () => setState(() {
                  _customerType = 'khach_quen';
                }),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Customer detail based on type
        if (_customerType == 'khach_le')
          TextFormField(
            controller: _customerNameCtl,
            decoration: const InputDecoration(
              labelText: 'Tên khách (tuỳ chọn)',
              prefixIcon: Icon(Icons.badge_outlined),
              hintText: 'Nhập tên khách nếu cần',
            ),
            textInputAction: TextInputAction.next,
          )
        else
          _buildCustomerDropdown(),
      ],
    );
  }

  /// Build dropdown to select from existing customers
  Widget _buildCustomerDropdown() {
    return BlocBuilder<CustomerBloc, CustomerState>(
      builder: (context, state) {
        return state.maybeMap(
          customersLoaded: (loaded) {
            final regularCustomers = loaded.customers
                .where((c) => c.type == 'khach_quen')
                .toList();
            if (regularCustomers.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          size: 18, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Chưa có khách quen nào. Hãy thêm khách hàng trước.',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            // Show all customers (not just khach_quen) for flexibility
            final allCustomers = loaded.customers;
            return DropdownButtonFormField<Customer>(
              initialValue: _selectedCustomer,
              decoration: const InputDecoration(
                labelText: 'Chọn khách hàng *',
                prefixIcon: Icon(Icons.person),
              ),
              items: allCustomers.map((c) {
                return DropdownMenuItem(
                  value: c,
                  child: Text('${c.name}${c.phone != null ? ' (${c.phone})' : ''}'),
                );
              }).toList(),
              onChanged: (v) => setState(() => _selectedCustomer = v),
              validator: (v) {
                if (_customerType == 'khach_quen' && v == null) {
                  return 'Vui lòng chọn khách hàng';
                }
                return null;
              },
            );
          },
          orElse: () => const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator.adaptive()),
          ),
        );
      },
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
                loaded: (loaded) {
                  final products = loaded.products;

                  return Column(
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
                        child: products.isEmpty
                            ? const Center(
                                child: Text('Chưa có sản phẩm nào'))
                            : ListView.builder(
                                controller: scrollController,
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  final product = products[index];
                                  final alreadyAdded = _items.any(
                                      (e) => e.product.id == product.id);
                                  final price = widget.isExport
                                      ? product.exportPrice
                                      : product.importPrice;
                                  return ListTile(
                                    title: Text(product.name),
                                    subtitle: Text(
                                      CurrencyFormatter.format(price),
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
                  );
                },
                actionSuccess: (_) => const Center(
                    child: CircularProgressIndicator.adaptive()),
                paginatedLoaded: (loaded) {
                  final products = loaded.products;

                  return Column(
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
                        child: products.isEmpty
                            ? const Center(
                                child: Text('Chưa có sản phẩm nào'))
                            : ListView.builder(
                                controller: scrollController,
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  final product = products[index];
                                  final alreadyAdded = _items.any(
                                      (e) => e.product.id == product.id);
                                  final price = widget.isExport
                                      ? product.exportPrice
                                      : product.importPrice;
                                  return ListTile(
                                    title: Text(product.name),
                                    subtitle: Text(
                                      CurrencyFormatter.format(price),
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
                  );
                },
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
  final TextEditingController priceCtl;

  _ItemEntry({
    required this.product,
    required this.quantityCtl,
    required this.priceCtl,
  });

  void dispose() {
    quantityCtl.dispose();
    priceCtl.dispose();
  }
}

class _CustomerTypeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _CustomerTypeChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
