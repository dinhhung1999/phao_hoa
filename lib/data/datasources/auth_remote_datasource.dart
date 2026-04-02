import 'package:firebase_auth/firebase_auth.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/entities/app_user.dart';

/// Firebase Authentication data source
class AuthRemoteDatasource {
  final FirebaseAuth _auth;

  AuthRemoteDatasource(this._auth);

  /// Get current user
  AppUser? getCurrentUser() {
    final user = _auth.currentUser;
    if (user == null) return null;
    return AppUser(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
    );
  }

  /// Stream of auth state changes
  Stream<AppUser?> get authStateChanges {
    return _auth.authStateChanges().map((user) {
      if (user == null) return null;
      return AppUser(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
      );
    });
  }

  /// Sign in with email and password
  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) throw const ServerException('Sign in failed');
      return AppUser(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
      );
    } on FirebaseAuthException catch (e) {
      throw ServerException(_mapFirebaseAuthError(e.code));
    }
  }

  /// Register with email and password
  Future<AppUser> registerWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) throw const ServerException('Registration failed');

      if (displayName != null) {
        await user.updateDisplayName(displayName);
      }

      return AppUser(
        uid: user.uid,
        email: user.email ?? '',
        displayName: displayName,
      );
    } on FirebaseAuthException catch (e) {
      throw ServerException(_mapFirebaseAuthError(e.code));
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  String _mapFirebaseAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Không tìm thấy tài khoản với email này.';
      case 'wrong-password':
        return 'Mật khẩu không đúng.';
      case 'email-already-in-use':
        return 'Email đã được sử dụng.';
      case 'weak-password':
        return 'Mật khẩu quá yếu (cần ít nhất 6 ký tự).';
      case 'invalid-email':
        return 'Email không hợp lệ.';
      case 'too-many-requests':
        return 'Quá nhiều lần thử. Vui lòng thử lại sau.';
      default:
        return 'Lỗi xác thực: $code';
    }
  }
}
