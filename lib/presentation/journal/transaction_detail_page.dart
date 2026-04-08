import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../domain/entities/transaction.dart' as entity;
import 'transaction_bloc.dart';

/// Transaction detail page — shows full info of a single import/export transaction
class TransactionDetailPage extends StatefulWidget {
  final entity.Transaction transaction;

  const TransactionDetailPage({super.key, required this.transaction});

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  late entity.Transaction _tx;

  bool get _isExport => _tx.type == 'xuat';

  @override
  void initState() {
    super.initState();
    _tx = widget.transaction;
  }

  void _showUpdateDebtDialog() {
    final paidCtl = TextEditingController(
      text: CurrencyFormatter.formatPlain(_tx.paidAmount),
    );
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cập nhật thanh toán'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Show current debt info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.debtActive.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    _infoRow('Tổng đơn hàng',
                        CurrencyFormatter.format(_tx.totalValue)),
                    const SizedBox(height: 6),
                    _infoRow('Đã thanh toán',
                        CurrencyFormatter.format(_tx.paidAmount)),
                    const SizedBox(height: 6),
                    _infoRow('Còn nợ',
                        CurrencyFormatter.format(_tx.unpaidAmount),
                        valueColor: AppColors.debtActive),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: paidCtl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Số tiền đã thanh toán (₫)',
                  prefixIcon: Icon(Icons.payments_outlined),
                  hintText: 'Nhập số tiền đã thu',
                ),
                validator: (v) {
                  final parsed = double.tryParse(
                    (v ?? '').replaceAll(RegExp(r'[^\d]'), ''),
                  );
                  if (parsed == null || parsed < 0) {
                    return 'Số tiền không hợp lệ';
                  }
                  if (parsed > _tx.totalValue) {
                    return 'Không thể lớn hơn tổng đơn hàng';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              // Quick action buttons
              Wrap(
                spacing: 8,
                children: [
                  ActionChip(
                    label: const Text('Trả hết', style: TextStyle(fontSize: 12)),
                    avatar: const Icon(Icons.done_all, size: 16),
                    onPressed: () {
                      paidCtl.text =
                          CurrencyFormatter.formatPlain(_tx.totalValue);
                    },
                  ),
                  if (_tx.paidAmount > 0)
                    ActionChip(
                      label: Text(
                        '+ ${CurrencyFormatter.format(_tx.unpaidAmount)}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      avatar: const Icon(Icons.add, size: 16),
                      onPressed: () {
                        paidCtl.text =
                            CurrencyFormatter.formatPlain(_tx.totalValue);
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              final newPaid = double.tryParse(
                    paidCtl.text.replaceAll(RegExp(r'[^\d]'), ''),
                  ) ??
                  0;
              Navigator.of(dialogContext).pop(newPaid);
            },
            child: const Text('Cập nhật'),
          ),
        ],
      ),
    ).then((newPaid) {
      if (newPaid != null && newPaid is double && mounted) {
        context.read<TransactionBloc>().add(
              TransactionEvent.updateDebtPayment(
                transactionId: _tx.id,
                newPaidAmount: newPaid,
                totalValue: _tx.totalValue,
                customerId: _tx.customerId,
                previousPaidAmount: _tx.paidAmount,
              ),
            );
      }
    });
  }

  Widget _infoRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style:
                TextStyle(fontSize: 13, color: AppColors.textSecondaryOf(context))),
        Text(value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: valueColor,
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = _isExport ? AppColors.exportColor : AppColors.importColor;

    return BlocListener<TransactionBloc, TransactionState>(
      listener: (context, state) {
        state.mapOrNull(
          debtUpdated: (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đã cập nhật thanh toán'),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.of(context).pop(true); // Signal list to refresh
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
          title: Text(_isExport ? 'Phiếu xuất kho' : 'Phiếu nhập kho'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Header card
            Card(
              color: color,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _isExport ? Icons.arrow_upward : Icons.arrow_downward,
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isExport ? 'XUẤT KHO' : 'NHẬP KHO',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      CurrencyFormatter.format(_tx.totalValue),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_tx.isDebt) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'GHI NỢ • Đã trả: ${CurrencyFormatter.format(_tx.paidAmount)}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Debt management section
            if (_tx.isDebt) ...[
              _sectionTitle('Quản lý công nợ'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tổng đơn hàng',
                              style: TextStyle(color: AppColors.textSecondaryOf(context))),
                          Text(CurrencyFormatter.format(_tx.totalValue),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Đã thanh toán',
                              style: TextStyle(color: AppColors.textSecondaryOf(context))),
                          Text(CurrencyFormatter.format(_tx.paidAmount),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppColors.success,
                              )),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('CÒN NỢ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.debtActive,
                              )),
                          Text(
                            CurrencyFormatter.format(_tx.unpaidAmount),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppColors.debtActive,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _showUpdateDebtDialog,
                          icon: const Icon(Icons.payments_outlined),
                          label: const Text('Cập nhật thanh toán'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Customer info
            _sectionTitle('Khách hàng'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          AppColors.primary.withValues(alpha: 0.1),
                      child:
                          const Icon(Icons.person, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _tx.customerName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            _tx.customerType == 'khach_quen'
                                ? 'Khách quen'
                                : _tx.customerType == 'noi_bo'
                                    ? 'Nội bộ'
                                    : 'Khách lẻ',
                            style: TextStyle(
                                color: AppColors.textSecondaryOf(context)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Details
            _sectionTitle('Thông tin'),
            Card(
              child: Column(
                children: [
                  _detailRow('Kho', _tx.warehouseLocation),
                  const Divider(height: 1),
                  _detailRow(
                    'Thời gian',
                    DateFormatter.formatDateTime(_tx.createdAt),
                  ),
                  const Divider(height: 1),
                  _detailRow('Người tạo', _tx.createdBy),
                  if (_tx.totalQuantity > 0) ...[
                    const Divider(height: 1),
                    _detailRow(
                        'Tổng số lượng', '${_tx.totalQuantity} SP'),
                  ],
                  if (_tx.note != null && _tx.note!.isNotEmpty) ...[
                    const Divider(height: 1),
                    _detailRow('Ghi chú', _tx.note!),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Items — use items (sub-collection) if available,
            // otherwise fall back to itemsSummary (denormalized data)
            if (_tx.items.isNotEmpty) ...[
              _sectionTitle(
                  'Danh sách sản phẩm (${_tx.items.length})'),
              Card(
                child: Column(
                  children:
                      _tx.items.asMap().entries.map((entry) {
                    final item = entry.value;
                    final isLast =
                        entry.key == _tx.items.length - 1;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.productName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '${CurrencyFormatter.format(item.unitPriceAtTime)} × ${item.quantity}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textSecondaryOf(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                CurrencyFormatter.format(item.subtotal),
                                style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!isLast) const Divider(height: 1),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ] else if (_tx.itemsSummary.isNotEmpty) ...[
              _sectionTitle(
                  'Danh sách sản phẩm (${_tx.itemsSummary.length})'),
              Card(
                child: Column(
                  children: _tx.itemsSummary
                      .asMap()
                      .entries
                      .map((entry) {
                    final item = entry.value;
                    final isLast = entry.key ==
                        _tx.itemsSummary.length - 1;
                    final name = item['name'] ?? '';
                    final qty = item['qty'] ?? 0;
                    final price = (item['price'] ?? 0).toDouble();
                    final subtotal = qty * price;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '${CurrencyFormatter.format(price)} × $qty',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textSecondaryOf(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                CurrencyFormatter.format(subtotal),
                                style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!isLast) const Divider(height: 1),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
            // Total row
            if (_tx.items.isNotEmpty ||
                _tx.itemsSummary.isNotEmpty) ...[
              const SizedBox(height: 12),
              Card(
                color: color.withValues(alpha: 0.05),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      if (_tx.totalQuantity > 0) ...[
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tổng số lượng',
                              style: TextStyle(
                                color: AppColors.textSecondaryOf(context),
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${_tx.totalQuantity} SP',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Divider(height: 1),
                        const SizedBox(height: 8),
                      ],
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'TỔNG CỘNG',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            CurrencyFormatter.format(
                                _tx.totalValue),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: AppColors.textSecondaryOf(context),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppColors.textSecondaryOf(context))),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}