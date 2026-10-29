import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/services/staff_service.dart';
import 'auth_bloc.dart';

/// Firestore-backed access check shared by all authenticated pages.
class AccessGate extends StatelessWidget {
  final Widget child;
  final bool ownerOnly;

  const AccessGate({super.key, required this.child, this.ownerOnly = false});

  @override
  Widget build(BuildContext context) {
    final uid = context.read<AuthBloc>().state.maybeMap(
      authenticated: (state) => state.user.uid,
      orElse: () => '',
    );
    if (uid.isEmpty) return const _AccessMessage('Vui lòng đăng nhập.');
    final service = StaffService();
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: service.accessControl.snapshots(),
      builder: (context, accessSnapshot) {
        if (accessSnapshot.hasError) {
          return _AccessMessage(
            'Không kiểm tra được quyền truy cập: ${accessSnapshot.error}',
          );
        }
        if (!accessSnapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          );
        }
        final owners = StaffService.ownerUids(accessSnapshot.data!.data());
        if (owners.isEmpty) {
          return const _AccessMessage(
            'Chưa cấu hình tài khoản chủ cửa hàng. Xem hướng dẫn trong dự án.',
          );
        }
        if (owners.contains(uid)) return child;
        if (ownerOnly) {
          return const _AccessMessage('Chỉ chủ cửa hàng được xem trang này.');
        }
        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: service.profiles.doc(uid).snapshots(),
          builder: (context, staffSnapshot) {
            if (staffSnapshot.hasError) {
              return _AccessMessage(
                'Không kiểm tra được tài khoản nhân viên: ${staffSnapshot.error}',
              );
            }
            if (!staffSnapshot.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator.adaptive()),
              );
            }
            if (staffSnapshot.data!.metadata.isFromCache) {
              return const _AccessMessage(
                'Cần kết nối mạng để xác nhận quyền truy cập của nhân viên.',
              );
            }
            final profile = staffSnapshot.data!.data();
            if (profile?['active'] != true || profile?['role'] != 'employee') {
              return const _AccessMessage(
                'Tài khoản của bạn đã bị khóa hoặc chưa được chủ cửa hàng cấp quyền.',
              );
            }
            return child;
          },
        );
      },
    );
  }
}

class _AccessMessage extends StatelessWidget {
  final String message;
  const _AccessMessage(this.message);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Quyền truy cập')),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 48),
              const SizedBox(height: 16),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () =>
                    context.read<AuthBloc>().add(const AuthEvent.signOut()),
                child: const Text('Đăng xuất'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
