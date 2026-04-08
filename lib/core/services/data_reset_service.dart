import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/firestore_paths.dart';

/// Service to delete/reset all application data in Firestore
class DataResetService {
  final FirebaseFirestore _firestore;

  DataResetService([FirebaseFirestore? firestore])
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Delete all documents in a collection (including sub-collections)
  Future<int> _deleteCollection(String collectionPath, {List<String>? subCollections}) async {
    int deletedCount = 0;
    const int batchSize = 400; // Firestore limit is 500 per batch

    while (true) {
      final snapshot = await _firestore
          .collection(collectionPath)
          .limit(batchSize)
          .get();

      if (snapshot.docs.isEmpty) break;

      final batch = _firestore.batch();

      for (final doc in snapshot.docs) {
        // Delete sub-collections first
        if (subCollections != null) {
          for (final subCol in subCollections) {
            await _deleteSubCollection(doc.reference, subCol);
          }
        }
        batch.delete(doc.reference);
        deletedCount++;
      }

      await batch.commit();
    }

    return deletedCount;
  }

  /// Delete all documents in a sub-collection
  Future<void> _deleteSubCollection(DocumentReference docRef, String subCollectionName) async {
    const int batchSize = 400;

    while (true) {
      final snapshot = await docRef
          .collection(subCollectionName)
          .limit(batchSize)
          .get();

      if (snapshot.docs.isEmpty) break;

      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }
  }

  /// Reset ALL application data
  /// Returns a summary map of deleted counts per collection
  Future<Map<String, int>> resetAllData() async {
    final results = <String, int>{};

    // 1. Delete transactions (with items sub-collection)
    results['transactions'] = await _deleteCollection(
      FirestorePaths.transactions,
      subCollections: [FirestorePaths.transactionItems],
    );

    // 2. Delete inventory
    results['inventory'] = await _deleteCollection(FirestorePaths.inventory);

    // 3. Delete products
    results['products'] = await _deleteCollection(FirestorePaths.products);

    // 4. Delete customers (with debt_records sub-collection)
    results['customers'] = await _deleteCollection(
      FirestorePaths.customers,
      subCollections: [FirestorePaths.debtRecords],
    );

    // 5. Delete daily checklists
    results['checklists'] = await _deleteCollection(FirestorePaths.dailyChecklists);

    // 6. Delete reconciliations (with items sub-collection)
    results['reconciliations'] = await _deleteCollection(
      FirestorePaths.reconciliations,
      subCollections: [FirestorePaths.reconciliationItems],
    );

    return results;
  }
}
