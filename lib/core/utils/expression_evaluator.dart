/// Simple arithmetic expression evaluator.
///
/// Supports +, -, *, / and parentheses.
/// Accepts optional leading '=' (Excel-style).
///
/// Examples:
///   '7*24'    → 168
///   '=7*24'   → 168
///   '10+5*3'  → 25
///   '(10+5)*3' → 45
class ExpressionEvaluator {
  ExpressionEvaluator._();

  /// Try to evaluate the expression string.
  /// Returns null if the string is not a valid expression.
  /// Returns the integer result if valid (truncated from double).
  static int? tryEvaluate(String input) {
    if (input.isEmpty) return null;

    // Strip leading '='
    var expr = input.trim();
    if (expr.startsWith('=')) {
      expr = expr.substring(1).trim();
    }

    // If it's just a plain integer, return it directly
    final plainInt = int.tryParse(expr);
    if (plainInt != null) return plainInt;

    // Check if it looks like a math expression
    if (!RegExp(r'^[\d\s\+\-\*\/\(\)\.]+$').hasMatch(expr)) {
      return null;
    }

    try {
      final result = _evaluate(expr);
      if (result.isNaN || result.isInfinite) return null;
      return result.round();
    } catch (_) {
      return null;
    }
  }

  /// Returns true if the input contains arithmetic operators,
  /// meaning it's an expression rather than a plain number.
  static bool isExpression(String input) {
    var expr = input.trim();
    if (expr.startsWith('=')) expr = expr.substring(1).trim();
    return RegExp(r'[\+\-\*\/]').hasMatch(expr) &&
        RegExp(r'^[\d\s\+\-\*\/\(\)\.]+$').hasMatch(expr);
  }

  // ── Recursive descent parser ──

  static int _pos = 0;
  static late String _expr;

  static double _evaluate(String expression) {
    _pos = 0;
    _expr = expression.replaceAll(' ', '');
    final result = _parseExpression();
    if (_pos < _expr.length) throw FormatException('Unexpected character');
    return result;
  }

  static double _parseExpression() {
    var result = _parseTerm();
    while (_pos < _expr.length && (_current == '+' || _current == '-')) {
      final op = _current;
      _pos++;
      final right = _parseTerm();
      if (op == '+') {
        result += right;
      } else {
        result -= right;
      }
    }
    return result;
  }

  static double _parseTerm() {
    var result = _parseFactor();
    while (_pos < _expr.length && (_current == '*' || _current == '/')) {
      final op = _current;
      _pos++;
      final right = _parseFactor();
      if (op == '*') {
        result *= right;
      } else {
        if (right == 0) throw FormatException('Division by zero');
        result /= right;
      }
    }
    return result;
  }

  static double _parseFactor() {
    // Handle unary minus
    if (_pos < _expr.length && _current == '-') {
      _pos++;
      return -_parseFactor();
    }

    // Handle parentheses
    if (_pos < _expr.length && _current == '(') {
      _pos++; // skip '('
      final result = _parseExpression();
      if (_pos < _expr.length && _current == ')') {
        _pos++; // skip ')'
      }
      return result;
    }

    // Parse number
    final start = _pos;
    while (_pos < _expr.length &&
        (_current.codeUnitAt(0) >= 48 && _current.codeUnitAt(0) <= 57 ||
            _current == '.')) {
      _pos++;
    }
    if (start == _pos) throw FormatException('Expected number');
    return double.parse(_expr.substring(start, _pos));
  }

  static String get _current => _expr[_pos];
}
