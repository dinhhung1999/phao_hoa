import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'injection_container.dart';
import 'presentation/auth/auth_bloc.dart';
import 'presentation/dashboard/dashboard_bloc.dart';
import 'presentation/category/category_bloc.dart';
import 'presentation/journal/transaction_bloc.dart';
import 'presentation/customer/customer_bloc.dart';
import 'presentation/checklist/checklist_bloc.dart';
import 'presentation/home_page.dart';

class PhaoHoaApp extends StatelessWidget {
  const PhaoHoaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()),
        BlocProvider(create: (_) => sl<DashboardBloc>()),
        BlocProvider(create: (_) => sl<CategoryBloc>()),
        BlocProvider(create: (_) => sl<TransactionBloc>()),
        BlocProvider(create: (_) => sl<CustomerBloc>()),
        BlocProvider(create: (_) => sl<ChecklistBloc>()),
      ],
      child: MaterialApp(
        title: 'Quản lý Kho Pháo Hoa',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('vi', 'VN'),
          Locale('en', 'US'),
        ],
        locale: const Locale('vi', 'VN'),
        home: const HomePage(),
      ),
    );
  }
}
