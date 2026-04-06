import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/warehouse.dart';
import '../auth/auth_bloc.dart';
import 'warehouse_bloc.dart';

/// Form page for creating/editing a warehouse
class WarehouseFormPage extends StatefulWidget {
  final Warehouse? warehouse; // null = create, non-null = edit

  const WarehouseFormPage({super.key, this.warehouse});

  @override
  State<WarehouseFormPage> createState() => _WarehouseFormPageState();
}

class _WarehouseFormPageState extends State<WarehouseFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtl;
  late final TextEditingController _addressCtl;
  late final TextEditingController _areaCtl;
  late final TextEditingController _capacityCtl;
  late final TextEditingController _notesCtl;

  bool get _isEditing => widget.warehouse != null;

  @override
  void initState() {
    super.initState();
    final w = widget.warehouse;
    _nameCtl = TextEditingController(text: w?.name ?? '');
    _addressCtl = TextEditingController(text: w?.address ?? '');
    _areaCtl = TextEditingController(
        text: w?.area != null ? w!.area!.toStringAsFixed(0) : '');
    _capacityCtl = TextEditingController(
        text: w?.capacity != null ? w!.capacity.toString() : '');
    _notesCtl = TextEditingController(text: w?.notes ?? '');
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _addressCtl.dispose();
    _areaCtl.dispose();
    _capacityCtl.dispose();
    _notesCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? 'Sửa kho hàng' : 'Thêm kho hàng'),
        ),
        body: BlocListener<WarehouseBloc, WarehouseState>(
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Warehouse icon header
                  Center(
                    child: CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: const Icon(Icons.warehouse,
                          size: 36, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Name
                  TextFormField(
                    controller: _nameCtl,
                    decoration: const InputDecoration(
                      labelText: 'Tên kho hàng *',
                      prefixIcon: Icon(Icons.label_outline),
                      hintText: 'Ví dụ: Kho Chính, Kho Phụ...',
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Vui lòng nhập tên kho';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),

                  // Address
                  TextFormField(
                    controller: _addressCtl,
                    decoration: const InputDecoration(
                      labelText: 'Địa chỉ',
                      prefixIcon: Icon(Icons.location_on_outlined),
                      hintText: 'Ví dụ: 123 Nguyễn Văn A, Q1, TP.HCM',
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),

                  // Area + Capacity row
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _areaCtl,
                          decoration: const InputDecoration(
                            labelText: 'Diện tích (m²)',
                            prefixIcon: Icon(Icons.square_foot),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v != null && v.isNotEmpty) {
                              final n = double.tryParse(v);
                              if (n == null || n <= 0) {
                                return 'Không hợp lệ';
                              }
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _capacityCtl,
                          decoration: const InputDecoration(
                            labelText: 'Sức chứa (kiện)',
                            prefixIcon: Icon(Icons.inventory_2_outlined),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v != null && v.isNotEmpty) {
                              final n = int.tryParse(v);
                              if (n == null || n <= 0) {
                                return 'Không hợp lệ';
                              }
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Notes
                  TextFormField(
                    controller: _notesCtl,
                    decoration: const InputDecoration(
                      labelText: 'Ghi chú',
                      prefixIcon: Icon(Icons.note_outlined),
                      hintText: 'Thông tin bổ sung...',
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 32),

                  // Submit button
                  FilledButton.icon(
                    onPressed: _submit,
                    icon: Icon(_isEditing ? Icons.save : Icons.add, size: 18),
                    label: Text(_isEditing ? 'Lưu thay đổi' : 'Thêm kho hàng'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    String? userEmail;
    final authState = context.read<AuthBloc>().state;
    authState.mapOrNull(
      authenticated: (auth) => userEmail = auth.user.email,
    );

    final now = DateTime.now();
    final area = _areaCtl.text.trim().isNotEmpty
        ? double.tryParse(_areaCtl.text.trim())
        : null;
    final capacity = _capacityCtl.text.trim().isNotEmpty
        ? int.tryParse(_capacityCtl.text.trim())
        : null;

    final warehouse = Warehouse(
      id: widget.warehouse?.id ?? '',
      name: _nameCtl.text.trim(),
      address:
          _addressCtl.text.trim().isNotEmpty ? _addressCtl.text.trim() : null,
      area: area,
      capacity: capacity,
      notes: _notesCtl.text.trim().isNotEmpty ? _notesCtl.text.trim() : null,
      isActive: true,
      createdAt: widget.warehouse?.createdAt ?? now,
      updatedAt: now,
      updatedBy: userEmail,
    );

    if (_isEditing) {
      context
          .read<WarehouseBloc>()
          .add(WarehouseEvent.updateWarehouse(warehouse));
    } else {
      context
          .read<WarehouseBloc>()
          .add(WarehouseEvent.addWarehouse(warehouse));
    }
  }
}
