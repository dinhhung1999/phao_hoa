import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/firestore_paths.dart';
import '../models/warehouse_model.dart';

/// Firestore data source for warehouse management
class WarehouseRemoteDatasource {
  final FirebaseFirestore _firestore;

  WarehouseRemoteDatasource(this._firestore);

  CollectionReference get _collection =>
      _firestore.collection(FirestorePaths.warehouses);

  /// Get all active warehouses
  Future<List<WarehouseModel>> getAllWarehouses() async {
    final snapshot = await _collection
        .where('is_active', isEqualTo: true)
        .orderBy('created_at')
        .get();
    return snapshot.docs
        .map((d) => WarehouseModel.fromFirestore(d))
        .toList();
  }

  /// Get warehouse by ID
  Future<WarehouseModel> getWarehouseById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) throw Exception('Warehouse not found: $id');
    return WarehouseModel.fromFirestore(doc);
  }

  /// Add a new warehouse
  Future<String> addWarehouse(WarehouseModel model) async {
    final json = model.toJson();
    json.remove('id');
    json['created_at'] = FieldValue.serverTimestamp();
    json['updated_at'] = FieldValue.serverTimestamp();
    final docRef = await _collection.add(json);
    return docRef.id;
  }

  /// Update an existing warehouse
  Future<void> updateWarehouse(WarehouseModel model) async {
    final json = model.toJson();
    json.remove('id');
    json.remove('created_at'); // Don't overwrite creation time
    json['updated_at'] = FieldValue.serverTimestamp();
    await _collection.doc(model.id).update(json);
  }

  /// Soft-delete a warehouse (set is_active = false)
  Future<void> deleteWarehouse(String id) async {
    await _collection.doc(id).update({
      'is_active': false,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  /// Stream all active warehouses
  Stream<List<WarehouseModel>> watchAllWarehouses() {
    return _collection
        .where('is_active', isEqualTo: true)
        .orderBy('created_at')
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => WarehouseModel.fromFirestore(d))
            .toList());
  }

  /// Seed default warehouses if collection is empty.
  /// Reads names from legacy app_config/warehouse_config if available.
  Future<void> seedDefaultWarehouses() async {
    final snap = await _collection.limit(1).get();
    if (snap.docs.isNotEmpty) return; // Already has data

    // Try to load legacy names from old config
    Map<String, String> legacyNames = {};
    try {
      final configDoc = await _firestore
          .collection(FirestorePaths.appConfig)
          .doc('warehouse_config')
          .get();
      if (configDoc.exists) {
        final names =
            configDoc.data()?['warehouse_names'] as Map<String, dynamic>?;
        if (names != null) {
          legacyNames = names.map((k, v) => MapEntry(k, v.toString()));
        }
      }
    } catch (_) {
      // Ignore — use defaults
    }

    final defaults = [
      {'id': 'kho_1', 'name': legacyNames['kho_1'] ?? 'Kho 1'},
      {'id': 'kho_2', 'name': legacyNames['kho_2'] ?? 'Kho 2'},
      {'id': 'kho_3', 'name': legacyNames['kho_3'] ?? 'Kho 3'},
    ];

    final batch = _firestore.batch();
    for (final wh in defaults) {
      batch.set(_collection.doc(wh['id']), {
        'name': wh['name'],
        'is_active': true,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }
}
