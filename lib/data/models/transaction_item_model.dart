import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_item_model.freezed.dart';
part 'transaction_item_model.g.dart';

/// Transaction item with SNAPSHOT pricing at time of transaction
@freezed
abstract class TransactionItemModel with _$TransactionItemModel {
  const factory TransactionItemModel({
    @Default('') String id,
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'product_name') required String productName,
    @Default('') String category,
    @JsonKey(name: 'regulation_class') @Default('') String regulationClass,
    required int quantity,
    @JsonKey(name: 'unit_price_at_time') required double unitPriceAtTime,
    required double subtotal,
  }) = _TransactionItemModel;

  factory TransactionItemModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionItemModelFromJson(json);

  factory TransactionItemModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TransactionItemModel.fromJson({...data, 'id': doc.id});
  }
}
