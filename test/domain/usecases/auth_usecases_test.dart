import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phao_hoa/core/errors/failures.dart';
import 'package:phao_hoa/domain/entities/app_user.dart';
import 'package:phao_hoa/domain/repositories/auth_repository.dart';
import 'package:phao_hoa/domain/usecases/auth/auth_usecases.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;

  const tUser = AppUser(
    uid: 'uid_123',
    email: 'test@example.com',
    displayName: 'Test User',
  );

  setUp(() {
    mockRepository = MockAuthRepository();
  });

  group('SignInWithEmail', () {
    late SignInWithEmail usecase;

    setUp(() => usecase = SignInWithEmail(mockRepository));

    test('should return AppUser on successful sign in', () async {
      when(() => mockRepository.signInWithEmail(
            email: 'test@example.com',
            password: 'password123',
          )).thenAnswer((_) async => const Right(tUser));

      final result = await usecase(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(result, const Right(tUser));
      verify(() => mockRepository.signInWithEmail(
            email: 'test@example.com',
            password: 'password123',
          )).called(1);
    });

    test('should return failure on invalid credentials', () async {
      when(() => mockRepository.signInWithEmail(
            email: 'test@example.com',
            password: 'wrong',
          )).thenAnswer((_) async => const Left(ServerFailure('Sai mật khẩu')));

      final result = await usecase(
        email: 'test@example.com',
        password: 'wrong',
      );

      expect(result, isA<Left>());
    });
  });

  group('RegisterWithEmail', () {
    late RegisterWithEmail usecase;

    setUp(() => usecase = RegisterWithEmail(mockRepository));

    test('should return AppUser on successful registration', () async {
      when(() => mockRepository.registerWithEmail(
            email: 'new@example.com',
            password: 'password123',
            displayName: 'New User',
          )).thenAnswer((_) async => const Right(tUser));

      final result = await usecase(
        email: 'new@example.com',
        password: 'password123',
        displayName: 'New User',
      );

      expect(result, const Right(tUser));
    });

    test('should return failure when email already exists', () async {
      when(() => mockRepository.registerWithEmail(
            email: 'existing@example.com',
            password: 'password123',
          )).thenAnswer((_) async => const Left(ServerFailure('Email đã tồn tại')));

      final result = await usecase(
        email: 'existing@example.com',
        password: 'password123',
      );

      expect(result, isA<Left>());
    });
  });

  group('SignOut', () {
    late SignOut usecase;

    setUp(() => usecase = SignOut(mockRepository));

    test('should call repository signOut', () async {
      when(() => mockRepository.signOut())
          .thenAnswer((_) async => const Right(null));

      final result = await usecase();

      expect(result, const Right(null));
      verify(() => mockRepository.signOut()).called(1);
    });
  });

  group('GetAuthStateChanges', () {
    late GetAuthStateChanges usecase;

    setUp(() => usecase = GetAuthStateChanges(mockRepository));

    test('should return auth state stream', () {
      when(() => mockRepository.authStateChanges)
          .thenAnswer((_) => Stream.fromIterable([tUser, null]));

      final stream = usecase();

      expectLater(stream, emitsInOrder([tUser, null]));
    });

    test('should emit null when signed out', () {
      when(() => mockRepository.authStateChanges)
          .thenAnswer((_) => Stream.value(null));

      final stream = usecase();

      expectLater(stream, emits(null));
    });
  });
}
