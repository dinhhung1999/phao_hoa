import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_widget.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../domain/entities/customer.dart';
import '../auth/auth_bloc.dart';
import 'customer_bloc.dart';
import 'customer_debt_page.dart';

/// Customer list page — with pagination + pull-to-refresh
class CustomerListPage extends StatefulWidget {
  final bool showAppBar;

  const CustomerListPage({super.key, this.showAppBar = true});

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  final ScrollController _scrollCtl = ScrollController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<CustomerBloc>().add(const CustomerEvent.loadCustomersPaginated());
    _scrollCtl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtl
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<CustomerBloc>().add(const CustomerEvent.loadMoreCustomers());
    }
  }

  bool get _isBottom {
    if (!_scrollCtl.hasClients) return false;
    final maxScroll = _scrollCtl.position.maxScrollExtent;
    final currentScroll = _scrollCtl.offset;
    return currentScroll >= (maxScroll - 200);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(title: const Text('Khách hàng'))
          : null,
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_customer',
        onPressed: () => _showAddCustomerDialog(context),
        child: const Icon(Icons.person_add),
      ),
      body: BlocConsumer<CustomerBloc, CustomerState>(
        listener: (context, state) {
          state.mapOrNull(
            actionSuccess: (s) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(s.message),
                  backgroundColor: AppColors.success,
                ),
              );
            },
          );
        },
        builder: (context, state) {
          return state.map(
            initial: (_) => const AppLoadingIndicator(),
            loading: (_) => const AppLoadingIndicator(),
            customersLoaded: (loaded) => _buildSearchableList(loaded.customers, false, false),
            paginatedLoaded: (loaded) => _buildSearchableList(
              loaded.customers, loaded.hasMore, loaded.isLoadingMore,
            ),
            debtsLoaded: (_) => const AppLoadingIndicator(),
            actionSuccess: (_) => const AppLoadingIndicator(),
            error: (e) => AppErrorWidget(
              message: e.message,
              onRetry: () => context
                  .read<CustomerBloc>()
                  .add(const CustomerEvent.loadCustomersPaginated()),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchableList(
    List<Customer> customers, bool hasMore, bool isLoadingMore,
  ) {
    final filtered = _searchQuery.isEmpty
        ? customers
        : customers.where((c) {
            final q = _searchQuery.toLowerCase();
            return c.name.toLowerCase().contains(q) ||
                (c.phone?.contains(q) ?? false);
          }).toList();

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Tìm khách hàng...',
              prefixIcon: const Icon(Icons.search, size: 20),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () => setState(() => _searchQuery = ''),
                    )
                  : null,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            ),
            onChanged: (v) => setState(() => _searchQuery = v),
          ),
        ),
        Expanded(child: _buildList(filtered, hasMore, isLoadingMore)),
      ],
    );
  }

  Widget _buildList(List<Customer> customers, bool hasMore, bool isLoadingMore) {
    if (customers.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          context.read<CustomerBloc>().add(const CustomerEvent.refreshCustomers());
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 120),
            Center(
              child: Column(
                children: [
                  Icon(Icons.people_outline, size: 64, color: AppColors.textHint),
                  SizedBox(height: 12),
                  Text('Chưa có khách hàng',
                      style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<CustomerBloc>().add(const CustomerEvent.refreshCustomers());
      },
      child: ListView.separated(
        controller: _scrollCtl,
        padding: const EdgeInsets.all(16),
        itemCount: customers.length + (hasMore ? 1 : 0),
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          if (index >= customers.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          }
          final customer = customers[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: customer.type == 'khach_quen'
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : AppColors.info.withValues(alpha: 0.1),
                child: Icon(
                  customer.type == 'khach_quen'
                      ? Icons.star
                      : Icons.person_outline,
                  color: customer.type == 'khach_quen'
                      ? AppColors.primary
                      : AppColors.info,
                ),
              ),
              title: Text(
                customer.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                customer.phone ?? 'Chưa có SĐT',
                style: TextStyle(
                  color: customer.phone != null
                      ? AppColors.textSecondary
                      : AppColors.textHint,
                ),
              ),
              trailing: customer.hasDebt
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          CurrencyFormatter.format(customer.totalDebt),
                          style: const TextStyle(
                            color: AppColors.debtActive,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Công nợ',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.debtActive,
                          ),
                        ),
                      ],
                    )
                  : const Icon(
                      Icons.check_circle_outline,
                      color: AppColors.success,
                    ),
              onTap: () => _showDebtBottomSheet(context, customer),
            ),
          );
        },
      ),
    );
  }

  void _showDebtBottomSheet(BuildContext context, Customer customer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        expand: false,
        builder: (context, scrollController) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  customer.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                if (customer.phone != null)
                  Text(
                    customer.phone!,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                const SizedBox(height: 16),
                // Debt summary card
                Card(
                  color: customer.hasDebt
                      ? AppColors.debtActive.withValues(alpha: 0.05)
                      : AppColors.success.withValues(alpha: 0.05),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tổng công nợ',
                            style: TextStyle(fontSize: 16)),
                        Text(
                          CurrencyFormatter.format(customer.totalDebt),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: customer.hasDebt
                                ? AppColors.debtActive
                                : AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // View debt history
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<CustomerBloc>(),
                            child: CustomerDebtPage(customer: customer),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.history, size: 18),
                    label: const Text('Xem lịch sử công nợ'),
                  ),
                ),
                const SizedBox(height: 12),
                if (customer.hasDebt) ...[
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _showPaymentDialog(context, customer);
                          },
                          icon: const Icon(Icons.payment),
                          label: const Text('Thanh toán'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _handleSettleAll(context, customer);
                          },
                          icon: const Icon(Icons.done_all),
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
                const SizedBox(height: 12),
                // Edit & Delete row
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _showEditCustomerDialog(context, customer);
                        },
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: const Text('Sửa'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          Navigator.pop(context);
                          final confirmed = await ConfirmDialog.show(
                            context,
                            title: 'Xóa khách hàng',
                            message: 'Bạn có chắc muốn xóa "${customer.name}"?',
                            confirmText: 'Xóa',
                            confirmColor: AppColors.error,
                          );
                          if (confirmed && context.mounted) {
                            context.read<CustomerBloc>().add(
                              CustomerEvent.deleteCustomer(customer.id),
                            );
                          }
                        },
                        icon: const Icon(Icons.delete_outline, size: 18,
                            color: AppColors.error),
                        label: const Text('Xóa',
                            style: TextStyle(color: AppColors.error)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.error),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddCustomerDialog(BuildContext context) {
    final nameCtl = TextEditingController();
    final phoneCtl = TextEditingController();
    String type = 'khach_le';
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('Thêm khách hàng'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameCtl,
                  decoration: const InputDecoration(
                    labelText: 'Tên khách hàng *',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: Validators.validateCustomerName,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: phoneCtl,
                  decoration: const InputDecoration(
                    labelText: 'Số điện thoại',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: Validators.validatePhone,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: type,
                  decoration: const InputDecoration(
                    labelText: 'Loại khách hàng',
                    prefixIcon: Icon(Icons.group_outlined),
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: 'khach_le', child: Text('Khách lẻ')),
                    DropdownMenuItem(
                        value: 'khach_quen', child: Text('Khách quen')),
                  ],
                  onChanged: (v) =>
                      setDialogState(() => type = v ?? type),
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
                final now = DateTime.now();
                String? userEmail;
                final authState = context.read<AuthBloc>().state;
                authState.mapOrNull(
                  authenticated: (auth) => userEmail = auth.user.email,
                );
                final customer = Customer(
                  id: '',
                  name: nameCtl.text.trim(),
                  phone: phoneCtl.text.trim().isNotEmpty
                      ? phoneCtl.text.trim()
                      : null,
                  type: type,
                  createdAt: now,
                  updatedAt: now,
                  updatedBy: userEmail,
                );
                context
                    .read<CustomerBloc>()
                    .add(CustomerEvent.addCustomer(customer));
                Navigator.pop(dialogContext);
              },
              child: const Text('Thêm'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditCustomerDialog(BuildContext context, Customer customer) {
    final nameCtl = TextEditingController(text: customer.name);
    final phoneCtl = TextEditingController(text: customer.phone ?? '');
    String type = customer.type;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('Sửa khách hàng'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameCtl,
                  decoration: const InputDecoration(
                    labelText: 'Tên khách hàng *',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: Validators.validateCustomerName,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: phoneCtl,
                  decoration: const InputDecoration(
                    labelText: 'Số điện thoại',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: Validators.validatePhone,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: type,
                  decoration: const InputDecoration(
                    labelText: 'Loại khách hàng',
                    prefixIcon: Icon(Icons.group_outlined),
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: 'khach_le', child: Text('Khách lẻ')),
                    DropdownMenuItem(
                        value: 'khach_quen', child: Text('Khách quen')),
                  ],
                  onChanged: (v) =>
                      setDialogState(() => type = v ?? type),
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
                final updated = Customer(
                  id: customer.id,
                  name: nameCtl.text.trim(),
                  phone: phoneCtl.text.trim().isNotEmpty
                      ? phoneCtl.text.trim()
                      : null,
                  type: type,
                  totalDebt: customer.totalDebt,
                  isActive: customer.isActive,
                  createdAt: customer.createdAt,
                  updatedAt: DateTime.now(),
                );
                context
                    .read<CustomerBloc>()
                    .add(CustomerEvent.updateCustomer(updated));
                Navigator.pop(dialogContext);
              },
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
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
              Text('Công nợ hiện tại: ${CurrencyFormatter.format(customer.totalDebt)}'),
              const SizedBox(height: 12),
              TextFormField(
                controller: amountCtl,
                decoration: const InputDecoration(
                  labelText: 'Số tiền thanh toán *',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: Validators.validatePrice,
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
    context.read<CustomerBloc>().add(
          CustomerEvent.settleAll(customer.id),
        );
  }
}
