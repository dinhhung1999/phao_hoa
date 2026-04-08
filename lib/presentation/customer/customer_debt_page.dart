import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_widget.dart';
import '../../domain/entities/customer.dart';
import '../../domain/entities/debt_record.dart';
import 'customer_bloc.dart';

/// Customer debt history page — shows all debt & payment records
class CustomerDebtPage extends StatefulWidget {
  final Customer customer;

  const CustomerDebtPage({super.key, required this.customer});

  @override
  State<CustomerDebtPage> createState() => _CustomerDebtPageState();
}

class _CustomerDebtPageState extends State<CustomerDebtPage> {
  @override
  void initState() {
    super.initState();
    context.read<CustomerBloc>().add(CustomerEvent.loadDebts(
          customerId: widget.customer.id,
          customer: widget.customer,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Công nợ - ${widget.customer.name}'),
      ),
      body: BlocBuilder<CustomerBloc, CustomerState>(
        builder: (context, state) {
          return state.map(
            initial: (_) => const AppLoadingIndicator(),
            loading: (_) =>
                const AppLoadingIndicator(message: 'Đang tải lịch sử...'),
            customersLoaded: (_) => const AppLoadingIndicator(),
            paginatedLoaded: (_) => const AppLoadingIndicator(),
            debtsLoaded: (loaded) => _buildDebtHistory(
              loaded.customer,
              loaded.records,
            ),
            actionSuccess: (_) => const AppLoadingIndicator(),
            error: (e) => AppErrorWidget(
              message: e.message,
              onRetry: () => context.read<CustomerBloc>().add(
                    CustomerEvent.loadDebts(
                      customerId: widget.customer.id,
                      customer: widget.customer,
                    ),
                  ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDebtHistory(Customer customer, List<DebtRecord> records) {
    return Column(
      children: [
        // Summary header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: customer.hasDebt
                ? AppColors.debtActive.withValues(alpha: 0.05)
                : AppColors.success.withValues(alpha: 0.05),
          ),
          child: Column(
            children: [
              Text(
                CurrencyFormatter.format(customer.totalDebt),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: customer.hasDebt
                      ? AppColors.debtActive
                      : AppColors.success,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                customer.hasDebt ? 'Tổng công nợ hiện tại' : 'Không có công nợ',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              if (customer.hasDebt) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            _showPaymentDialog(context, customer),
                        icon: const Icon(Icons.payment, size: 18),
                        label: const Text('Thanh toán'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            _handleSettleAll(context, customer),
                        icon: const Icon(Icons.done_all, size: 18),
                        label: const Text('Tất toán'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),

        // History list
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            children: [
              const Text(
                'Lịch sử',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(${records.length} bản ghi)',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: records.isEmpty
              ? const Center(
                  child: Text('Chưa có lịch sử công nợ',
                      style: TextStyle(color: AppColors.textSecondary)),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: records.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final record = records[index];
                    return _DebtRecordTile(record: record);
                  },
                ),
        ),
      ],
    );
  }

  void _showPaymentDialog(BuildContext context, Customer customer) {
    final amountCtl = TextEditingController();
    final noteCtl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Thanh toán công nợ'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'Công nợ hiện tại: ${CurrencyFormatter.format(customer.totalDebt)}'),
              const SizedBox(height: 12),
              TextFormField(
                controller: amountCtl,
                decoration: const InputDecoration(
                  labelText: 'Số tiền thanh toán *',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Vui lòng nhập số tiền';
                  final amount =
                      double.tryParse(v.replaceAll(RegExp(r'[^\d]'), ''));
                  if (amount == null || amount <= 0) {
                    return 'Số tiền không hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: noteCtl,
                decoration: const InputDecoration(
                  labelText: 'Ghi chú',
                  prefixIcon: Icon(Icons.note_outlined),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              final amount = double.tryParse(
                    amountCtl.text.replaceAll(RegExp(r'[^\d]'), ''),
                  ) ??
                  0;
              context.read<CustomerBloc>().add(
                    CustomerEvent.makePayment(
                      customerId: customer.id,
                      amount: amount,
                      note: noteCtl.text.trim().isNotEmpty
                          ? noteCtl.text.trim()
                          : null,
                    ),
                  );
              Navigator.pop(dialogContext);
            },
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }

  void _handleSettleAll(BuildContext context, Customer customer) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xác nhận tất toán'),
        content: Text(
          'Bạn có chắc muốn tất toán toàn bộ công nợ ${CurrencyFormatter.format(customer.totalDebt)} cho ${customer.name}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<CustomerBloc>().add(
                    CustomerEvent.settleAll(customer.id),
                  );
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
            ),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }
}

class _DebtRecordTile extends StatelessWidget {
  final DebtRecord record;

  const _DebtRecordTile({required this.record});

  @override
  Widget build(BuildContext context) {
    final isDebt = record.isDebt;
    final color = isDebt ? AppColors.debtActive : AppColors.success;
    final icon = isDebt ? Icons.add_circle_outline : Icons.remove_circle_outline;
    final prefix = isDebt ? '+' : '-';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: color.withValues(alpha: 0.1),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isDebt ? 'Ghi nợ' : 'Thanh toán',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    DateFormatter.formatDateTime(record.createdAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (record.note != null && record.note!.isNotEmpty)
                    Text(
                      record.note!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textHint,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$prefix${CurrencyFormatter.format(record.amount)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: color,
                  ),
                ),
                Text(
                  'Dư: ${CurrencyFormatter.format(record.runningBalance)}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
