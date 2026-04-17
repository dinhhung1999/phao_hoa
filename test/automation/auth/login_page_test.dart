import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:phao_hoa/domain/entities/app_user.dart';
import 'package:phao_hoa/presentation/auth/auth_bloc.dart';
import 'package:phao_hoa/presentation/auth/login_page.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}


/// Helper to wrap a widget with MaterialApp + BlocProvider
Widget buildTestApp({required Widget child, required AuthBloc authBloc}) {
  return MaterialApp(
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('vi', 'VN')],
    locale: const Locale('vi', 'VN'),
    home: BlocProvider<AuthBloc>.value(
      value: authBloc,
      child: child,
    ),
  );
}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
  });

  group('LoginPage - UI Flow', () {
    testWidgets('should display login form with email and password fields',
        (tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthState.unauthenticated());

      await tester.pumpWidget(buildTestApp(
        child: const LoginPage(),
        authBloc: mockAuthBloc,
      ));

      expect(find.text('Quản lý Kho Pháo Hoa'), findsOneWidget);
      expect(find.text('Đăng nhập'), findsWidgets); // title + button
      expect(find.byType(TextFormField), findsNWidgets(2)); // email + password
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('should show validation errors on empty submit', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthState.unauthenticated());

      await tester.pumpWidget(buildTestApp(
        child: const LoginPage(),
        authBloc: mockAuthBloc,
      ));

      // Find and tap the login button
      final loginButton = find.widgetWithText(ElevatedButton, 'Đăng nhập');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Validation errors should appear
      expect(find.text('Vui lòng nhập email'), findsOneWidget);
      expect(find.text('Vui lòng nhập mật khẩu'), findsOneWidget);
    });

    testWidgets('should show validation error for invalid email', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthState.unauthenticated());

      await tester.pumpWidget(buildTestApp(
        child: const LoginPage(),
        authBloc: mockAuthBloc,
      ));

      // Type invalid email
      await tester.enterText(find.byType(TextFormField).first, 'not-an-email');
      await tester.enterText(find.byType(TextFormField).last, 'password123');

      // Submit
      final loginButton = find.widgetWithText(ElevatedButton, 'Đăng nhập');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.text('Email không hợp lệ'), findsOneWidget);
    });

    testWidgets('should show validation error for short password', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthState.unauthenticated());

      await tester.pumpWidget(buildTestApp(
        child: const LoginPage(),
        authBloc: mockAuthBloc,
      ));

      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, '123');

      final loginButton = find.widgetWithText(ElevatedButton, 'Đăng nhập');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.text('Mật khẩu phải có ít nhất 6 ký tự'), findsOneWidget);
    });

    testWidgets('should dispatch SignIn event with valid credentials',
        (tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthState.unauthenticated());

      await tester.pumpWidget(buildTestApp(
        child: const LoginPage(),
        authBloc: mockAuthBloc,
      ));

      // Fill in valid credentials
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');

      // Submit
      final loginButton = find.widgetWithText(ElevatedButton, 'Đăng nhập');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Verify bloc received the event
      verify(() => mockAuthBloc.add(const AuthEvent.signIn(
            email: 'test@example.com',
            password: 'password123',
          ))).called(1);
    });

    testWidgets('should show loading indicator when loading', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthState.loading());

      await tester.pumpWidget(buildTestApp(
        child: const LoginPage(),
        authBloc: mockAuthBloc,
      ));

      // Button should be disabled and show a progress indicator
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull); // disabled
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should toggle password visibility', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthState.unauthenticated());

      await tester.pumpWidget(buildTestApp(
        child: const LoginPage(),
        authBloc: mockAuthBloc,
      ));

      // Initially password is obscured → visibility_off icon is shown
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsNothing);

      // Tap visibility toggle
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pumpAndSettle();

      // Now visibility icon is shown (password visible)
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsNothing);
    });

    testWidgets('should show error snackbar on auth failure', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthState.unauthenticated());

      whenListen(
        mockAuthBloc,
        Stream.fromIterable([
          const AuthState.loading(),
          const AuthState.error('Sai mật khẩu'),
        ]),
        initialState: const AuthState.unauthenticated(),
      );

      await tester.pumpWidget(buildTestApp(
        child: const LoginPage(),
        authBloc: mockAuthBloc,
      ));

      await tester.pumpAndSettle();

      // SnackBar with error message should appear
      expect(find.text('Sai mật khẩu'), findsOneWidget);
    });
  });
}
