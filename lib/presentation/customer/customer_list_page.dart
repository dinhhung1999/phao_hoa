import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_widget.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../core/utils/date_formatter.dart';
import '../../domain/entities/customer.dart';
import '../../domain/entities/debt_record.dart';
import '../auth/auth_bloc.dart';
import 'contact_picker_page.dart';
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
        onPressed: () => _showAddOptions(context),
        child: const Icon(Icons.person_add),
      ),
      body: BlocConsumer<CustomerBloc, CustomerState>(
        listenWhen: (prev, curr) => curr.maybeWhen(
          actionSuccess: (_) => true,
          orElse: () => false,
        ),
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
        buildWhen: (prev, curr) {
          // Only rebuild for states relevant to the customer list page
          return curr.maybeWhen(
            paginatedLoaded: (_, __, ___, ____, _____) => true,
            customersLoaded: (_) => true,
            initial: () => true,
            error: (_) => true,
            orElse: () => false,
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
            debtsLoaded: (_) => const SizedBox.shrink(),
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
    // Load debt records when opening
    context.read<CustomerBloc>().add(CustomerEvent.loadDebts(
      customerId: customer.id,
      customer: customer,
    ));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (sheetContext, scrollController) {
          return BlocBuilder<CustomerBloc, CustomerState>(
            bloc: context.read<CustomerBloc>(),
            builder: (_, state) {
              // Extract debt records if available
              List<DebtRecord>? records;
              state.mapOrNull(
                debtsLoaded: (loaded) {
                  records = loaded.records;
                },
              );

              return Padding(
                padding: const EdgeInsets.all(20),
                child: ListView(
                  controller: scrollController,
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
                      style: Theme.of(sheetContext).textTheme.titleLarge?.copyWith(
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

                    // ── Debt summary card with breakdown ──
                    _buildDebtSummaryCard(customer, records),
                    const SizedBox(height: 16),

                    // ── Recent history ──
                    if (records != null && records!.isNotEmpty) ...[
                      _buildRecentHistory(records!),
                      const SizedBox(height: 12),
                    ],

                    // View full history button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final bloc = context.read<CustomerBloc>();
                          final navigator = Navigator.of(context);
                          Navigator.pop(sheetContext);
                          await navigator.push(
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: bloc,
                                child: CustomerDebtPage(customer: customer),
                              ),
                            ),
                          );
                          // Reload customer list when returning from debt page
                          bloc.add(const CustomerEvent.loadCustomersPaginated());
                        },
                        icon: const Icon(Icons.history, size: 18),
                        label: const Text('Xem toàn bộ lịch sử'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (customer.hasDebt) ...[
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pop(sheetContext);
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
                                Navigator.pop(sheetContext);
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
                              Navigator.pop(sheetContext);
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
                              final bloc = this.context.read<CustomerBloc>();
                              final pageContext = this.context;
                              Navigator.pop(sheetContext);
                              if (!pageContext.mounted) return;
                              final confirmed = await ConfirmDialog.show(
                                pageContext,
                                title: 'Xóa khách hàng',
                                message: 'Bạn có chắc muốn xóa "${customer.name}"?',
                                confirmText: 'Xóa',
                                confirmColor: AppColors.error,
                              );
                              if (confirmed) {
                                bloc.add(
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
          );
        },
      ),
    );
  }

  /// Debt summary card with total debts, total paid, and current balance
  Widget _buildDebtSummaryCard(Customer customer, List<DebtRecord>? records) {
    double totalDebts = 0;
    double totalPaid = 0;

    if (records != null) {
      for (final r in records) {
        if (r.isDebt) {
          totalDebts += r.amount;
        } else {
          totalPaid += r.amount;
        }
      }
    }

    return Card(
      color: customer.hasDebt
          ? AppColors.debtActive.withValues(alpha: 0.05)
          : AppColors.success.withValues(alpha: 0.05),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Current balance - large
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
              customer.hasDebt ? 'Công nợ hiện tại' : 'Không có công nợ',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),

            // Breakdown row
            if (records != null && records.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_upward, size: 14,
                                color: AppColors.debtActive),
                            const SizedBox(width: 4),
                            const Text('Tổng ghi nợ',
                                style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          CurrencyFormatter.format(totalDebts),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: AppColors.debtActive,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: AppColors.divider,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_downward, size: 14,
                                color: AppColors.success),
                            const SizedBox(width: 4),
                            const Text('Đã thanh toán',
                                style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          CurrencyFormatter.format(totalPaid),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Recent debt/payment history (last 5 records)
  Widget _buildRecentHistory(List<DebtRecord> records) {
    final recent = records.length > 5 ? records.sublist(0, 5) : records;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Giao dịch gần đây',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            Text(
              '${records.length} bản ghi',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...recent.map((record) {
          final isDebt = record.isDebt;
          final color = isDebt ? AppColors.debtActive : AppColors.success;
          final prefix = isDebt ? '+' : '-';
          final label = isDebt ? 'Ghi nợ' : 'Thanh toán';

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                      Text(
                        DateFormatter.formatDateTime(record.createdAt),
                        style: const TextStyle(fontSize: 11, color: AppColors.textHint),
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
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: color,
                      ),
                    ),
                    Text(
                      'Dư: ${CurrencyFormatter.format(record.runningBalance)}',
                      style: const TextStyle(fontSize: 10, color: AppColors.textHint),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }


  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Thêm khách hàng',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: const Icon(Icons.edit_outlined, color: AppColors.primary),
                ),
                title: const Text('Nhập tay',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('Tự nhập tên, SĐT và loại khách hàng'),
                trailing: const Icon(Icons.chevron_right),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _showAddCustomerDialog(context);
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.info.withValues(alpha: 0.1),
                  child: const Icon(Icons.contacts_outlined, color: AppColors.info),
                ),
                title: const Text('Thêm từ danh bạ',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('Chọn một hoặc nhiều liên hệ từ điện thoại'),
                trailing: const Icon(Icons.chevron_right),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _importFromContacts(context);
                },
              ),
            ],
          ),
        ),
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
                  updatedBy: () {
                    String? email;
                    context.read<AuthBloc>().state.mapOrNull(
                      authenticated: (auth) => email = auth.user.email,
                    );
                    return email;
                  }(),
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

  Future<void> _handleSettleAll(BuildContext context, Customer customer) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Tất toán công nợ',
      message:
          'Bạn có chắc muốn tất toán toàn bộ công nợ của "${customer.name}"?\n\n'
          'Số tiền: ${CurrencyFormatter.format(customer.totalDebt)}',
      confirmText: 'Tất toán',
      confirmColor: AppColors.success,
    );
    if (confirmed && context.mounted) {
      context.read<CustomerBloc>().add(
            CustomerEvent.settleAll(customer.id),
          );
    }
  }

  /// Collect existing phone numbers and navigate to contact picker
  Future<void> _importFromContacts(BuildContext context) async {
    // Collect existing phone numbers from current state for duplicate detection
    final state = context.read<CustomerBloc>().state;
    final Set<String> existingPhones = {};

    state.mapOrNull(
      paginatedLoaded: (loaded) {
        for (final c in loaded.customers) {
          if (c.phone != null && c.phone!.isNotEmpty) {
            existingPhones.add(_normalizePhoneForCompare(c.phone!));
          }
        }
      },
      customersLoaded: (loaded) {
        for (final c in loaded.customers) {
          if (c.phone != null && c.phone!.isNotEmpty) {
            existingPhones.add(_normalizePhoneForCompare(c.phone!));
          }
        }
      },
    );

    if (!context.mounted) return;

    final result = await Navigator.of(context).push<List<Customer>>(
      MaterialPageRoute(
        builder: (_) => ContactPickerPage(existingPhones: existingPhones),
      ),
    );

    if (result != null && result.isNotEmpty && context.mounted) {
      // Inject updatedBy from auth
      String? userEmail;
      context.read<AuthBloc>().state.mapOrNull(
        authenticated: (auth) => userEmail = auth.user.email,
      );

      final customersWithAudit = result.map((c) => Customer(
        id: c.id,
        name: c.name,
        phone: c.phone,
        type: c.type,
        createdAt: c.createdAt,
        updatedAt: c.updatedAt,
        updatedBy: userEmail,
      )).toList();

      context.read<CustomerBloc>().add(
        CustomerEvent.addMultipleCustomers(customersWithAudit),
      );
    }
  }

  /// Normalize phone for comparison
  String _normalizePhoneForCompare(String phone) {
    String normalized = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (normalized.startsWith('+84')) {
      normalized = '0${normalized.substring(3)}';
    }
    return normalized;
  }
}
