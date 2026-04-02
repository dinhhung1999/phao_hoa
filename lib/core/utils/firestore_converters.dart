import 'package:cloud_firestore/cloud_firestore.dart';

/// Shared Firestore timestamp converters for Freezed/JsonSerializable models.
/// Usage in @JsonKey: `fromJson: timestampFromJson, toJson: timestampToJson`
DateTime timestampFromJson(dynamic value) {
  if (value is Timestamp) return value.toDate();
  if (value is String) return DateTime.parse(value);
  return DateTime.now();
}

dynamic timestampToJson(DateTime date) => Timestamp.fromDate(date);
