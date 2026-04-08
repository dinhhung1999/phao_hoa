import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/firestore_paths.dart';
import '../models/customer_model.dart';
import '../models/debt_record_model.dart';

/// Firestore data source for Customers and Debt management
class CustomerRemoteDatasource {
  final FirebaseFirestore _firestore;

  CustomerRemoteDatasource(this._firestore);

  CollectionReference get _collection =>
      _firestore.collection(FirestorePaths.customers);

  /// Get all active customers
  Future<List<CustomerModel>> getAllCustomers() async {
    final snapshot =
        await _collection.where('is_active', isEqualTo: true).get();
    return snapshot.docs.map((d) => CustomerModel.fromFirestore(d)).toList();
  }

  /// Stream all active customers
  Stream<List<CustomerModel>> watchAllCustomers() {
    return _collection
        .where('is_active', isEqualTo: true)
        .orderBy('name')
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => CustomerModel.fromFirestore(d)).toList(),
        );
  }

  /// Get customers by type
  Future<List<CustomerModel>> getCustomersByType(String type) async {
    final snapshot = await _collection
        .where('type', isEqualTo: type)
        .where('is_active', isEqualTo: true)
        .get();
    return snapshot.docs.map((d) => CustomerModel.fromFirestore(d)).toList();
  }

  /// Add a new customer
  Future<String> addCustomer(CustomerModel customer) async {
    final data = customer.toJson()..remove('id');
    final docRef = await _collection.add(data);
    return docRef.id;
  }

  /// Update customer
  Future<void> updateCustomer(CustomerModel customer) async {
    final data = customer.toJson()..remove('id');
    await _collection.doc(customer.id).update(data);
  }

  /// Get debt records for a customer
  Future<List<DebtRecordModel>> getCustomerDebts(String customerId) async {
    final snapshot = await _collection
        .doc(customerId)
        .collection(FirestorePaths.debtRecords)
        .orderBy('created_at', descending: true)
        .get();
    return snapshot.docs
        .map((d) => DebtRecordModel.fromFirestore(d))
        .toList();
  }

  /// Make partial payment
  Future<void> makePartialPayment({
    required String customerId,
    required double amount,
    String? note,
  }) async {
    final batch = _firestore.batch();

    // Create payment record
    final debtRef = _collection
        .doc(customerId)
        .collection(FirestorePaths.debtRecords)
        .doc();
    batch.set(debtRef, {
      'type': 'payment',
      'amount': amount,
      'running_balance': 0, // Calculated read-side
      'note': note ?? 'Thanh toán một phần',
      'created_at': FieldValue.serverTimestamp(),
    });

    // Decrease total_debt
    batch.update(_collection.doc(customerId), {
      'total_debt': FieldValue.increment(-amount),
      'updated_at': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  /// Settle all debts (Tất toán công nợ)
  Future<void> settleAllDebts(String customerId) async {
    // Get current debt
    final doc = await _collection.doc(customerId).get();
    final data = doc.data() as Map<String, dynamic>;
    final totalDebt = (data['total_debt'] as num?)?.toDouble() ?? 0;

    if (totalDebt <= 0) return;

    final batch = _firestore.batch();

    // Create settlement record
    final debtRef = _collection
        .doc(customerId)
        .collection(FirestorePaths.debtRecords)
        .doc();
    batch.set(debtRef, {
      'type': 'payment',
      'amount': totalDebt,
      'running_balance': 0,
      'note': 'Tất toán công nợ',
      'created_at': FieldValue.serverTimestamp(),
    });

    // Reset total_debt to 0
    batch.update(_collection.doc(customerId), {
      'total_debt': 0,
      'updated_at': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  /// Soft-delete (deactivate) a customer
  Future<void> deactivateCustomer(String customerId) async {
    await _collection.doc(customerId).update({
      'is_active': false,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  /// Get customers with cursor-based pagination
  Future<(List<CustomerModel>, DocumentSnapshot?)> getCustomersPaginated({
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
    final models = snapshot.docs.map((d) => CustomerModel.fromFirestore(d)).toList();
    final lastDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

    return (models, lastDoc);
  }
}
