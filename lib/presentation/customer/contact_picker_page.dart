import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/customer.dart';

/// Page to pick contacts from phone's contact list and import as customers.
/// Supports multi-select, search, duplicate detection, and customer type selection.
class ContactPickerPage extends StatefulWidget {
  /// Existing customer phone numbers — used to detect duplicates
  final Set<String> existingPhones;

  const ContactPickerPage({
    super.key,
    required this.existingPhones,
  });

  @override
  State<ContactPickerPage> createState() => _ContactPickerPageState();
}

class _ContactPickerPageState extends State<ContactPickerPage> {
  List<Contact> _contacts = [];
  bool _isLoading = true;
  bool _permissionDenied = false;
  String? _errorMessage;
  String _searchQuery = '';
  final Set<int> _selectedIndices = {};
  String _customerType = 'khach_le';

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _permissionDenied = false;
    });

    try {
      final hasPermission = await FlutterContacts.requestPermission(readonly: true);
      if (!hasPermission) {
        setState(() {
          _permissionDenied = true;
          _isLoading = false;
        });
        return;
      }

      final contacts = await FlutterContacts.getContacts(
        withProperties: true,
        sorted: true,
      );

      if (!mounted) return;
      setState(() {
        _contacts = contacts;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Không thể tải danh bạ: $e';
        _isLoading = false;
      });
    }
  }

  /// Normalize phone number for comparison (remove spaces, dashes, +84 prefix)
  String _normalizePhone(String phone) {
    String normalized = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    // Convert +84 to 0 for comparison
    if (normalized.startsWith('+84')) {
      normalized = '0${normalized.substring(3)}';
    }
    return normalized;
  }

  /// Check if a contact's phone already exists in the customer list
  bool _isDuplicate(Contact contact) {
    for (final phone in contact.phones) {
      final normalized = _normalizePhone(phone.number);
      if (widget.existingPhones.contains(normalized)) {
        return true;
      }
    }
    return false;
  }

  /// Get display phone number for a contact
  String? _getPhoneNumber(Contact contact) {
    if (contact.phones.isEmpty) return null;
    return contact.phones.first.number;
  }

  List<Contact> get _filteredContacts {
    if (_searchQuery.isEmpty) return _contacts;
    final q = _searchQuery.toLowerCase();
    return _contacts.where((c) {
      final nameMatch = c.displayName.toLowerCase().contains(q);
      final phoneMatch = c.phones.any((p) => p.number.contains(q));
      return nameMatch || phoneMatch;
    }).toList();
  }

  void _toggleSelection(int originalIndex) {
    setState(() {
      if (_selectedIndices.contains(originalIndex)) {
        _selectedIndices.remove(originalIndex);
      } else {
        _selectedIndices.add(originalIndex);
      }
    });
  }

  void _selectAll() {
    final filtered = _filteredContacts;
    setState(() {
      for (int i = 0; i < _contacts.length; i++) {
        final contact = _contacts[i];
        if (filtered.contains(contact) &&
            !_isDuplicate(contact) &&
            contact.phones.isNotEmpty) {
          _selectedIndices.add(i);
        }
      }
    });
  }

  void _deselectAll() {
    setState(() => _selectedIndices.clear());
  }

  void _confirmImport() {
    final now = DateTime.now();
    final customers = _selectedIndices.map((index) {
      final contact = _contacts[index];
      final phone = _getPhoneNumber(contact);
      return Customer(
        id: '',
        name: contact.displayName,
        phone: phone != null ? _normalizePhone(phone) : null,
        type: _customerType,
        createdAt: now,
        updatedAt: now,
      );
    }).toList();

    Navigator.pop(context, customers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn từ danh bạ'),
        actions: [
          if (_selectedIndices.isNotEmpty)
            TextButton.icon(
              onPressed: _deselectAll,
              icon: const Icon(Icons.deselect, size: 18),
              label: const Text('Bỏ chọn'),
            ),
          if (!_isLoading && !_permissionDenied && _contacts.isNotEmpty)
            TextButton.icon(
              onPressed: _selectAll,
              icon: const Icon(Icons.select_all, size: 18),
              label: const Text('Chọn tất cả'),
            ),
        ],
      ),
      bottomNavigationBar: _selectedIndices.isNotEmpty
          ? _buildBottomBar()
          : null,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : _errorMessage != null
              ? _buildError()
              : _permissionDenied
                  ? _buildPermissionDenied()
                  : _contacts.isEmpty
                      ? _buildEmptyState()
                      : _buildContactList(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 72, color: AppColors.error),
            const SizedBox(height: 16),
            const Text(
              'Có lỗi xảy ra',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? '',
              style: const TextStyle(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: _loadContacts,
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionDenied() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.contacts_outlined, size: 72,
                color: AppColors.textHint),
            const SizedBox(height: 16),
            const Text(
              'Chưa cấp quyền truy cập danh bạ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Vui lòng cấp quyền truy cập danh bạ để sử dụng tính năng này.',
              style: TextStyle(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: _loadContacts,
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_off_outlined, size: 64, color: AppColors.textHint),
          SizedBox(height: 12),
          Text('Danh bạ trống',
              style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildContactList() {
    final filtered = _filteredContacts;

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Tìm trong danh bạ...',
              prefixIcon: const Icon(Icons.search, size: 20),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () =>
                          setState(() => _searchQuery = ''),
                    )
                  : null,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withValues(alpha: 0.5),
            ),
            onChanged: (v) => setState(() => _searchQuery = v),
          ),
        ),

        // Info chip
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Text(
                '${filtered.length} liên hệ',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              if (_selectedIndices.isNotEmpty) ...[
                const Text(' • ',
                    style: TextStyle(color: AppColors.textHint)),
                Text(
                  '${_selectedIndices.length} đã chọn',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),

        // Contact list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final contact = filtered[index];
              final originalIndex = _contacts.indexOf(contact);
              final phone = _getPhoneNumber(contact);
              final isDuplicate = _isDuplicate(contact);
              final hasPhone = contact.phones.isNotEmpty;
              final isSelectable = !isDuplicate && hasPhone;
              final isSelected = _selectedIndices.contains(originalIndex);

              return _ContactTile(
                contact: contact,
                phone: phone,
                isDuplicate: isDuplicate,
                hasPhone: hasPhone,
                isSelected: isSelected,
                isSelectable: isSelectable,
                onTap: isSelectable
                    ? () => _toggleSelection(originalIndex)
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Customer type selector
              Row(
                children: [
                  const Text('Loại khách hàng: ',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                          value: 'khach_le',
                          label: Text('Khách lẻ'),
                          icon: Icon(Icons.person_outline, size: 18),
                        ),
                        ButtonSegment(
                          value: 'khach_quen',
                          label: Text('Khách quen'),
                          icon: Icon(Icons.star_outline, size: 18),
                        ),
                      ],
                      selected: {_customerType},
                      onSelectionChanged: (selected) {
                        setState(() => _customerType = selected.first);
                      },
                      style: SegmentedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Import button
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _confirmImport,
                  icon: const Icon(Icons.person_add),
                  label: Text(
                    'Thêm ${_selectedIndices.length} khách hàng',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
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

/// Individual contact tile widget
class _ContactTile extends StatelessWidget {
  final Contact contact;
  final String? phone;
  final bool isDuplicate;
  final bool hasPhone;
  final bool isSelected;
  final bool isSelectable;
  final VoidCallback? onTap;

  const _ContactTile({
    required this.contact,
    this.phone,
    required this.isDuplicate,
    required this.hasPhone,
    required this.isSelected,
    required this.isSelectable,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 2 : 0,
      color: isSelected
          ? AppColors.primary.withValues(alpha: 0.08)
          : isDuplicate
              ? Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withValues(alpha: 0.3)
              : null,
      child: ListTile(
        enabled: isSelectable,
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: isSelected
              ? AppColors.primary.withValues(alpha: 0.15)
              : isDuplicate
                  ? AppColors.textHint.withValues(alpha: 0.15)
                  : AppColors.info.withValues(alpha: 0.1),
          child: isSelected
              ? const Icon(Icons.check, color: AppColors.primary)
              : Text(
                  contact.displayName.isNotEmpty
                      ? contact.displayName[0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    color: isDuplicate ? AppColors.textHint : AppColors.info,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        title: Text(
          contact.displayName,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDuplicate ? AppColors.textHint : null,
          ),
        ),
        subtitle: Row(
          children: [
            if (phone != null)
              Flexible(
                child: Text(
                  phone!,
                  style: TextStyle(
                    color: isDuplicate
                        ? AppColors.textHint
                        : AppColors.textSecondary,
                  ),
                ),
              )
            else
              const Text(
                'Không có SĐT',
                style: TextStyle(color: AppColors.textHint, fontSize: 12),
              ),
            if (isDuplicate) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Đã tồn tại',
                  style: TextStyle(
                    color: AppColors.warning,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        trailing: isSelectable
            ? Checkbox(
                value: isSelected,
                onChanged: (_) => onTap?.call(),
              )
            : isDuplicate
                ? const Icon(Icons.check_circle, color: AppColors.success,
                    size: 20)
                : null,
      ),
    );
  }
}
