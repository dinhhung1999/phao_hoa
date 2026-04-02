part of 'auth_bloc.dart';

@freezed
sealed class AuthEvent with _$AuthEvent {
  const factory AuthEvent.checkAuthStatus() = _CheckAuthStatus;
  /// Internal: dispatched by auth stream listener only.
  const factory AuthEvent.authStateChanged({AppUser? user}) =
      _AuthStateChanged;
  const factory AuthEvent.signIn({
    required String email,
    required String password,
  }) = _SignIn;
  const factory AuthEvent.register({
    required String email,
    required String password,
    String? displayName,
  }) = _Register;
  const factory AuthEvent.signOut() = _SignOut;
}
