// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionModel {

 String get id; String get type;@JsonKey(name: 'customer_id') String? get customerId;@JsonKey(name: 'customer_name') String get customerName;@JsonKey(name: 'customer_type') String get customerType;@JsonKey(name: 'warehouse_location') String get warehouseLocation;@JsonKey(name: 'is_debt') bool get isDebt;@JsonKey(name: 'total_quantity') int get totalQuantity;@JsonKey(name: 'total_value') double get totalValue;@JsonKey(name: 'paid_amount') double get paidAmount;@JsonKey(name: 'items_summary') List<Map<String, dynamic>> get itemsSummary; String? get note;@JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson) DateTime get createdAt;@JsonKey(name: 'created_by') String get createdBy;
/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionModelCopyWith<TransactionModel> get copyWith => _$TransactionModelCopyWithImpl<TransactionModel>(this as TransactionModel, _$identity);

  /// Serializes this TransactionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.customerType, customerType) || other.customerType == customerType)&&(identical(other.warehouseLocation, warehouseLocation) || other.warehouseLocation == warehouseLocation)&&(identical(other.isDebt, isDebt) || other.isDebt == isDebt)&&(identical(other.totalQuantity, totalQuantity) || other.totalQuantity == totalQuantity)&&(identical(other.totalValue, totalValue) || other.totalValue == totalValue)&&(identical(other.paidAmount, paidAmount) || other.paidAmount == paidAmount)&&const DeepCollectionEquality().equals(other.itemsSummary, itemsSummary)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,customerId,customerName,customerType,warehouseLocation,isDebt,totalQuantity,totalValue,paidAmount,const DeepCollectionEquality().hash(itemsSummary),note,createdAt,createdBy);

@override
String toString() {
  return 'TransactionModel(id: $id, type: $type, customerId: $customerId, customerName: $customerName, customerType: $customerType, warehouseLocation: $warehouseLocation, isDebt: $isDebt, totalQuantity: $totalQuantity, totalValue: $totalValue, paidAmount: $paidAmount, itemsSummary: $itemsSummary, note: $note, createdAt: $createdAt, createdBy: $createdBy)';
}


}

/// @nodoc
abstract mixin class $TransactionModelCopyWith<$Res>  {
  factory $TransactionModelCopyWith(TransactionModel value, $Res Function(TransactionModel) _then) = _$TransactionModelCopyWithImpl;
@useResult
$Res call({
 String id, String type,@JsonKey(name: 'customer_id') String? customerId,@JsonKey(name: 'customer_name') String customerName,@JsonKey(name: 'customer_type') String customerType,@JsonKey(name: 'warehouse_location') String warehouseLocation,@JsonKey(name: 'is_debt') bool isDebt,@JsonKey(name: 'total_quantity') int totalQuantity,@JsonKey(name: 'total_value') double totalValue,@JsonKey(name: 'paid_amount') double paidAmount,@JsonKey(name: 'items_summary') List<Map<String, dynamic>> itemsSummary, String? note,@JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson) DateTime createdAt,@JsonKey(name: 'created_by') String createdBy
});




}
/// @nodoc
class _$TransactionModelCopyWithImpl<$Res>
    implements $TransactionModelCopyWith<$Res> {
  _$TransactionModelCopyWithImpl(this._self, this._then);

  final TransactionModel _self;
  final $Res Function(TransactionModel) _then;

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? customerId = freezed,Object? customerName = null,Object? customerType = null,Object? warehouseLocation = null,Object? isDebt = null,Object? totalQuantity = null,Object? totalValue = null,Object? paidAmount = null,Object? itemsSummary = null,Object? note = freezed,Object? createdAt = null,Object? createdBy = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,customerType: null == customerType ? _self.customerType : customerType // ignore: cast_nullable_to_non_nullable
as String,warehouseLocation: null == warehouseLocation ? _self.warehouseLocation : warehouseLocation // ignore: cast_nullable_to_non_nullable
as String,isDebt: null == isDebt ? _self.isDebt : isDebt // ignore: cast_nullable_to_non_nullable
as bool,totalQuantity: null == totalQuantity ? _self.totalQuantity : totalQuantity // ignore: cast_nullable_to_non_nullable
as int,totalValue: null == totalValue ? _self.totalValue : totalValue // ignore: cast_nullable_to_non_nullable
as double,paidAmount: null == paidAmount ? _self.paidAmount : paidAmount // ignore: cast_nullable_to_non_nullable
as double,itemsSummary: null == itemsSummary ? _self.itemsSummary : itemsSummary // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionModel].
extension TransactionModelPatterns on TransactionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionModel value)  $default,){
final _that = this;
switch (_that) {
case _TransactionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionModel value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type, @JsonKey(name: 'customer_id')  String? customerId, @JsonKey(name: 'customer_name')  String customerName, @JsonKey(name: 'customer_type')  String customerType, @JsonKey(name: 'warehouse_location')  String warehouseLocation, @JsonKey(name: 'is_debt')  bool isDebt, @JsonKey(name: 'total_quantity')  int totalQuantity, @JsonKey(name: 'total_value')  double totalValue, @JsonKey(name: 'paid_amount')  double paidAmount, @JsonKey(name: 'items_summary')  List<Map<String, dynamic>> itemsSummary,  String? note, @JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson)  DateTime createdAt, @JsonKey(name: 'created_by')  String createdBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
return $default(_that.id,_that.type,_that.customerId,_that.customerName,_that.customerType,_that.warehouseLocation,_that.isDebt,_that.totalQuantity,_that.totalValue,_that.paidAmount,_that.itemsSummary,_that.note,_that.createdAt,_that.createdBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type, @JsonKey(name: 'customer_id')  String? customerId, @JsonKey(name: 'customer_name')  String customerName, @JsonKey(name: 'customer_type')  String customerType, @JsonKey(name: 'warehouse_location')  String warehouseLocation, @JsonKey(name: 'is_debt')  bool isDebt, @JsonKey(name: 'total_quantity')  int totalQuantity, @JsonKey(name: 'total_value')  double totalValue, @JsonKey(name: 'paid_amount')  double paidAmount, @JsonKey(name: 'items_summary')  List<Map<String, dynamic>> itemsSummary,  String? note, @JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson)  DateTime createdAt, @JsonKey(name: 'created_by')  String createdBy)  $default,) {final _that = this;
switch (_that) {
case _TransactionModel():
return $default(_that.id,_that.type,_that.customerId,_that.customerName,_that.customerType,_that.warehouseLocation,_that.isDebt,_that.totalQuantity,_that.totalValue,_that.paidAmount,_that.itemsSummary,_that.note,_that.createdAt,_that.createdBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type, @JsonKey(name: 'customer_id')  String? customerId, @JsonKey(name: 'customer_name')  String customerName, @JsonKey(name: 'customer_type')  String customerType, @JsonKey(name: 'warehouse_location')  String warehouseLocation, @JsonKey(name: 'is_debt')  bool isDebt, @JsonKey(name: 'total_quantity')  int totalQuantity, @JsonKey(name: 'total_value')  double totalValue, @JsonKey(name: 'paid_amount')  double paidAmount, @JsonKey(name: 'items_summary')  List<Map<String, dynamic>> itemsSummary,  String? note, @JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson)  DateTime createdAt, @JsonKey(name: 'created_by')  String createdBy)?  $default,) {final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
return $default(_that.id,_that.type,_that.customerId,_that.customerName,_that.customerType,_that.warehouseLocation,_that.isDebt,_that.totalQuantity,_that.totalValue,_that.paidAmount,_that.itemsSummary,_that.note,_that.createdAt,_that.createdBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionModel implements TransactionModel {
  const _TransactionModel({this.id = '', required this.type, @JsonKey(name: 'customer_id') this.customerId, @JsonKey(name: 'customer_name') required this.customerName, @JsonKey(name: 'customer_type') required this.customerType, @JsonKey(name: 'warehouse_location') required this.warehouseLocation, @JsonKey(name: 'is_debt') this.isDebt = false, @JsonKey(name: 'total_quantity') this.totalQuantity = 0, @JsonKey(name: 'total_value') required this.totalValue, @JsonKey(name: 'paid_amount') required this.paidAmount, @JsonKey(name: 'items_summary') final  List<Map<String, dynamic>> itemsSummary = const [], this.note, @JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson) required this.createdAt, @JsonKey(name: 'created_by') required this.createdBy}): _itemsSummary = itemsSummary;
  factory _TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);

@override@JsonKey() final  String id;
@override final  String type;
@override@JsonKey(name: 'customer_id') final  String? customerId;
@override@JsonKey(name: 'customer_name') final  String customerName;
@override@JsonKey(name: 'customer_type') final  String customerType;
@override@JsonKey(name: 'warehouse_location') final  String warehouseLocation;
@override@JsonKey(name: 'is_debt') final  bool isDebt;
@override@JsonKey(name: 'total_quantity') final  int totalQuantity;
@override@JsonKey(name: 'total_value') final  double totalValue;
@override@JsonKey(name: 'paid_amount') final  double paidAmount;
 final  List<Map<String, dynamic>> _itemsSummary;
@override@JsonKey(name: 'items_summary') List<Map<String, dynamic>> get itemsSummary {
  if (_itemsSummary is EqualUnmodifiableListView) return _itemsSummary;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_itemsSummary);
}

@override final  String? note;
@override@JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson) final  DateTime createdAt;
@override@JsonKey(name: 'created_by') final  String createdBy;

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionModelCopyWith<_TransactionModel> get copyWith => __$TransactionModelCopyWithImpl<_TransactionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.customerType, customerType) || other.customerType == customerType)&&(identical(other.warehouseLocation, warehouseLocation) || other.warehouseLocation == warehouseLocation)&&(identical(other.isDebt, isDebt) || other.isDebt == isDebt)&&(identical(other.totalQuantity, totalQuantity) || other.totalQuantity == totalQuantity)&&(identical(other.totalValue, totalValue) || other.totalValue == totalValue)&&(identical(other.paidAmount, paidAmount) || other.paidAmount == paidAmount)&&const DeepCollectionEquality().equals(other._itemsSummary, _itemsSummary)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,customerId,customerName,customerType,warehouseLocation,isDebt,totalQuantity,totalValue,paidAmount,const DeepCollectionEquality().hash(_itemsSummary),note,createdAt,createdBy);

@override
String toString() {
  return 'TransactionModel(id: $id, type: $type, customerId: $customerId, customerName: $customerName, customerType: $customerType, warehouseLocation: $warehouseLocation, isDebt: $isDebt, totalQuantity: $totalQuantity, totalValue: $totalValue, paidAmount: $paidAmount, itemsSummary: $itemsSummary, note: $note, createdAt: $createdAt, createdBy: $createdBy)';
}


}

/// @nodoc
abstract mixin class _$TransactionModelCopyWith<$Res> implements $TransactionModelCopyWith<$Res> {
  factory _$TransactionModelCopyWith(_TransactionModel value, $Res Function(_TransactionModel) _then) = __$TransactionModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String type,@JsonKey(name: 'customer_id') String? customerId,@JsonKey(name: 'customer_name') String customerName,@JsonKey(name: 'customer_type') String customerType,@JsonKey(name: 'warehouse_location') String warehouseLocation,@JsonKey(name: 'is_debt') bool isDebt,@JsonKey(name: 'total_quantity') int totalQuantity,@JsonKey(name: 'total_value') double totalValue,@JsonKey(name: 'paid_amount') double paidAmount,@JsonKey(name: 'items_summary') List<Map<String, dynamic>> itemsSummary, String? note,@JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson) DateTime createdAt,@JsonKey(name: 'created_by') String createdBy
});




}
/// @nodoc
class __$TransactionModelCopyWithImpl<$Res>
    implements _$TransactionModelCopyWith<$Res> {
  __$TransactionModelCopyWithImpl(this._self, this._then);

  final _TransactionModel _self;
  final $Res Function(_TransactionModel) _then;

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? customerId = freezed,Object? customerName = null,Object? customerType = null,Object? warehouseLocation = null,Object? isDebt = null,Object? totalQuantity = null,Object? totalValue = null,Object? paidAmount = null,Object? itemsSummary = null,Object? note = freezed,Object? createdAt = null,Object? createdBy = null,}) {
  return _then(_TransactionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,customerType: null == customerType ? _self.customerType : customerType // ignore: cast_nullable_to_non_nullable
as String,warehouseLocation: null == warehouseLocation ? _self.warehouseLocation : warehouseLocation // ignore: cast_nullable_to_non_nullable
as String,isDebt: null == isDebt ? _self.isDebt : isDebt // ignore: cast_nullable_to_non_nullable
as bool,totalQuantity: null == totalQuantity ? _self.totalQuantity : totalQuantity // ignore: cast_nullable_to_non_nullable
as int,totalValue: null == totalValue ? _self.totalValue : totalValue // ignore: cast_nullable_to_non_nullable
as double,paidAmount: null == paidAmount ? _self.paidAmount : paidAmount // ignore: cast_nullable_to_non_nullable
as double,itemsSummary: null == itemsSummary ? _self._itemsSummary : itemsSummary // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
