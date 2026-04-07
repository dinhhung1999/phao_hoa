import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/firestore_paths.dart';

/// Types of data that can be selectively reset
enum DataResetType {
  products('Sản phẩm', 'products'),
  inventory('Tồn kho', 'inventory'),
  transactions('Giao dịch nhập/xuất', 'transactions'),
  customers('Khách hàng & công nợ', 'customers'),
  checklists('Checklist hàng ngày', 'checklists');

  final String label;
  final String key;
  const DataResetType(this.label, this.key);
}

/// Dependencies / warnings between data types
class DataResetWarning {
  static const Map<DataResetType, List<String>> warnings = {
    DataResetType.transactions: [
      'Xóa giao dịch mà giữ tồn kho sẽ làm dữ liệu tồn kho bị lệch.',
      'Nên xóa tồn kho cùng giao dịch.',
    ],
    DataResetType.inventory: [
      'Xóa tồn kho mà giữ giao dịch sẽ không thể tính lại số liệu.',
    ],
    DataResetType.products: [
      'Xóa sản phẩm sẽ ảnh hưởng đến giao dịch và tồn kho liên quan.',
      'Nên xóa tồn kho và giao dịch trước.',
    ],
    DataResetType.customers: [
      'Xóa khách hàng sẽ xóa cả lịch sử công nợ liên quan.',
    ],
  };

  static List<String> getWarnings(Set<DataResetType> selectedTypes) {
    final result = <String>[];
    for (final type in selectedTypes) {
      final typeWarnings = warnings[type];
      if (typeWarnings != null) {
        // Check if dependent types are NOT selected
        if (type == DataResetType.transactions &&
            !selectedTypes.contains(DataResetType.inventory)) {
          result.addAll(typeWarnings);
        } else if (type == DataResetType.inventory &&
            !selectedTypes.contains(DataResetType.transactions)) {
          result.addAll(typeWarnings);
        } else if (type == DataResetType.products) {
          if (!selectedTypes.contains(DataResetType.inventory) ||
              !selectedTypes.contains(DataResetType.transactions)) {
            result.addAll(typeWarnings);
          }
        } else if (type == DataResetType.customers) {
          result.addAll(typeWarnings);
        }
      }
    }
    return result;
  }
}

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

  // ── Selective reset methods ──

  /// Reset only products
  Future<int> resetProducts() => _deleteCollection(FirestorePaths.products);

  /// Reset only inventory
  Future<int> resetInventory() => _deleteCollection(FirestorePaths.inventory);

  /// Reset only transactions (with items sub-collection)
  Future<int> resetTransactions() => _deleteCollection(
    FirestorePaths.transactions,
    subCollections: [FirestorePaths.transactionItems],
  );

  /// Reset only customers (with debt_records sub-collection)
  Future<int> resetCustomers() => _deleteCollection(
    FirestorePaths.customers,
    subCollections: [FirestorePaths.debtRecords],
  );

  /// Reset only checklists
  Future<int> resetChecklists() => _deleteCollection(FirestorePaths.dailyChecklists);

  /// Reset selected data types
  Future<Map<String, int>> resetSelectiveData(Set<DataResetType> types) async {
    final results = <String, int>{};

    for (final type in types) {
      switch (type) {
        case DataResetType.transactions:
          results['transactions'] = await resetTransactions();
        case DataResetType.inventory:
          results['inventory'] = await resetInventory();
        case DataResetType.products:
          results['products'] = await resetProducts();
        case DataResetType.customers:
          results['customers'] = await resetCustomers();
        case DataResetType.checklists:
          results['checklists'] = await resetChecklists();
      }
    }

    return results;
  }

  /// Reset ALL application data
  /// Returns a summary map of deleted counts per collection
  Future<Map<String, int>> resetAllData() async {
    return resetSelectiveData(DataResetType.values.toSet());
  }
}
