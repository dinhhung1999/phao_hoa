import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/firestore_paths.dart';
import '../models/product_model.dart';

/// Firestore data source for Products collection
class ProductRemoteDatasource {
  final FirebaseFirestore _firestore;

  ProductRemoteDatasource(this._firestore);

  CollectionReference get _collection =>
      _firestore.collection(FirestorePaths.products);

  /// Get all active products
  Future<List<ProductModel>> getAllProducts() async {
    final snapshot =
        await _collection.where('is_active', isEqualTo: true).get();
    return snapshot.docs.map((d) => ProductModel.fromFirestore(d)).toList();
  }

  /// Stream all active products
  Stream<List<ProductModel>> watchAllProducts() {
    return _collection
        .where('is_active', isEqualTo: true)
        .orderBy('name')
        .snapshots()
        .map(
          (snap) => snap.docs.map((d) => ProductModel.fromFirestore(d)).toList(),
        );
  }

  /// Get a single product
  Future<ProductModel> getProductById(String id) async {
    final doc = await _collection.doc(id).get();
    return ProductModel.fromFirestore(doc);
  }

  /// Add a new product, returns document ID
  Future<String> addProduct(ProductModel product) async {
    final data = product.toJson()..remove('id');
    final docRef = await _collection.add(data);
    return docRef.id;
  }

  /// Update product
  Future<void> updateProduct(ProductModel product) async {
    final data = product.toJson()..remove('id');
    await _collection.doc(product.id).update(data);
  }

  /// Soft-delete product
  Future<void> deleteProduct(String id) async {
    await _collection.doc(id).update({'is_active': false});
  }

  /// Get products with cursor-based pagination
  Future<(List<ProductModel>, DocumentSnapshot?)> getProductsPaginated({
    int limit = 20,
    DocumentSnapshot? startAfter,
  }) async {
    Query query = _collection
        .where('is_active', isEqualTo: true)
        .orderBy('name')
        .limit(limit);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    final snapshot = await query.get();
    final models = snapshot.docs.map((d) => ProductModel.fromFirestore(d)).toList();
    final lastDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

    return (models, lastDoc);
  }

  // ── Price History ──

  /// Add a price record to the product's price_history sub-collection
  Future<void> addPriceRecord({
    required String productId,
    required double importPrice,
    required double exportPrice,
    String? updatedBy,
  }) async {
    await _collection
        .doc(productId)
        .collection(FirestorePaths.priceHistory)
        .add({
      'import_price': importPrice,
      'export_price': exportPrice,
      'updated_by': updatedBy,
      'recorded_at': FieldValue.serverTimestamp(),
    });
  }

  /// Get price history for a product, ordered by date
  Future<List<Map<String, dynamic>>> getPriceHistory(
    String productId, {
    int? limit,
  }) async {
    Query query = _collection
        .doc(productId)
        .collection(FirestorePaths.priceHistory)
        .orderBy('recorded_at', descending: false);

    if (limit != null) {
      query = query.limit(limit);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'id': doc.id,
        'product_id': productId,
        ...data,
      };
    }).toList();
  }

  /// Update product price and record price history atomically
  Future<void> updateProductPrice({
    required String productId,
    required double newImportPrice,
    required double newExportPrice,
    String? updatedBy,
  }) async {
    final batch = _firestore.batch();

    // Update product prices
    batch.update(_collection.doc(productId), {
      'import_price': newImportPrice,
      'export_price': newExportPrice,
      'updated_at': FieldValue.serverTimestamp(),
      'updated_by': updatedBy,
    });

    // Record price history
    final priceRef = _collection
        .doc(productId)
        .collection(FirestorePaths.priceHistory)
        .doc();
    batch.set(priceRef, {
      'import_price': newImportPrice,
      'export_price': newExportPrice,
      'updated_by': updatedBy,
      'recorded_at': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }
}

