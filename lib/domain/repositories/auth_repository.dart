import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/app_user.dart';

/// Auth repository contract
abstract class AuthRepository {
  /// Get the current authenticated user (null if not signed in)
  Future<AppUser?> getCurrentUser();

  /// Stream of auth state changes
  Stream<AppUser?> get authStateChanges;

  /// Sign in with email and password
  Future<Either<Failure, AppUser>> signInWithEmail({
    required String email,
    required String password,
  });

  /// Register with email and password
  Future<Either<Failure, AppUser>> registerWithEmail({
    required String email,
    required String password,
    String? displayName,
  });

  /// Sign out
  Future<Either<Failure, void>> signOut();
}
