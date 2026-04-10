import 'package:flutter_test/flutter_test.dart';
import 'package:phao_hoa/core/utils/currency_formatter.dart';

void main() {
  group('CurrencyFormatter', () {
    group('format', () {
      test('should format integer amount with VNĐ symbol', () {
        expect(CurrencyFormatter.format(1500000), contains('1.500.000'));
        expect(CurrencyFormatter.format(1500000), endsWith('₫'));
      });

      test('should format zero', () {
        expect(CurrencyFormatter.format(0), contains('0'));
        expect(CurrencyFormatter.format(0), endsWith('₫'));
      });

      test('should format small amounts', () {
        expect(CurrencyFormatter.format(500), contains('500'));
      });

      test('should format large amounts', () {
        final result = CurrencyFormatter.format(1000000000);
        expect(result, contains('1.000.000.000'));
      });

      test('should format negative amounts', () {
        final result = CurrencyFormatter.format(-500000);
        expect(result, contains('500.000'));
      });
    });

    group('formatCompact', () {
      test('should format without currency symbol', () {
        final result = CurrencyFormatter.formatCompact(1500000);
        expect(result, isNot(contains('₫')));
        expect(result, contains('1.500.000'));
      });

      test('should format zero without symbol', () {
        expect(CurrencyFormatter.formatCompact(0), isNot(contains('₫')));
      });
    });

    group('parse', () {
      test('should parse formatted currency string', () {
        expect(CurrencyFormatter.parse('1.500.000 ₫'), equals(1500000));
      });

      test('should parse plain number string', () {
        expect(CurrencyFormatter.parse('500000'), equals(500000));
      });

      test('should return null for non-numeric string', () {
        expect(CurrencyFormatter.parse('abc'), isNull);
      });

      test('should return null for empty string', () {
        expect(CurrencyFormatter.parse(''), isNull);
      });

      test('should parse string with mixed characters', () {
        expect(CurrencyFormatter.parse('1,500,000đ'), equals(1500000));
      });
    });

    group('formatPlain', () {
      test('should format integer without separators', () {
        expect(CurrencyFormatter.formatPlain(1500000), equals('1500000'));
      });

      test('should format double without decimal when whole number', () {
        expect(CurrencyFormatter.formatPlain(1500000.0), equals('1500000'));
      });

      test('should keep decimal for non-whole numbers', () {
        expect(CurrencyFormatter.formatPlain(1500.5), equals('1500.5'));
      });

      test('should format zero', () {
        expect(CurrencyFormatter.formatPlain(0), equals('0'));
      });
    });
  });
}
