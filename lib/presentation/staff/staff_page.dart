import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/constants/firestore_paths.dart';
import '../../core/services/staff_service.dart';
import '../../core/utils/currency_formatter.dart';

class StaffPage extends StatefulWidget {
  const StaffPage({super.key});

  @override
  State<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  final _service = StaffService();
  int _days = 30;
  bool _showInactive = false;
  Future<_SalesReport>? _salesFuture;

  @override
  void initState() {
    super.initState();
    _salesFuture = _loadSales(_days);
  }

  void _refreshSales({int? days}) {
    final selectedDays = days ?? _days;
    final nextSales = _loadSales(selectedDays);
    setState(() {
      _days = selectedDays;
      _salesFuture = nextSales;
    });
  }

  Future<_SalesReport> _loadSales(int days) async {
    final accessControl = await _service.accessControl.get();
    final accessData = accessControl.data();
    final owners = StaffService.ownerUids(accessData);
    final configuredOwnerEmails = <String, String>{};
    final emailMap = accessData?['owner_emails'];
    if (emailMap is Map) {
      for (final entry in emailMap.entries) {
        if (entry.key is String && entry.value is String) {
          configuredOwnerEmails[entry.key as String] = (entry.value as String)
              .trim()
              .toLowerCase();
        }
      }
    }
    final start = DateTime.now().subtract(Duration(days: days));
    final snapshot = await FirebaseFirestore.instance
        .collection(FirestorePaths.transactions)
        .where('created_at', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .get();
    final totals = <String, _Sales>{};
    final emailsByUid = <String, String>{};
    var allSales = const _Sales();
    for (final doc in snapshot.docs) {
      final data = doc.data();
      if (data['type'] != 'xuat') continue;
      final uid = (data['created_by_uid'] as String? ?? '').trim();
      final email = (data['created_by'] as String? ?? '').trim().toLowerCase();
      if (uid.isNotEmpty && email.isNotEmpty) emailsByUid[uid] = email;
      final key = uid.isNotEmpty ? 'uid:$uid' : 'email:$email';
      final order = _Sales(
        count: 1,
        revenue: (data['total_value'] as num?)?.toDouble() ?? 0,
      );
      allSales = allSales.plus(order);
      if (key != 'email:') {
        totals[key] = (totals[key] ?? const _Sales()).plus(order);
      }
    }
    return _SalesReport(
      owners: owners,
      configuredOwnerEmails: configuredOwnerEmails,
      byCreator: totals,
      emailsByUid: emailsByUid,
      total: allSales,
    );
  }

  Future<void> _create() async {
    final result = await showDialog<_StaffInput>(
      context: context,
      builder: (_) => const _StaffDialog(),
    );
    if (result == null || !mounted) return;
    try {
      await _service.createStaff(
        name: result.name,
        email: result.email,
        password: result.password,
      );
      _message('Đã tạo tài khoản nhân viên.');
    } catch (error) {
      _message(_errorText(error));
    }
  }

  Future<void> _rename(StaffMember member) async {
    final result = await showDialog<_StaffInput>(
      context: context,
      builder: (_) => _StaffDialog(member: member),
    );
    if (result == null || !mounted) return;
    try {
      await _service.updateName(member, result.name);
      _message('Đã cập nhật tên nhân viên.');
    } catch (error) {
      _message(_errorText(error));
    }
  }

  Future<void> _setActive(StaffMember member) async {
    final active = !member.active;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(active ? 'Mở lại tài khoản?' : 'Xóa nhân viên?'),
        content: Text(
          active
              ? 'Nhân viên ${member.name} sẽ được truy cập lại ứng dụng.'
              : 'Tài khoản ${member.email} sẽ bị khóa quyền truy cập ngay. Lịch sử giao dịch được giữ lại.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(active ? 'Mở lại' : 'Khóa quyền'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await _service.setActive(member, active);
      _message(active ? 'Đã mở lại tài khoản.' : 'Đã khóa quyền truy cập.');
    } catch (error) {
      _message(_errorText(error));
    }
  }

  Future<void> _resetPassword(StaffMember member) async {
    try {
      await _service.sendPasswordReset(member);
      _message('Đã gửi email đặt lại mật khẩu tới ${member.email}.');
    } catch (error) {
      _message(_errorText(error));
    }
  }

  void _message(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _errorText(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return 'Email này đã có tài khoản.';
        case 'invalid-email':
          return 'Email không hợp lệ.';
        case 'weak-password':
          return 'Mật khẩu cần ít nhất 6 ký tự.';
      }
    }
    if (error is FirebaseException && error.code == 'permission-denied') {
      return 'Không có quyền thực hiện. Kiểm tra cấu hình quyền chủ cửa hàng.';
    }
    return 'Không thực hiện được: $error';
  }

  Widget _summaryMetric(BuildContext context, String label, _Sales sales) {
    return SizedBox(
      width: 205,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 4),
          Text(
            CurrencyFormatter.format(sales.revenue),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text('${sales.count} phiếu xuất'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nhân viên & doanh số')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child: StreamBuilder<List<StaffMember>>(
            stream: _service.watchStaff(),
            builder: (context, staffSnapshot) {
              if (staffSnapshot.hasError) {
                return Center(
                  child: Text(
                    'Không tải được danh sách: ${staffSnapshot.error}',
                  ),
                );
              }
              if (!staffSnapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              final staff = staffSnapshot.data!;
              return FutureBuilder<_SalesReport>(
                future: _salesFuture,
                builder: (context, salesSnapshot) {
                  final report = salesSnapshot.data;
                  final managedStaff = report == null
                      ? staff
                      : staff
                            .where(
                              (member) => !report.owners.contains(member.uid),
                            )
                            .toList();
                  final visibleStaff = _showInactive
                      ? managedStaff
                      : managedStaff.where((member) => member.active).toList();
                  var ownerTotal = const _Sales();
                  var staffTotal = const _Sales();
                  if (report != null) {
                    for (final uid in report.owners) {
                      ownerTotal = ownerTotal.plus(
                        report.forAccount(uid, report.ownerEmail(uid, staff)),
                      );
                    }
                    for (final member in managedStaff) {
                      staffTotal = staffTotal.plus(
                        report.forAccount(member.uid, member.email),
                      );
                    }
                  }
                  final unattributed = report == null
                      ? const _Sales()
                      : report.total.minus(ownerTotal.plus(staffTotal));
                  return ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Quản lý nhân viên',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                              Text(
                                '${managedStaff.where((s) => s.active).length} đang hoạt động / ${managedStaff.length} tài khoản',
                              ),
                            ],
                          ),
                          FilledButton.icon(
                            onPressed: _create,
                            icon: const Icon(Icons.person_add_alt_1),
                            label: const Text('Thêm nhân viên'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          SegmentedButton<int>(
                            segments: const [
                              ButtonSegment(value: 7, label: Text('7 ngày')),
                              ButtonSegment(value: 30, label: Text('30 ngày')),
                              ButtonSegment(value: 90, label: Text('90 ngày')),
                            ],
                            selected: {_days},
                            onSelectionChanged: (value) {
                              _refreshSales(days: value.first);
                            },
                          ),
                          IconButton(
                            onPressed: _refreshSales,
                            tooltip: 'Làm mới doanh số',
                            icon: const Icon(Icons.refresh),
                          ),
                          FilterChip(
                            label: const Text('Hiện tài khoản đã khóa'),
                            selected: _showInactive,
                            onSelected: (value) => setState(() {
                              _showInactive = value;
                            }),
                          ),
                        ],
                      ),
                      if (salesSnapshot.connectionState ==
                          ConnectionState.waiting)
                        const LinearProgressIndicator(),
                      if (salesSnapshot.hasError)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'Không tải được doanh số: ${salesSnapshot.error}',
                          ),
                        ),
                      if (report != null) ...[
                        const SizedBox(height: 20),
                        Text(
                          'Doanh số toàn cửa hàng',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Wrap(
                              spacing: 24,
                              runSpacing: 16,
                              children: [
                                _summaryMetric(
                                  context,
                                  'Tổng cộng',
                                  report.total,
                                ),
                                _summaryMetric(
                                  context,
                                  'Chủ cửa hàng',
                                  ownerTotal,
                                ),
                                _summaryMetric(
                                  context,
                                  'Nhân viên',
                                  staffTotal,
                                ),
                                if (unattributed.count > 0)
                                  _summaryMetric(
                                    context,
                                    'Chưa xác định',
                                    unattributed,
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Chủ cửa hàng',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        ...report.owners.map((uid) {
                          final email = report.ownerEmail(uid, staff);
                          final metric = report.forAccount(uid, email);
                          return Card(
                            child: ListTile(
                              leading: const Icon(
                                Icons.admin_panel_settings_outlined,
                              ),
                              title: Text(
                                email ??
                                    'Chủ cửa hàng (${uid.length > 8 ? uid.substring(0, 8) : uid})',
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                '${metric.count} phiếu xuất trong $_days ngày · ${CurrencyFormatter.format(metric.revenue)}',
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 20),
                        Text(
                          'Nhân viên',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                      const SizedBox(height: 12),
                      if (visibleStaff.isEmpty)
                        const Card(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Text(
                              'Chưa có nhân viên đang hoạt động. Chọn “Thêm nhân viên” hoặc hiện tài khoản đã khóa.',
                            ),
                          ),
                        ),
                      ...visibleStaff.map((member) {
                        final metric =
                            report?.forAccount(member.uid, member.email) ??
                            const _Sales();
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Wrap(
                              spacing: 16,
                              runSpacing: 12,
                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                SizedBox(
                                  width: 260,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        member.name,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium,
                                      ),
                                      Text(member.email),
                                      Text(
                                        member.active
                                            ? 'Đang hoạt động'
                                            : 'Đã khóa',
                                        style: TextStyle(
                                          color: member.active
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (salesSnapshot.hasData) ...[
                                      Text(
                                        'Doanh số: ${CurrencyFormatter.format(metric.revenue)}',
                                      ),
                                      Text(
                                        '${metric.count} phiếu xuất trong $_days ngày',
                                      ),
                                    ] else
                                      Text(
                                        salesSnapshot.hasError
                                            ? 'Doanh số chưa khả dụng'
                                            : 'Đang tải doanh số…',
                                      ),
                                  ],
                                ),
                                PopupMenuButton<String>(
                                  tooltip: 'Quản lý ${member.name}',
                                  onSelected: (value) {
                                    if (value == 'edit') _rename(member);
                                    if (value == 'reset') {
                                      _resetPassword(member);
                                    }
                                    if (value == 'active') _setActive(member);
                                  },
                                  itemBuilder: (_) => [
                                    const PopupMenuItem(
                                      value: 'edit',
                                      child: Text('Sửa tên'),
                                    ),
                                    const PopupMenuItem(
                                      value: 'reset',
                                      child: Text('Gửi email đổi mật khẩu'),
                                    ),
                                    PopupMenuItem(
                                      value: 'active',
                                      child: Text(
                                        member.active
                                            ? 'Xóa / khóa quyền'
                                            : 'Mở lại tài khoản',
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
                      const Text(
                        'Doanh số tính theo tổng giá trị phiếu xuất và người tạo; phiếu cũ giữ nguyên khi khóa nhân viên.',
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Sales {
  final int count;
  final double revenue;
  const _Sales({this.count = 0, this.revenue = 0});

  _Sales plus(_Sales other) =>
      _Sales(count: count + other.count, revenue: revenue + other.revenue);

  _Sales minus(_Sales other) =>
      _Sales(count: count - other.count, revenue: revenue - other.revenue);
}

class _SalesReport {
  final List<String> owners;
  final Map<String, String> configuredOwnerEmails;
  final Map<String, _Sales> byCreator;
  final Map<String, String> emailsByUid;
  final _Sales total;

  const _SalesReport({
    required this.owners,
    required this.configuredOwnerEmails,
    required this.byCreator,
    required this.emailsByUid,
    required this.total,
  });

  String? ownerEmail(String uid, List<StaffMember> profiles) {
    final signedIn = FirebaseAuth.instance.currentUser;
    if (signedIn?.uid == uid && signedIn?.email != null) {
      return signedIn!.email;
    }
    final configuredEmail = configuredOwnerEmails[uid];
    if (configuredEmail != null && configuredEmail.isNotEmpty) {
      return configuredEmail;
    }
    for (final profile in profiles) {
      if (profile.uid == uid && profile.email.isNotEmpty) {
        return profile.email;
      }
    }
    return emailsByUid[uid];
  }

  _Sales forAccount(String uid, String? email) {
    final byUid = byCreator['uid:$uid'] ?? const _Sales();
    final byEmail = email == null
        ? const _Sales()
        : byCreator['email:${email.toLowerCase()}'] ?? const _Sales();
    return byUid.plus(byEmail);
  }
}

class _StaffInput {
  final String name;
  final String email;
  final String password;
  const _StaffInput(this.name, this.email, this.password);
}

class _StaffDialog extends StatefulWidget {
  final StaffMember? member;
  const _StaffDialog({this.member});

  @override
  State<_StaffDialog> createState() => _StaffDialogState();
}

class _StaffDialogState extends State<_StaffDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.member?.name);
  late final _email = TextEditingController(text: widget.member?.email);
  final _password = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.member != null;
    return AlertDialog(
      title: Text(editing ? 'Sửa nhân viên' : 'Thêm nhân viên'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _name,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Họ tên'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Nhập họ tên'
                    : null,
              ),
              if (!editing) ...[
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) =>
                      value == null ||
                          !RegExp(
                            r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                          ).hasMatch(value.trim())
                      ? 'Email không hợp lệ'
                      : null,
                ),
                TextFormField(
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Mật khẩu ban đầu',
                  ),
                  validator: (value) => value == null || value.length < 6
                      ? 'Ít nhất 6 ký tự'
                      : null,
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(
                context,
                _StaffInput(
                  _name.text.trim(),
                  _email.text.trim(),
                  _password.text,
                ),
              );
            }
          },
          child: Text(editing ? 'Lưu' : 'Tạo tài khoản'),
        ),
      ],
    );
  }
}
