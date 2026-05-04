import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/firestore_paths.dart';
import '../models/product_formula_model.dart';

/// Firestore data source for Product Formulas
class FormulaRemoteDatasource {
  final FirebaseFirestore _firestore;

  FormulaRemoteDatasource(this._firestore);

  CollectionReference get _collection =>
      _firestore.collection(FirestorePaths.productFormulas);

  /// Get all active formulas
  Future<List<ProductFormulaModel>> getAllFormulas() async {
    final snapshot = await _collection
        .where('is_active', isEqualTo: true)
        .get();
    return snapshot.docs
        .map((d) => ProductFormulaModel.fromFirestore(d))
        .toList();
  }

  /// Stream all active formulas
  Stream<List<ProductFormulaModel>> watchAllFormulas() {
    return _collection
        .where('is_active', isEqualTo: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => ProductFormulaModel.fromFirestore(d))
            .toList());
  }

  /// Get formula for a specific product
  Future<ProductFormulaModel?> getFormulaByProductId(String productId) async {
    final snapshot = await _collection
        .where('product_id', isEqualTo: productId)
        .where('is_active', isEqualTo: true)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return ProductFormulaModel.fromFirestore(snapshot.docs.first);
  }

  /// Create or update a formula
  Future<String> saveFormula(ProductFormulaModel formula) async {
    final data = formula.toJson()..remove('id');
    data['updated_at'] = FieldValue.serverTimestamp();

    if (formula.id.isNotEmpty) {
      // Update existing
      await _collection.doc(formula.id).set(data);
      return formula.id;
    } else {
      // Create new
      final docRef = await _collection.add(data);
      return docRef.id;
    }
  }

  /// Soft-delete formula
  Future<void> deleteFormula(String formulaId) async {
    await _collection.doc(formulaId).update({
      'is_active': false,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }
}
