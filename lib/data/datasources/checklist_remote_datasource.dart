import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/firestore_paths.dart';
import '../../core/utils/date_formatter.dart';
import '../models/checklist_model.dart';

/// Firestore data source for daily PCCC checklists
class ChecklistRemoteDatasource {
  final FirebaseFirestore _firestore;

  ChecklistRemoteDatasource(this._firestore);

  CollectionReference get _collection =>
      _firestore.collection(FirestorePaths.dailyChecklists);

  /// Submit daily checklist
  Future<void> submitDailyChecklist({
    required String userId,
    required List<ChecklistItemModel> items,
  }) async {
    final today = DateFormatter.todayKey;
    final allPassed = items.every((item) => item.isChecked);

    await _collection.doc(today).set({
      'date': FieldValue.serverTimestamp(),
      'completed_by': userId,
      'completed_at': FieldValue.serverTimestamp(),
      'is_passed': allPassed,
      'items': items.map((i) => i.toJson()).toList(),
    });
  }

  /// Check if today's checklist is completed
  Future<bool> isTodayChecklistCompleted() async {
    final today = DateFormatter.todayKey;
    final doc = await _collection.doc(today).get();
    if (!doc.exists) return false;
    final data = doc.data() as Map<String, dynamic>;
    return data['is_passed'] == true;
  }

  /// Get today's checklist
  Future<ChecklistModel?> getTodayChecklist() async {
    final today = DateFormatter.todayKey;
    final doc = await _collection.doc(today).get();
    if (!doc.exists) return null;
    final data = doc.data() as Map<String, dynamic>;
    return ChecklistModel.fromJson({...data, 'date': today});
  }

  /// Get checklist history
  Future<List<ChecklistModel>> getChecklistHistory() async {
    final snapshot = await _collection
        .orderBy('completed_at', descending: true)
        .limit(30)
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return ChecklistModel.fromJson({...data, 'date': doc.id});
    }).toList();
  }
}
