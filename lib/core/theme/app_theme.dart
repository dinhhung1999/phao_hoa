import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// iOS-centric app theme configuration
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        titleTextStyle: AppTextStyles.appBarTitle,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        backgroundColor: Colors.white,
        elevation: 8,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 0.5,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimaryDark,
        titleTextStyle: AppTextStyles.appBarTitle.copyWith(
          color: AppColors.textPrimaryDark,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: AppColors.cardDark,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryLight,
        unselectedItemColor: AppColors.textSecondaryDark,
        backgroundColor: AppColors.cardDark,
        elevation: 8,
      ),
      // Input decoration for dark mode
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        hintStyle: const TextStyle(color: AppColors.textSecondaryDark),
        labelStyle: const TextStyle(color: AppColors.textSecondaryDark),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryLight, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      // Text theme for dark mode
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.textPrimaryDark),
        bodyMedium: TextStyle(color: AppColors.textPrimaryDark),
        bodySmall: TextStyle(color: AppColors.textSecondaryDark),
        titleLarge: TextStyle(color: AppColors.textPrimaryDark),
        titleMedium: TextStyle(color: AppColors.textPrimaryDark),
        titleSmall: TextStyle(color: AppColors.textPrimaryDark),
        labelLarge: TextStyle(color: AppColors.textPrimaryDark),
        labelMedium: TextStyle(color: AppColors.textSecondaryDark),
        labelSmall: TextStyle(color: AppColors.textSecondaryDark),
      ),
      // Divider for dark mode
      dividerTheme: const DividerThemeData(
        color: Color(0xFF3A3A3A),
        thickness: 0.5,
      ),
      // Icon theme
      iconTheme: const IconThemeData(
        color: AppColors.textPrimaryDark,
      ),
      // Dialog theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.cardDark,
        titleTextStyle: const TextStyle(
          color: AppColors.textPrimaryDark,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: const TextStyle(
          color: AppColors.textPrimaryDark,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      // List tile
      listTileTheme: const ListTileThemeData(
        textColor: AppColors.textPrimaryDark,
        iconColor: AppColors.textSecondaryDark,
      ),
      // Floating action button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF2C2C2C),
        labelStyle: const TextStyle(color: AppColors.textPrimaryDark),
        side: const BorderSide(color: Color(0xFF3A3A3A)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      // Dropdown menu
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: const TextStyle(color: AppColors.textPrimaryDark),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: const Color(0xFF2C2C2C),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
          ),
        ),
      ),
    );
  }
}
