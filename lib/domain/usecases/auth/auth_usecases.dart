import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/app_user.dart';
import '../../repositories/auth_repository.dart';

/// Use case for signing in with email and password
class SignInWithEmail {
  final AuthRepository _repository;

  SignInWithEmail(this._repository);

  Future<Either<Failure, AppUser>> call({
    required String email,
    required String password,
  }) {
    return _repository.signInWithEmail(email: email, password: password);
  }
}

/// Use case for registering a new user
class RegisterWithEmail {
  final AuthRepository _repository;

  RegisterWithEmail(this._repository);

  Future<Either<Failure, AppUser>> call({
    required String email,
    required String password,
    String? displayName,
  }) {
    return _repository.registerWithEmail(
      email: email,
      password: password,
      displayName: displayName,
    );
  }
}

/// Use case for signing out
class SignOut {
  final AuthRepository _repository;

  SignOut(this._repository);

  Future<Either<Failure, void>> call() => _repository.signOut();
}

/// Use case for getting auth state stream
class GetAuthStateChanges {
  final AuthRepository _repository;

  GetAuthStateChanges(this._repository);

  Stream<AppUser?> call() => _repository.authStateChanges;
}
