import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/enums/product_category.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../domain/entities/product.dart';
import '../auth/auth_bloc.dart';
import 'category_bloc.dart';

/// Add / Edit product form page
class ProductFormPage extends StatefulWidget {
  /// If [product] is provided, the form opens in edit mode.
  final Product? product;

  const ProductFormPage({super.key, this.product});

  bool get isEditMode => product != null;

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtl;
  late final TextEditingController _importPriceCtl;
  late final TextEditingController _exportPriceCtl;
  late final TextEditingController _unitCtl;

  late ProductCategory _category;
  String _regulationClass = 'A';

  static const _classes = ['A', 'B', 'C'];

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameCtl = TextEditingController(text: p?.name ?? '');
    _importPriceCtl =
        TextEditingController(text: p != null ? p.importPrice.toInt().toString() : '');
    _exportPriceCtl =
        TextEditingController(text: p != null ? p.exportPrice.toInt().toString() : '');
    _unitCtl = TextEditingController(text: p?.unit ?? 'Hộp');
    if (p != null) {
      _category = ProductCategory.fromValue(p.category);
      _regulationClass = p.regulationClass;
    } else {
      _category = ProductCategory.vien;
    }
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _importPriceCtl.dispose();
    _exportPriceCtl.dispose();
    _unitCtl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    // Get current user email for updatedBy
    String? userEmail;
    final authState = context.read<AuthBloc>().state;
    authState.mapOrNull(
      authenticated: (auth) => userEmail = auth.user.email,
    );

    final product = Product(
      id: widget.product?.id ?? '',
      name: _nameCtl.text.trim(),
      category: _category.value,
      regulationClass: _regulationClass,
      unit: _unitCtl.text.trim(),
      importPrice: double.tryParse(
            _importPriceCtl.text.replaceAll(RegExp(r'[^\d]'), ''),
          ) ??
          0,
      exportPrice: double.tryParse(
            _exportPriceCtl.text.replaceAll(RegExp(r'[^\d]'), ''),
          ) ??
          0,
      createdAt: widget.product?.createdAt ?? now,
      updatedAt: now,
      updatedBy: userEmail,
    );

    final bloc = context.read<CategoryBloc>();
    if (widget.isEditMode) {
      bloc.add(CategoryEvent.updateProduct(product));
    } else {
      bloc.add(CategoryEvent.addProduct(product));
    }

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditMode ? 'Sửa sản phẩm' : 'Thêm sản phẩm'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Name
              TextFormField(
                controller: _nameCtl,
                decoration: const InputDecoration(
                  labelText: 'Tên sản phẩm *',
                  prefixIcon: Icon(Icons.inventory_2_outlined),
                ),
                validator: Validators.validateProductName,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // Category dropdown
              DropdownButtonFormField<ProductCategory>(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: 'Danh mục',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: ProductCategory.values.map((c) {
                  return DropdownMenuItem(value: c, child: Text(c.displayName));
                }).toList(),
                onChanged: (v) => setState(() => _category = v ?? _category),
              ),
              const SizedBox(height: 16),

              // Regulation class + Unit
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _regulationClass,
                      decoration: const InputDecoration(
                        labelText: 'Hạng (NĐ 137)',
                        prefixIcon: Icon(Icons.shield_outlined),
                      ),
                      items: _classes.map((c) {
                        return DropdownMenuItem(value: c, child: Text('Loại $c'));
                      }).toList(),
                      onChanged: (v) =>
                          setState(() => _regulationClass = v ?? _regulationClass),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _unitCtl,
                      decoration: const InputDecoration(
                        labelText: 'Đơn vị',
                        prefixIcon: Icon(Icons.straighten),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Import price
              TextFormField(
                controller: _importPriceCtl,
                decoration: const InputDecoration(
                  labelText: 'Giá nhập (₫) *',
                  prefixIcon: Icon(Icons.arrow_downward),
                ),
                keyboardType: TextInputType.number,
                validator: Validators.validatePrice,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // Export price
              TextFormField(
                controller: _exportPriceCtl,
                decoration: const InputDecoration(
                  labelText: 'Giá xuất (₫) *',
                  prefixIcon: Icon(Icons.arrow_upward),
                ),
                keyboardType: TextInputType.number,
                validator: Validators.validatePrice,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 32),

              // Submit button
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  icon: Icon(widget.isEditMode ? Icons.save : Icons.add),
                  label: Text(widget.isEditMode ? 'Lưu thay đổi' : 'Thêm sản phẩm'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
