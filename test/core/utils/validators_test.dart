import 'package:flutter_test/flutter_test.dart';
import 'package:phao_hoa/core/utils/validators.dart';

void main() {
  group('Validators', () {
    group('validateProductName', () {
      test('should return error for null', () {
        expect(Validators.validateProductName(null), isNotNull);
      });

      test('should return error for empty string', () {
        expect(Validators.validateProductName(''), isNotNull);
      });

      test('should return error for whitespace only', () {
        expect(Validators.validateProductName('   '), isNotNull);
      });

      test('should return null for valid name', () {
        expect(Validators.validateProductName('Pháo hoa ABC'), isNull);
      });
    });

    group('validatePrice', () {
      test('should return error for null', () {
        expect(Validators.validatePrice(null), isNotNull);
      });

      test('should return error for empty string', () {
        expect(Validators.validatePrice(''), isNotNull);
      });

      test('should return error for zero', () {
        expect(Validators.validatePrice('0'), isNotNull);
      });

      test('should return error for non-numeric input', () {
        expect(Validators.validatePrice('abc'), isNotNull);
      });

      test('should return null for valid price', () {
        expect(Validators.validatePrice('150000'), isNull);
      });

      test('should handle formatted price with dots', () {
        expect(Validators.validatePrice('1.500.000'), isNull);
      });
    });

    group('validateQuantity', () {
      test('should return error for null', () {
        expect(Validators.validateQuantity(null), isNotNull);
      });

      test('should return error for empty string', () {
        expect(Validators.validateQuantity(''), isNotNull);
      });

      test('should return error for zero', () {
        expect(Validators.validateQuantity('0'), isNotNull);
      });

      test('should return error for negative number', () {
        expect(Validators.validateQuantity('-5'), isNotNull);
      });

      test('should return error for decimal', () {
        expect(Validators.validateQuantity('1.5'), isNotNull);
      });

      test('should return null for valid quantity', () {
        expect(Validators.validateQuantity('10'), isNull);
      });
    });

    group('validateCustomerName', () {
      test('should return error for null', () {
        expect(Validators.validateCustomerName(null), isNotNull);
      });

      test('should return error for empty string', () {
        expect(Validators.validateCustomerName(''), isNotNull);
      });

      test('should return error for whitespace only', () {
        expect(Validators.validateCustomerName('  '), isNotNull);
      });

      test('should return null for valid name', () {
        expect(Validators.validateCustomerName('Nguyễn Văn A'), isNull);
      });
    });

    group('validatePhone', () {
      test('should return null for null (phone is optional)', () {
        expect(Validators.validatePhone(null), isNull);
      });

      test('should return null for empty string (phone is optional)', () {
        expect(Validators.validatePhone(''), isNull);
      });

      test('should return null for valid Vietnamese phone starting with 0', () {
        expect(Validators.validatePhone('0912345678'), isNull);
      });

      test('should return null for valid phone with +84 prefix', () {
        expect(Validators.validatePhone('+84912345678'), isNull);
      });

      test('should return null for phone with spaces/dashes', () {
        expect(Validators.validatePhone('091-234-5678'), isNull);
      });

      test('should return error for invalid phone format', () {
        expect(Validators.validatePhone('123'), isNotNull);
      });

      test('should return error for non-Vietnamese phone', () {
        expect(Validators.validatePhone('+1234567890'), isNotNull);
      });

      test('should return error for letters in phone', () {
        expect(Validators.validatePhone('abcdefghij'), isNotNull);
      });
    });

    group('validateEmail', () {
      test('should return error for null', () {
        expect(Validators.validateEmail(null), isNotNull);
      });

      test('should return error for empty string', () {
        expect(Validators.validateEmail(''), isNotNull);
      });

      test('should return error for invalid email', () {
        expect(Validators.validateEmail('not-an-email'), isNotNull);
      });

      test('should return error for email without domain', () {
        expect(Validators.validateEmail('user@'), isNotNull);
      });

      test('should return null for valid email', () {
        expect(Validators.validateEmail('user@example.com'), isNull);
      });

      test('should return null for email with subdomain', () {
        expect(Validators.validateEmail('user@mail.example.com'), isNull);
      });
    });

    group('validatePassword', () {
      test('should return error for null', () {
        expect(Validators.validatePassword(null), isNotNull);
      });

      test('should return error for empty string', () {
        expect(Validators.validatePassword(''), isNotNull);
      });

      test('should return error for short password (< 6 chars)', () {
        expect(Validators.validatePassword('12345'), isNotNull);
      });

      test('should return null for password with exactly 6 chars', () {
        expect(Validators.validatePassword('123456'), isNull);
      });

      test('should return null for long password', () {
        expect(Validators.validatePassword('myStrongPassword123'), isNull);
      });
    });
  });
}
