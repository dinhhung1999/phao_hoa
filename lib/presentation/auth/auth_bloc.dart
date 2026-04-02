import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/usecases/auth/auth_usecases.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithEmail _signInWithEmail;
  final RegisterWithEmail _registerWithEmail;
  final SignOut _signOut;
  final GetAuthStateChanges _getAuthStateChanges;

  StreamSubscription<AppUser?>? _authSubscription;

  AuthBloc({
    required SignInWithEmail signInWithEmail,
    required RegisterWithEmail registerWithEmail,
    required SignOut signOut,
    required GetAuthStateChanges getAuthStateChanges,
  })  : _signInWithEmail = signInWithEmail,
        _registerWithEmail = registerWithEmail,
        _signOut = signOut,
        _getAuthStateChanges = getAuthStateChanges,
        super(const AuthState.initial()) {
    on<_CheckAuthStatus>(_onCheckAuthStatus);
    on<_AuthStateChanged>(_onAuthStateChanged);
    on<_SignIn>(_onSignIn);
    on<_Register>(_onRegister);
    on<_SignOut>(_onSignOut);
  }

  void _onCheckAuthStatus(
    _CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) {
    _authSubscription?.cancel();
    _authSubscription = _getAuthStateChanges().listen((user) {
      add(AuthEvent.authStateChanged(user: user));
    });
  }

  void _onAuthStateChanged(
    _AuthStateChanged event,
    Emitter<AuthState> emit,
  ) {
    if (event.user != null) {
      emit(AuthState.authenticated(event.user!));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onSignIn(_SignIn event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    final result = await _signInWithEmail(
      email: event.email,
      password: event.password,
    );
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  Future<void> _onRegister(_Register event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    final result = await _registerWithEmail(
      email: event.email,
      password: event.password,
      displayName: event.displayName,
    );
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  Future<void> _onSignOut(
    _SignOut event,
    Emitter<AuthState> emit,
  ) async {
    await _signOut();
    emit(const AuthState.unauthenticated());
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
