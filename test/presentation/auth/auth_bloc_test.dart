import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phao_hoa/core/errors/failures.dart';
import 'package:phao_hoa/domain/entities/app_user.dart';
import 'package:phao_hoa/domain/usecases/auth/auth_usecases.dart';
import 'package:phao_hoa/presentation/auth/auth_bloc.dart';

class MockSignInWithEmail extends Mock implements SignInWithEmail {}
class MockRegisterWithEmail extends Mock implements RegisterWithEmail {}
class MockSignOut extends Mock implements SignOut {}
class MockGetAuthStateChanges extends Mock implements GetAuthStateChanges {}

void main() {
  late MockSignInWithEmail mockSignIn;
  late MockRegisterWithEmail mockRegister;
  late MockSignOut mockSignOut;
  late MockGetAuthStateChanges mockGetAuthState;

  const tUser = AppUser(uid: 'u1', email: 'test@example.com', displayName: 'Test');

  setUp(() {
    mockSignIn = MockSignInWithEmail();
    mockRegister = MockRegisterWithEmail();
    mockSignOut = MockSignOut();
    mockGetAuthState = MockGetAuthStateChanges();
  });

  AuthBloc buildBloc() => AuthBloc(
        signInWithEmail: mockSignIn,
        registerWithEmail: mockRegister,
        signOut: mockSignOut,
        getAuthStateChanges: mockGetAuthState,
      );

  group('AuthBloc', () {
    test('initial state is AuthState.initial()', () {
      final bloc = buildBloc();
      expect(bloc.state, const AuthState.initial());
      bloc.close();
    });

    group('signIn', () {
      blocTest<AuthBloc, AuthState>(
        'emits [loading, authenticated] on successful sign in',
        build: () {
          when(() => mockSignIn(email: 'test@example.com', password: 'pass123'))
              .thenAnswer((_) async => const Right(tUser));
          return buildBloc();
        },
        act: (bloc) => bloc.add(const AuthEvent.signIn(
          email: 'test@example.com',
          password: 'pass123',
        )),
        expect: () => [
          const AuthState.loading(),
          const AuthState.authenticated(tUser),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [loading, error] on failed sign in',
        build: () {
          when(() => mockSignIn(email: 'test@example.com', password: 'wrong'))
              .thenAnswer((_) async => const Left(ServerFailure('Sai mật khẩu')));
          return buildBloc();
        },
        act: (bloc) => bloc.add(const AuthEvent.signIn(
          email: 'test@example.com',
          password: 'wrong',
        )),
        expect: () => [
          const AuthState.loading(),
          const AuthState.error('Sai mật khẩu'),
        ],
      );
    });

    group('register', () {
      blocTest<AuthBloc, AuthState>(
        'emits [loading, authenticated] on successful registration',
        build: () {
          when(() => mockRegister(
                email: 'new@example.com',
                password: 'pass123',
                displayName: 'New User',
              )).thenAnswer((_) async => const Right(tUser));
          return buildBloc();
        },
        act: (bloc) => bloc.add(const AuthEvent.register(
          email: 'new@example.com',
          password: 'pass123',
          displayName: 'New User',
        )),
        expect: () => [
          const AuthState.loading(),
          const AuthState.authenticated(tUser),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [loading, error] on failed registration',
        build: () {
          when(() => mockRegister(
                email: 'existing@example.com',
                password: 'pass123',
              )).thenAnswer((_) async => const Left(ServerFailure('Email đã tồn tại')));
          return buildBloc();
        },
        act: (bloc) => bloc.add(const AuthEvent.register(
          email: 'existing@example.com',
          password: 'pass123',
        )),
        expect: () => [
          const AuthState.loading(),
          const AuthState.error('Email đã tồn tại'),
        ],
      );
    });

    group('signOut', () {
      blocTest<AuthBloc, AuthState>(
        'emits [unauthenticated] on sign out',
        build: () {
          when(() => mockSignOut()).thenAnswer((_) async => const Right(null));
          return buildBloc();
        },
        act: (bloc) => bloc.add(const AuthEvent.signOut()),
        expect: () => [
          const AuthState.unauthenticated(),
        ],
      );
    });

    group('checkAuthStatus', () {
      blocTest<AuthBloc, AuthState>(
        'emits [authenticated] when user is logged in',
        build: () {
          when(() => mockGetAuthState())
              .thenAnswer((_) => Stream.value(tUser));
          return buildBloc();
        },
        act: (bloc) => bloc.add(const AuthEvent.checkAuthStatus()),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          const AuthState.authenticated(tUser),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [unauthenticated] when user is not logged in',
        build: () {
          when(() => mockGetAuthState())
              .thenAnswer((_) => Stream.value(null));
          return buildBloc();
        },
        act: (bloc) => bloc.add(const AuthEvent.checkAuthStatus()),
        wait: const Duration(milliseconds: 100),
        expect: () => [
          const AuthState.unauthenticated(),
        ],
      );
    });
  });
}
