import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/data_reset_service.dart';
import '../../core/services/notification_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../injection_container.dart';
import '../auth/auth_bloc.dart';
import '../warehouse/warehouse_bloc.dart';
import '../warehouse/warehouse_list_page.dart';

/// Settings page — accessed from home page app bar
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _reminderHour = 20;
  int _reminderMinute = 0;
  bool _reminderEnabled = true;
  bool _isResetting = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  static const _prefKeyHour = 'reminder_hour';
  static const _prefKeyMinute = 'reminder_minute';
  static const _prefKeyEnabled = 'reminder_enabled';

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _reminderHour = prefs.getInt(_prefKeyHour) ?? 20;
      _reminderMinute = prefs.getInt(_prefKeyMinute) ?? 0;
      _reminderEnabled = prefs.getBool(_prefKeyEnabled) ?? true;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKeyHour, _reminderHour);
    await prefs.setInt(_prefKeyMinute, _reminderMinute);
    await prefs.setBool(_prefKeyEnabled, _reminderEnabled);

    final notificationService = NotificationService();
    if (_reminderEnabled) {
      await notificationService.scheduleDailyReminder(
        hour: _reminderHour,
        minute: _reminderMinute,
      );
    } else {
      await notificationService.cancelDailyReminder();
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã lưu cài đặt'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }



  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _reminderHour, minute: _reminderMinute),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() {
        _reminderHour = time.hour;
        _reminderMinute = time.minute;
      });
      await _saveSettings();
    }
  }

  Future<void> _handleLogout() async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Đăng xuất',
      message: 'Bạn có chắc muốn đăng xuất khỏi ứng dụng?',
      confirmText: 'Đăng xuất',
      confirmColor: AppColors.error,
    );
    if (confirmed && mounted) {
      context.read<AuthBloc>().add(const AuthEvent.signOut());
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }


  Future<void> _handleSelectiveReset() async {
    final selectedTypes = await showDialog<Set<DataResetType>>(
      context: context,
      builder: (ctx) => _SelectiveResetDialog(),
    );

    if (selectedTypes == null || selectedTypes.isEmpty || !mounted) return;

    // Show warnings if applicable
    final warnings = DataResetWarning.getWarnings(selectedTypes);
    if (warnings.isNotEmpty) {
      final proceed = await ConfirmDialog.show(
        context,
        title: '⚠️ Cảnh báo',
        message: '${warnings.join('\n\n')}\n\nBạn vẫn muốn tiếp tục?',
        confirmText: 'Tiếp tục',
        confirmColor: AppColors.warning,
      );
      if (!proceed || !mounted) return;
    }

    // Type confirmation
    final labels = selectedTypes.map((t) => t.label).join(', ');
    final typedOk = await _showTypeConfirmDialog('xoá: $labels');
    if (!typedOk || !mounted) return;

    // Perform selective reset
    setState(() => _isResetting = true);
    try {
      final service = DataResetService();
      final results = await service.resetSelectiveData(selectedTypes);
      final totalDeleted = results.values.fold(0, (a, b) => a + b);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã xoá $totalDeleted bản ghi thành công.'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi xoá dữ liệu: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isResetting = false);
    }
  }

  /// Shows a text confirmation dialog requiring user to type "XOA"
  Future<bool> _showTypeConfirmDialog(String action) async {
    final confirmText = await showDialog<String>(
      context: context,
      builder: (ctx) {
        final ctl = TextEditingController();
        return AlertDialog(
          title: const Text('Xác nhận lần cuối'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nhập "XOA" để xác nhận $action:'),
              const SizedBox(height: 12),
              TextField(
                controller: ctl,
                autofocus: true,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  hintText: 'XOA',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Huỷ'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, ctl.text.trim()),
              style: FilledButton.styleFrom(backgroundColor: AppColors.error),
              child: const Text('Xoá'),
            ),
          ],
        );
      },
    );

    if (confirmText != 'XOA' && mounted) {
      if (confirmText != null && confirmText != 'XOA') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nhập sai. Hãy nhập đúng "XOA" để xác nhận.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final timeStr =
        '${_reminderHour.toString().padLeft(2, '0')}:${_reminderMinute.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Account Section ──
            Text('Tài khoản',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
            const SizedBox(height: 8),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return state.maybeMap(
                  authenticated: (auth) {
                    final user = auth.user;
                    final initial = (user.displayName ?? user.email)
                        .substring(0, 1)
                        .toUpperCase();
                    return Card(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor:
                                      AppColors.primary.withValues(alpha: 0.15),
                                  child: Text(
                                    initial,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (user.displayName != null &&
                                          user.displayName!.isNotEmpty)
                                        Text(
                                          user.displayName!,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      Text(
                                        user.email,
                                        style: TextStyle(
                                          color: user.displayName != null
                                              ? AppColors.textSecondary
                                              : AppColors.textPrimary,
                                          fontSize: user.displayName != null
                                              ? 13
                                              : 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.success
                                        .withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.check_circle,
                                          size: 12, color: AppColors.success),
                                      SizedBox(width: 4),
                                      Text(
                                        'Online',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: AppColors.success,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 1),
                          ListTile(
                            leading: const Icon(Icons.logout,
                                color: AppColors.error),
                            title: const Text('Đăng xuất',
                                style: TextStyle(color: AppColors.error)),
                            onTap: _handleLogout,
                          ),
                        ],
                      ),
                    );
                  },
                  orElse: () => const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Chưa đăng nhập'),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // ── Warehouse Management Section ──
            Text('Kho hàng',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.warehouse_outlined),
                title: const Text('Quản lý kho hàng'),
                subtitle: const Text(
                  'Thêm, sửa, xóa kho hàng và thông tin chi tiết',
                  style: TextStyle(fontSize: 12),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) => sl<WarehouseBloc>(),
                        child: const WarehouseListPage(),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // ── Notification section ──
            Text('Thông báo',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Nhắc nhở báo cáo hàng ngày'),
                    subtitle: const Text(
                      'Nhận thông báo nhắc nhở tổng kết giao dịch cuối ngày',
                    ),
                    value: _reminderEnabled,
                    onChanged: (v) async {
                      setState(() => _reminderEnabled = v);
                      await _saveSettings();
                    },
                    secondary: const Icon(Icons.notifications_outlined),
                  ),
                  if (_reminderEnabled) ...[
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.access_time),
                      title: const Text('Giờ nhắc nhở'),
                      subtitle: Text('Nhắc nhở lúc $timeStr mỗi ngày'),
                      trailing: FilledButton.tonal(
                        onPressed: _pickTime,
                        child: Text(timeStr,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 8),
            if (_reminderEnabled)
              OutlinedButton.icon(
                onPressed: () async {
                  await NotificationService().showTestNotification();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đã gửi thông báo thử'),
                    ),
                  );
                },
                icon: const Icon(Icons.send_outlined, size: 18),
                label: const Text('Gửi thông báo thử'),
              ),

            const SizedBox(height: 32),

            // ── Data Management section ──
            Text('Dữ liệu',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.cleaning_services_outlined,
                      color: AppColors.warning,
                    ),
                    title: const Text(
                      'Xoá dữ liệu chọn lọc',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: const Text(
                      'Chọn từng loại dữ liệu muốn xoá',
                      style: TextStyle(fontSize: 12),
                    ),
                    trailing: _isResetting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.chevron_right),
                    onTap: _isResetting ? null : _handleSelectiveReset,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── App info ──
            Text('Thông tin ứng dụng',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text('Phiên bản'),
                    trailing: Text('1.0.0'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.description_outlined),
                    title: const Text('Ứng dụng'),
                    subtitle: const Text(
                      'Quản lý kho hàng pháo hoa — Theo dõi nhập xuất, công nợ, tồn kho',
                    ),
                    isThreeLine: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dialog with checkboxes for selecting which data types to reset
class _SelectiveResetDialog extends StatefulWidget {
  @override
  State<_SelectiveResetDialog> createState() => _SelectiveResetDialogState();
}

class _SelectiveResetDialogState extends State<_SelectiveResetDialog> {
  final Set<DataResetType> _selected = {};

  static const _icons = {
    DataResetType.products: Icons.inventory_2_outlined,
    DataResetType.inventory: Icons.store_outlined,
    DataResetType.transactions: Icons.receipt_long_outlined,
    DataResetType.customers: Icons.people_outline,
    DataResetType.checklists: Icons.checklist_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final warnings = DataResetWarning.getWarnings(_selected);

    return AlertDialog(
      title: const Text('Chọn dữ liệu muốn xoá'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...DataResetType.values.map((type) => CheckboxListTile(
              value: _selected.contains(type),
              onChanged: (v) {
                setState(() {
                  if (v == true) {
                    _selected.add(type);
                  } else {
                    _selected.remove(type);
                  }
                });
              },
              title: Text(type.label),
              secondary: Icon(
                _icons[type] ?? Icons.data_object,
                color: _selected.contains(type)
                    ? AppColors.error
                    : AppColors.textSecondary,
              ),
              activeColor: AppColors.error,
              dense: true,
              controlAffinity: ListTileControlAffinity.trailing,
            )),
            if (warnings.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        size: 18, color: AppColors.warning),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        warnings.join('\n'),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.warning,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Huỷ'),
        ),
        FilledButton(
          onPressed: _selected.isEmpty
              ? null
              : () => Navigator.pop(context, _selected),
          style: FilledButton.styleFrom(backgroundColor: AppColors.error),
          child: Text('Xoá ${_selected.length} loại'),
        ),
      ],
    );
  }
}
