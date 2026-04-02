// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'debt_record_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DebtRecordModel {

 String get id;@JsonKey(name: 'transaction_id') String? get transactionId; String get type;// 'debt' | 'payment'
 double get amount;@JsonKey(name: 'running_balance') double get runningBalance; String? get note;@JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson) DateTime get createdAt;
/// Create a copy of DebtRecordModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DebtRecordModelCopyWith<DebtRecordModel> get copyWith => _$DebtRecordModelCopyWithImpl<DebtRecordModel>(this as DebtRecordModel, _$identity);

  /// Serializes this DebtRecordModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DebtRecordModel&&(identical(other.id, id) || other.id == id)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.runningBalance, runningBalance) || other.runningBalance == runningBalance)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,transactionId,type,amount,runningBalance,note,createdAt);

@override
String toString() {
  return 'DebtRecordModel(id: $id, transactionId: $transactionId, type: $type, amount: $amount, runningBalance: $runningBalance, note: $note, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $DebtRecordModelCopyWith<$Res>  {
  factory $DebtRecordModelCopyWith(DebtRecordModel value, $Res Function(DebtRecordModel) _then) = _$DebtRecordModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'transaction_id') String? transactionId, String type, double amount,@JsonKey(name: 'running_balance') double runningBalance, String? note,@JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson) DateTime createdAt
});




}
/// @nodoc
class _$DebtRecordModelCopyWithImpl<$Res>
    implements $DebtRecordModelCopyWith<$Res> {
  _$DebtRecordModelCopyWithImpl(this._self, this._then);

  final DebtRecordModel _self;
  final $Res Function(DebtRecordModel) _then;

/// Create a copy of DebtRecordModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? transactionId = freezed,Object? type = null,Object? amount = null,Object? runningBalance = null,Object? note = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,runningBalance: null == runningBalance ? _self.runningBalance : runningBalance // ignore: cast_nullable_to_non_nullable
as double,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DebtRecordModel].
extension DebtRecordModelPatterns on DebtRecordModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DebtRecordModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DebtRecordModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DebtRecordModel value)  $default,){
final _that = this;
switch (_that) {
case _DebtRecordModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DebtRecordModel value)?  $default,){
final _that = this;
switch (_that) {
case _DebtRecordModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'transaction_id')  String? transactionId,  String type,  double amount, @JsonKey(name: 'running_balance')  double runningBalance,  String? note, @JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson)  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DebtRecordModel() when $default != null:
return $default(_that.id,_that.transactionId,_that.type,_that.amount,_that.runningBalance,_that.note,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'transaction_id')  String? transactionId,  String type,  double amount, @JsonKey(name: 'running_balance')  double runningBalance,  String? note, @JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson)  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _DebtRecordModel():
return $default(_that.id,_that.transactionId,_that.type,_that.amount,_that.runningBalance,_that.note,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'transaction_id')  String? transactionId,  String type,  double amount, @JsonKey(name: 'running_balance')  double runningBalance,  String? note, @JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson)  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _DebtRecordModel() when $default != null:
return $default(_that.id,_that.transactionId,_that.type,_that.amount,_that.runningBalance,_that.note,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DebtRecordModel implements DebtRecordModel {
  const _DebtRecordModel({this.id = '', @JsonKey(name: 'transaction_id') this.transactionId, required this.type, required this.amount, @JsonKey(name: 'running_balance') required this.runningBalance, this.note, @JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson) required this.createdAt});
  factory _DebtRecordModel.fromJson(Map<String, dynamic> json) => _$DebtRecordModelFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey(name: 'transaction_id') final  String? transactionId;
@override final  String type;
// 'debt' | 'payment'
@override final  double amount;
@override@JsonKey(name: 'running_balance') final  double runningBalance;
@override final  String? note;
@override@JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson) final  DateTime createdAt;

/// Create a copy of DebtRecordModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DebtRecordModelCopyWith<_DebtRecordModel> get copyWith => __$DebtRecordModelCopyWithImpl<_DebtRecordModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DebtRecordModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DebtRecordModel&&(identical(other.id, id) || other.id == id)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.runningBalance, runningBalance) || other.runningBalance == runningBalance)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,transactionId,type,amount,runningBalance,note,createdAt);

@override
String toString() {
  return 'DebtRecordModel(id: $id, transactionId: $transactionId, type: $type, amount: $amount, runningBalance: $runningBalance, note: $note, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$DebtRecordModelCopyWith<$Res> implements $DebtRecordModelCopyWith<$Res> {
  factory _$DebtRecordModelCopyWith(_DebtRecordModel value, $Res Function(_DebtRecordModel) _then) = __$DebtRecordModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'transaction_id') String? transactionId, String type, double amount,@JsonKey(name: 'running_balance') double runningBalance, String? note,@JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson) DateTime createdAt
});




}
/// @nodoc
class __$DebtRecordModelCopyWithImpl<$Res>
    implements _$DebtRecordModelCopyWith<$Res> {
  __$DebtRecordModelCopyWithImpl(this._self, this._then);

  final _DebtRecordModel _self;
  final $Res Function(_DebtRecordModel) _then;

/// Create a copy of DebtRecordModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? transactionId = freezed,Object? type = null,Object? amount = null,Object? runningBalance = null,Object? note = freezed,Object? createdAt = null,}) {
  return _then(_DebtRecordModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,runningBalance: null == runningBalance ? _self.runningBalance : runningBalance // ignore: cast_nullable_to_non_nullable
as double,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
