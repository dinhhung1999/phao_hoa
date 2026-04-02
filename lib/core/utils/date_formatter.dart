import 'package:intl/intl.dart';

/// Date formatting utilities
class DateFormatter {
  DateFormatter._();

  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _timeFormat = DateFormat('HH:mm');
  static final DateFormat _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');
  static final DateFormat _firestoreDateKey = DateFormat('yyyyMMdd');

  /// Format date as dd/MM/yyyy
  static String formatDate(DateTime date) => _dateFormat.format(date);

  /// Format time as HH:mm
  static String formatTime(DateTime date) => _timeFormat.format(date);

  /// Format as dd/MM/yyyy HH:mm
  static String formatDateTime(DateTime date) => _dateTimeFormat.format(date);

  /// Format as yyyyMMdd for Firestore document IDs
  static String toFirestoreKey(DateTime date) => _firestoreDateKey.format(date);

  /// Get today's key in yyyyMMdd format
  static String get todayKey => toFirestoreKey(DateTime.now());
}
