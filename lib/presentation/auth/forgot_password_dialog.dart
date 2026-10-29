import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/validators.dart';
import 'auth_bloc.dart';

class ForgotPasswordDialog extends StatefulWidget {
  final String initialEmail;

  const ForgotPasswordDialog({super.key, this.initialEmail = ''});

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  bool _isSending = false;
  bool _emailSent = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSending = true;
      _errorMessage = null;
    });

    try {
      final result = await context.read<AuthBloc>().sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      if (!mounted) return;
      result.fold(
        (failure) => setState(() => _errorMessage = failure.message),
        (_) => setState(() => _emailSent = true),
      );
    } catch (_) {
      if (mounted) {
        setState(
          () => _errorMessage = 'Không gửi được email. Vui lòng thử lại.',
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_emailSent ? 'Kiểm tra email của bạn' : 'Quên mật khẩu'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: _emailSent ? _buildSuccessMessage(context) : _buildForm(context),
      ),
      actions: _emailSent
          ? [
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Đóng'),
              ),
            ]
          : [
              TextButton(
                onPressed: _isSending
                    ? null
                    : () => Navigator.of(context).pop(),
                child: const Text('Hủy'),
              ),
              FilledButton.icon(
                onPressed: _isSending ? null : _sendResetEmail,
                icon: _isSending
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.mail_outline),
                label: Text(_isSending ? 'Đang gửi...' : 'Gửi email'),
              ),
            ],
    );
  }

  Widget _buildForm(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nhập email đăng ký. Nếu email thuộc tài khoản hợp lệ, '
              'hướng dẫn đặt lại mật khẩu sẽ được gửi đến đó.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: Validators.validateEmail,
              onFieldSubmitted: (_) {
                if (!_isSending) _sendResetEmail();
              },
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.error),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessMessage(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.mark_email_read_outlined, color: AppColors.success),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Nếu email thuộc tài khoản đã đăng ký, hướng dẫn đặt lại mật khẩu '
            'sẽ được gửi đến ${_emailController.text.trim()}.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
