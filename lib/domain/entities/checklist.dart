import 'package:equatable/equatable.dart';

/// Domain entity for daily PCCC safety checklist
class Checklist extends Equatable {
  final String date; // yyyyMMdd
  final String completedBy;
  final DateTime completedAt;
  final bool isPassed;
  final List<ChecklistItem> items;

  const Checklist({
    required this.date,
    required this.completedBy,
    required this.completedAt,
    required this.isPassed,
    this.items = const [],
  });

  @override
  List<Object?> get props => [date, isPassed, completedBy];
}

/// A single item in the PCCC checklist
class ChecklistItem extends Equatable {
  final String label;
  final bool isChecked;
  final String? note;

  const ChecklistItem({
    required this.label,
    this.isChecked = false,
    this.note,
  });

  @override
  List<Object?> get props => [label, isChecked];
}
