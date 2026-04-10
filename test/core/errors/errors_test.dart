import 'package:flutter_test/flutter_test.dart';
import 'package:phao_hoa/core/errors/failures.dart';
import 'package:phao_hoa/core/errors/exceptions.dart';

void main() {
  group('Failures', () {
    group('ServerFailure', () {
      test('should have default message', () {
        const failure = ServerFailure();
        expect(failure.message, isNotEmpty);
      });

      test('should accept custom message', () {
        const failure = ServerFailure('Custom error');
        expect(failure.message, equals('Custom error'));
      });

      test('should support equality', () {
        const f1 = ServerFailure('Error');
        const f2 = ServerFailure('Error');
        expect(f1, equals(f2));
      });
    });

    group('FirestoreFailure', () {
      test('should have default message', () {
        const failure = FirestoreFailure();
        expect(failure.message, isNotEmpty);
      });
    });

    group('ValidationFailure', () {
      test('should accept custom message', () {
        const failure = ValidationFailure('Tên không hợp lệ');
        expect(failure.message, equals('Tên không hợp lệ'));
      });
    });

    group('InsufficientStockFailure', () {
      test('should contain available quantity', () {
        const failure = InsufficientStockFailure(availableQuantity: 5);
        expect(failure.availableQuantity, equals(5));
        expect(failure.message, isNotEmpty);
      });

      test('should support equality including quantity', () {
        const f1 = InsufficientStockFailure(availableQuantity: 5);
        const f2 = InsufficientStockFailure(availableQuantity: 5);
        const f3 = InsufficientStockFailure(availableQuantity: 10);
        expect(f1, equals(f2));
        expect(f1, isNot(equals(f3)));
      });
    });
  });

  group('Exceptions', () {
    test('ServerException should have default message', () {
      const ex = ServerException();
      expect(ex.message, isNotEmpty);
    });

    test('FirestoreException should have default message', () {
      const ex = FirestoreException();
      expect(ex.message, isNotEmpty);
    });

    test('NotFoundException should have default message', () {
      const ex = NotFoundException();
      expect(ex.message, isNotEmpty);
    });

    test('ServerException should accept custom message', () {
      const ex = ServerException('Timeout');
      expect(ex.message, equals('Timeout'));
    });
  });
}
