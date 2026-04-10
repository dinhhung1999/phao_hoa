import 'package:flutter_test/flutter_test.dart';
import 'package:phao_hoa/core/utils/date_formatter.dart';

void main() {
  group('DateFormatter', () {
    group('formatDate', () {
      test('should format date as dd/MM/yyyy', () {
        final date = DateTime(2026, 4, 10);
        expect(DateFormatter.formatDate(date), equals('10/04/2026'));
      });

      test('should pad single-digit day and month', () {
        final date = DateTime(2026, 1, 5);
        expect(DateFormatter.formatDate(date), equals('05/01/2026'));
      });

      test('should handle end of year', () {
        final date = DateTime(2025, 12, 31);
        expect(DateFormatter.formatDate(date), equals('31/12/2025'));
      });
    });

    group('formatTime', () {
      test('should format time as HH:mm', () {
        final date = DateTime(2026, 4, 10, 14, 30);
        expect(DateFormatter.formatTime(date), equals('14:30'));
      });

      test('should pad single-digit hours and minutes', () {
        final date = DateTime(2026, 4, 10, 9, 5);
        expect(DateFormatter.formatTime(date), equals('09:05'));
      });

      test('should format midnight', () {
        final date = DateTime(2026, 4, 10, 0, 0);
        expect(DateFormatter.formatTime(date), equals('00:00'));
      });
    });

    group('formatDateTime', () {
      test('should format as dd/MM/yyyy HH:mm', () {
        final date = DateTime(2026, 4, 10, 14, 30);
        expect(DateFormatter.formatDateTime(date), equals('10/04/2026 14:30'));
      });
    });

    group('toFirestoreKey', () {
      test('should format as yyyyMMdd', () {
        final date = DateTime(2026, 4, 10);
        expect(DateFormatter.toFirestoreKey(date), equals('20260410'));
      });

      test('should pad single-digit months and days', () {
        final date = DateTime(2026, 1, 5);
        expect(DateFormatter.toFirestoreKey(date), equals('20260105'));
      });
    });

    group('todayKey', () {
      test('should return today in yyyyMMdd format', () {
        final key = DateFormatter.todayKey;
        expect(key.length, equals(8));
        expect(int.tryParse(key), isNotNull);
      });

      test('should match toFirestoreKey of today', () {
        final now = DateTime.now();
        expect(DateFormatter.todayKey, equals(DateFormatter.toFirestoreKey(now)));
      });
    });
  });
}
