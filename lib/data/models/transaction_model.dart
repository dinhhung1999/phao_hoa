import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/utils/firestore_converters.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
abstract class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    @Default('') String id,
    required String type,
    @JsonKey(name: 'customer_id') String? customerId,
    @JsonKey(name: 'customer_name') required String customerName,
    @JsonKey(name: 'customer_type') required String customerType,
    @JsonKey(name: 'warehouse_location') required String warehouseLocation,
    @JsonKey(name: 'is_debt') @Default(false) bool isDebt,
    @JsonKey(name: 'total_quantity') @Default(0) int totalQuantity,
    @JsonKey(name: 'total_value') required double totalValue,
    @JsonKey(name: 'paid_amount') required double paidAmount,
    @JsonKey(name: 'items_summary') @Default([]) List<Map<String, dynamic>> itemsSummary,
    String? note,
    @JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson)
    required DateTime createdAt,
    @JsonKey(name: 'created_by') required String createdBy,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TransactionModel.fromJson({...data, 'id': doc.id});
  }
}


