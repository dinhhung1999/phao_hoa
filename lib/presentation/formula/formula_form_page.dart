import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_formula.dart';
import '../../presentation/category/category_bloc.dart';
import 'formula_bloc.dart';

/// Form page for creating/editing a product formula
class FormulaFormPage extends StatefulWidget {
  final ProductFormula? formula;

  const FormulaFormPage({super.key, this.formula});

  @override
  State<FormulaFormPage> createState() => _FormulaFormPageState();
}

class _FormulaFormPageState extends State<FormulaFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _laborCostCtl = TextEditingController();
  final _notesCtl = TextEditingController();

  Product? _selectedProduct;
  final List<_ComponentEntry> _components = [];
  List<Product> _allProducts = [];

  bool get _isEditing => widget.formula != null;

  @override
  void initState() {
    super.initState();
    _loadProducts();

    if (_isEditing) {
      final f = widget.formula!;
      _laborCostCtl.text = CurrencyFormatter.formatPlain(f.laborCost);
      _notesCtl.text = f.notes ?? '';
    }
  }

  void _loadProducts() {
    final state = context.read<CategoryBloc>().state;
    state.mapOrNull(
      loaded: (s) => _allProducts = s.products,
      paginatedLoaded: (s) => _allProducts = s.products,
    );

    if (_isEditing && _allProducts.isNotEmpty) {
      final f = widget.formula!;
      // Find selected product
      _selectedProduct = _allProducts
          .where((p) => p.id == f.productId)
          .firstOrNull;

      // Populate components
      for (final comp in f.components) {
        final product = _allProducts
            .where((p) => p.id == comp.productId)
            .firstOrNull;
        if (product != null) {
          _components.add(_ComponentEntry(
            product: product,
            quantityCtl: TextEditingController(text: comp.quantity.toString()),
          ));
        }
      }
    }
  }

  @override
  void dispose() {
    _laborCostCtl.dispose();
    _notesCtl.dispose();
    for (final c in _components) {
      c.dispose();
    }
    super.dispose();
  }

  double get _calculatedPrice {
    double total = double.tryParse(
          _laborCostCtl.text.replaceAll(RegExp(r'[^\d]'), ''),
        ) ??
        0;
    for (final comp in _components) {
      final qty = int.tryParse(comp.quantityCtl.text) ?? 0;
      total += qty * comp.product.exportPrice;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Sửa công thức' : 'Tạo công thức ghép'),
      ),
      body: BlocListener<FormulaBloc, FormulaState>(
        listener: (context, state) {
          state.mapOrNull(
            actionSuccess: (s) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(s.message)),
              );
              Navigator.pop(context);
            },
            error: (s) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(s.message),
                  backgroundColor: AppColors.error,
                ),
              );
            },
          );
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Section 1: Chọn sản phẩm ghép
              _buildSectionHeader('Sản phẩm ghép', Icons.inventory_2_outlined),
              const SizedBox(height: 8),
              _buildProductDropdown(),
              const SizedBox(height: 24),

              // Section 2: Thành phần
              _buildSectionHeader('Thành phần nguyên liệu', Icons.list_alt),
              const SizedBox(height: 8),
              ..._buildComponentsList(),
              const SizedBox(height: 8),
              _buildAddComponentButton(),
              const SizedBox(height: 24),

              // Section 3: Tiền công
              _buildSectionHeader('Chi phí ghép', Icons.payments_outlined),
              const SizedBox(height: 8),
              TextFormField(
                controller: _laborCostCtl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Tiền công ghép (₫)',
                  hintText: '0 nếu không có',
                  prefixIcon: Icon(Icons.handyman_outlined),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),

              // Section 4: Ghi chú
              TextFormField(
                controller: _notesCtl,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Ghi chú (tuỳ chọn)',
                  hintText: 'VD: 4 viên hoặc 2 viên + 2 nháy',
                  prefixIcon: Icon(Icons.notes_outlined),
                ),
              ),
              const SizedBox(height: 24),

              // Calculated price
              _buildCalculatedPrice(),
              const SizedBox(height: 24),

              // Save button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.save),
                  label: Text(_isEditing ? 'Cập nhật' : 'Lưu công thức'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildProductDropdown() {
    // Filter out products that are already used as components
    final componentIds = _components.map((c) => c.product.id).toSet();
    final availableProducts = _allProducts
        .where((p) => !componentIds.contains(p.id) || p.id == _selectedProduct?.id)
        .toList();

    return DropdownButtonFormField<Product>(
      value: _selectedProduct,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Chọn sản phẩm ghép *',
        prefixIcon: Icon(Icons.inventory_2),
      ),
      items: availableProducts.map((p) {
        return DropdownMenuItem(
          value: p,
          child: Text(
            '${p.name} (${CurrencyFormatter.format(p.exportPrice)})',
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (v) => setState(() => _selectedProduct = v),
      validator: (v) => v == null ? 'Vui lòng chọn sản phẩm' : null,
    );
  }

  List<Widget> _buildComponentsList() {
    return _components.asMap().entries.map((entry) {
      final index = entry.key;
      final comp = entry.value;
      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Component icon
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.info,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Product name + price
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comp.product.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      CurrencyFormatter.format(comp.product.exportPrice),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondaryOf(context),
                      ),
                    ),
                  ],
                ),
              ),
              // Quantity input
              SizedBox(
                width: 64,
                child: TextFormField(
                  controller: comp.quantityCtl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    hintText: 'SL',
                  ),
                  validator: (v) {
                    final qty = int.tryParse(v ?? '') ?? 0;
                    if (qty <= 0) return '> 0';
                    return null;
                  },
                  onChanged: (_) => setState(() {}),
                ),
              ),
              // Remove button
              IconButton(
                icon: const Icon(Icons.close, size: 20, color: AppColors.error),
                onPressed: () {
                  setState(() {
                    comp.dispose();
                    _components.removeAt(index);
                  });
                },
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildAddComponentButton() {
    return OutlinedButton.icon(
      onPressed: _showComponentPicker,
      icon: const Icon(Icons.add, size: 18),
      label: const Text('Thêm nguyên liệu'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: BorderSide(
          color: AppColors.primary.withValues(alpha: 0.5),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  Widget _buildCalculatedPrice() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.success.withValues(alpha: 0.08),
            AppColors.success.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.calculate_outlined,
                  size: 20, color: AppColors.success),
              SizedBox(width: 8),
              Text(
                'GIÁ TỰ TÍNH',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 1,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            CurrencyFormatter.format(_calculatedPrice),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.success,
            ),
          ),
          if (_components.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              '= ${_components.where((c) => (int.tryParse(c.quantityCtl.text) ?? 0) > 0).map((c) => '${c.quantityCtl.text}×${c.product.name}').join(' + ')}${(double.tryParse(_laborCostCtl.text.replaceAll(RegExp(r'[^\d]'), '')) ?? 0) > 0 ? ' + công' : ''}',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondaryOf(context),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  void _showComponentPicker() {
    // Filter products: exclude selected product and already-added components
    final excludeIds = {
      if (_selectedProduct != null) _selectedProduct!.id,
      ..._components.map((c) => c.product.id),
    };
    final available = _allProducts
        .where((p) => !excludeIds.contains(p.id))
        .toList();

    if (available.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không còn sản phẩm để thêm')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
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
          const Text(
            'Chọn nguyên liệu',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: available.length,
              itemBuilder: (ctx, i) {
                final product = available[i];
                return ListTile(
                  leading: const Icon(Icons.inventory_2_outlined),
                  title: Text(product.name),
                  subtitle: Text(CurrencyFormatter.format(product.exportPrice)),
                  trailing: const Icon(Icons.add_circle_outline),
                  onTap: () {
                    setState(() {
                      _components.add(_ComponentEntry(
                        product: product,
                        quantityCtl: TextEditingController(text: '1'),
                      ));
                    });
                    Navigator.pop(ctx);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedProduct == null) return;
    if (_components.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cần ít nhất 1 thành phần nguyên liệu')),
      );
      return;
    }

    final laborCost = double.tryParse(
          _laborCostCtl.text.replaceAll(RegExp(r'[^\d]'), ''),
        ) ??
        0;

    final formula = ProductFormula(
      id: widget.formula?.id ?? '',
      productId: _selectedProduct!.id,
      productName: _selectedProduct!.name,
      components: _components.map((c) {
        return FormulaComponent(
          productId: c.product.id,
          productName: c.product.name,
          quantity: int.tryParse(c.quantityCtl.text) ?? 0,
        );
      }).toList(),
      laborCost: laborCost,
      notes: _notesCtl.text.trim().isEmpty ? null : _notesCtl.text.trim(),
      updatedAt: DateTime.now(),
      updatedBy: FirebaseAuth.instance.currentUser?.email,
    );

    context.read<FormulaBloc>().add(FormulaEvent.saveFormula(formula));
  }
}

class _ComponentEntry {
  final Product product;
  final TextEditingController quantityCtl;

  _ComponentEntry({required this.product, required this.quantityCtl});

  void dispose() {
    quantityCtl.dispose();
  }
}
