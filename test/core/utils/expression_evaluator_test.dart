import 'package:flutter_test/flutter_test.dart';
import 'package:phao_hoa/core/utils/expression_evaluator.dart';

void main() {
  group('ExpressionEvaluator', () {
    group('tryEvaluate', () {
      test('should return null for empty input', () {
        expect(ExpressionEvaluator.tryEvaluate(''), isNull);
      });

      test('should return plain integer directly', () {
        expect(ExpressionEvaluator.tryEvaluate('42'), equals(42));
      });

      test('should evaluate simple addition', () {
        expect(ExpressionEvaluator.tryEvaluate('10+5'), equals(15));
      });

      test('should evaluate simple subtraction', () {
        expect(ExpressionEvaluator.tryEvaluate('20-8'), equals(12));
      });

      test('should evaluate simple multiplication', () {
        expect(ExpressionEvaluator.tryEvaluate('7*24'), equals(168));
      });

      test('should evaluate simple division', () {
        expect(ExpressionEvaluator.tryEvaluate('100/4'), equals(25));
      });

      test('should respect operator precedence (multiplication before addition)', () {
        expect(ExpressionEvaluator.tryEvaluate('10+5*3'), equals(25));
      });

      test('should respect parentheses', () {
        expect(ExpressionEvaluator.tryEvaluate('(10+5)*3'), equals(45));
      });

      test('should handle leading = (Excel-style)', () {
        expect(ExpressionEvaluator.tryEvaluate('=7*24'), equals(168));
      });

      test('should handle spaces in expression', () {
        expect(ExpressionEvaluator.tryEvaluate('10 + 5'), equals(15));
      });

      test('should handle nested parentheses', () {
        expect(ExpressionEvaluator.tryEvaluate('((2+3)*4)'), equals(20));
      });

      test('should handle unary minus', () {
        expect(ExpressionEvaluator.tryEvaluate('-5+10'), equals(5));
      });

      test('should return null for division by zero', () {
        expect(ExpressionEvaluator.tryEvaluate('10/0'), isNull);
      });

      test('should return null for invalid expression (letters)', () {
        expect(ExpressionEvaluator.tryEvaluate('abc'), isNull);
      });

      test('should return null for mixed letters and numbers', () {
        expect(ExpressionEvaluator.tryEvaluate('10+abc'), isNull);
      });

      test('should handle complex expression', () {
        // 2 + 3 * 4 - 6 / 2 = 2 + 12 - 3 = 11
        expect(ExpressionEvaluator.tryEvaluate('2+3*4-6/2'), equals(11));
      });

      test('should handle decimal numbers and round result', () {
        // 10 / 3 = 3.33... → rounds to 3
        expect(ExpressionEvaluator.tryEvaluate('10/3'), equals(3));
      });

      test('should handle = with spaces', () {
        expect(ExpressionEvaluator.tryEvaluate('= 7 * 24'), equals(168));
      });
    });

    group('isExpression', () {
      test('should return false for plain number', () {
        expect(ExpressionEvaluator.isExpression('42'), isFalse);
      });

      test('should return true for expression with +', () {
        expect(ExpressionEvaluator.isExpression('10+5'), isTrue);
      });

      test('should return true for expression with *', () {
        expect(ExpressionEvaluator.isExpression('7*24'), isTrue);
      });

      test('should return true for expression with -', () {
        expect(ExpressionEvaluator.isExpression('20-8'), isTrue);
      });

      test('should return true for expression with /', () {
        expect(ExpressionEvaluator.isExpression('100/4'), isTrue);
      });

      test('should return false for text', () {
        expect(ExpressionEvaluator.isExpression('abc'), isFalse);
      });

      test('should handle = prefix', () {
        expect(ExpressionEvaluator.isExpression('=7*24'), isTrue);
      });

      test('should return false for empty string', () {
        expect(ExpressionEvaluator.isExpression(''), isFalse);
      });
    });
  });
}
