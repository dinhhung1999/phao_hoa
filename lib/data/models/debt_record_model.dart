import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/utils/firestore_converters.dart';

part 'debt_record_model.freezed.dart';
part 'debt_record_model.g.dart';

@freezed
abstract class DebtRecordModel with _$DebtRecordModel {
  const factory DebtRecordModel({
    @Default('') String id,
    @JsonKey(name: 'transaction_id') String? transactionId,
    required String type, // 'debt' | 'payment'
    required double amount,
    @JsonKey(name: 'running_balance') required double runningBalance,
    String? note,
    @JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson)
    required DateTime createdAt,
  }) = _DebtRecordModel;

  factory DebtRecordModel.fromJson(Map<String, dynamic> json) =>
      _$DebtRecordModelFromJson(json);

  factory DebtRecordModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DebtRecordModel.fromJson({...data, 'id': doc.id});
  }
}


