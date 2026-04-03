import 'package:intl/intl.dart';

/// Vietnamese Dong (VNĐ) currency formatting utilities
class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _vnCurrency = NumberFormat('#,###', 'vi_VN');

  /// Format number as VNĐ currency string
  /// Example: 1500000 → "1.500.000 ₫"
  static String format(num amount) {
    return '${_vnCurrency.format(amount)} ₫';
  }

  /// Format without currency symbol
  /// Example: 1500000 → "1.500.000"
  static String formatCompact(num amount) {
    return _vnCurrency.format(amount);
  }

  /// Parse VNĐ string back to number
  static num? parse(String text) {
    try {
      final cleaned = text.replaceAll(RegExp(r'[^\d]'), '');
      return num.parse(cleaned);
    } catch (_) {
      return null;
    }
  }

  /// Format as plain digits without separators or symbols
  /// Example: 1500000.0 → "1500000"
  /// Used for pre-populating editable price fields.
  static String formatPlain(num amount) {
    if (amount == amount.roundToDouble()) {
      return amount.toInt().toString();
    }
    return amount.toString();
  }
}
