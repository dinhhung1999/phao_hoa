import 'package:flutter/material.dart';

/// App color palette
class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFFE53935); // Firework red
  static const Color primaryLight = Color(0xFFFF6F60);
  static const Color primaryDark = Color(0xFFAB000D);

  // Accent
  static const Color accent = Color(0xFFFFC107); // Amber/gold
  static const Color accentLight = Color(0xFFFFD54F);

  // Status
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF2196F3);

  // Transaction types
  static const Color importColor = Color(0xFF4CAF50); // Nhập = Green
  static const Color exportColor = Color(0xFFE53935); // Xuất = Red

  // Backgrounds - Light
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color inputFill = Color(0xFFF0F0F0);
  static const Color divider = Color(0xFFE0E0E0);

  // Backgrounds - Dark
  static const Color backgroundDark = Color(0xFF121212);
  static const Color cardDark = Color(0xFF1E1E1E);

  // ─── Theme-aware text colors ───
  // These static values are kept for backward compatibility,
  // but prefer using the of(context) methods below for dark mode support.

  // Text - Light (legacy, used as fallback)
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  // Text - Dark
  static const Color textPrimaryDark = Color(0xFFFAFAFA);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  static const Color textHintDark = Color(0xFF6B6B6B);

  // Debt status
  static const Color debtActive = Color(0xFFE53935);
  static const Color debtPaid = Color(0xFF4CAF50);
  static const Color debtPartial = Color(0xFFFF9800);

  // ─── Theme-aware color getters ───
  /// Get the appropriate text primary color for current theme
  static Color textPrimaryOf(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? textPrimaryDark
        : textPrimary;
  }

  /// Get the appropriate text secondary color for current theme
  static Color textSecondaryOf(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? textSecondaryDark
        : textSecondary;
  }

  /// Get the appropriate text hint color for current theme
  static Color textHintOf(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? textHintDark
        : textHint;
  }

  /// Get the appropriate input fill color for current theme
  static Color inputFillOf(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF2C2C2C)
        : inputFill;
  }

  /// Get the appropriate divider color for current theme
  static Color dividerOf(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF3A3A3A)
        : divider;
  }
}
