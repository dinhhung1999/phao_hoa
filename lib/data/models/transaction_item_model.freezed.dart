// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionItemModel {

 String get id;@JsonKey(name: 'product_id') String get productId;@JsonKey(name: 'product_name') String get productName; String get category;@JsonKey(name: 'regulation_class') String get regulationClass; int get quantity;@JsonKey(name: 'unit_price_at_time') double get unitPriceAtTime; double get subtotal;
/// Create a copy of TransactionItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionItemModelCopyWith<TransactionItemModel> get copyWith => _$TransactionItemModelCopyWithImpl<TransactionItemModel>(this as TransactionItemModel, _$identity);

  /// Serializes this TransactionItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.category, category) || other.category == category)&&(identical(other.regulationClass, regulationClass) || other.regulationClass == regulationClass)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPriceAtTime, unitPriceAtTime) || other.unitPriceAtTime == unitPriceAtTime)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,productName,category,regulationClass,quantity,unitPriceAtTime,subtotal);

@override
String toString() {
  return 'TransactionItemModel(id: $id, productId: $productId, productName: $productName, category: $category, regulationClass: $regulationClass, quantity: $quantity, unitPriceAtTime: $unitPriceAtTime, subtotal: $subtotal)';
}


}

/// @nodoc
abstract mixin class $TransactionItemModelCopyWith<$Res>  {
  factory $TransactionItemModelCopyWith(TransactionItemModel value, $Res Function(TransactionItemModel) _then) = _$TransactionItemModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'product_name') String productName, String category,@JsonKey(name: 'regulation_class') String regulationClass, int quantity,@JsonKey(name: 'unit_price_at_time') double unitPriceAtTime, double subtotal
});




}
/// @nodoc
class _$TransactionItemModelCopyWithImpl<$Res>
    implements $TransactionItemModelCopyWith<$Res> {
  _$TransactionItemModelCopyWithImpl(this._self, this._then);

  final TransactionItemModel _self;
  final $Res Function(TransactionItemModel) _then;

/// Create a copy of TransactionItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productId = null,Object? productName = null,Object? category = null,Object? regulationClass = null,Object? quantity = null,Object? unitPriceAtTime = null,Object? subtotal = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,regulationClass: null == regulationClass ? _self.regulationClass : regulationClass // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPriceAtTime: null == unitPriceAtTime ? _self.unitPriceAtTime : unitPriceAtTime // ignore: cast_nullable_to_non_nullable
as double,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionItemModel].
extension TransactionItemModelPatterns on TransactionItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionItemModel value)  $default,){
final _that = this;
switch (_that) {
case _TransactionItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'product_name')  String productName,  String category, @JsonKey(name: 'regulation_class')  String regulationClass,  int quantity, @JsonKey(name: 'unit_price_at_time')  double unitPriceAtTime,  double subtotal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionItemModel() when $default != null:
return $default(_that.id,_that.productId,_that.productName,_that.category,_that.regulationClass,_that.quantity,_that.unitPriceAtTime,_that.subtotal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'product_name')  String productName,  String category, @JsonKey(name: 'regulation_class')  String regulationClass,  int quantity, @JsonKey(name: 'unit_price_at_time')  double unitPriceAtTime,  double subtotal)  $default,) {final _that = this;
switch (_that) {
case _TransactionItemModel():
return $default(_that.id,_that.productId,_that.productName,_that.category,_that.regulationClass,_that.quantity,_that.unitPriceAtTime,_that.subtotal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'product_name')  String productName,  String category, @JsonKey(name: 'regulation_class')  String regulationClass,  int quantity, @JsonKey(name: 'unit_price_at_time')  double unitPriceAtTime,  double subtotal)?  $default,) {final _that = this;
switch (_that) {
case _TransactionItemModel() when $default != null:
return $default(_that.id,_that.productId,_that.productName,_that.category,_that.regulationClass,_that.quantity,_that.unitPriceAtTime,_that.subtotal);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionItemModel implements TransactionItemModel {
  const _TransactionItemModel({this.id = '', @JsonKey(name: 'product_id') required this.productId, @JsonKey(name: 'product_name') required this.productName, required this.category, @JsonKey(name: 'regulation_class') required this.regulationClass, required this.quantity, @JsonKey(name: 'unit_price_at_time') required this.unitPriceAtTime, required this.subtotal});
  factory _TransactionItemModel.fromJson(Map<String, dynamic> json) => _$TransactionItemModelFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey(name: 'product_id') final  String productId;
@override@JsonKey(name: 'product_name') final  String productName;
@override final  String category;
@override@JsonKey(name: 'regulation_class') final  String regulationClass;
@override final  int quantity;
@override@JsonKey(name: 'unit_price_at_time') final  double unitPriceAtTime;
@override final  double subtotal;

/// Create a copy of TransactionItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionItemModelCopyWith<_TransactionItemModel> get copyWith => __$TransactionItemModelCopyWithImpl<_TransactionItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.category, category) || other.category == category)&&(identical(other.regulationClass, regulationClass) || other.regulationClass == regulationClass)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPriceAtTime, unitPriceAtTime) || other.unitPriceAtTime == unitPriceAtTime)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,productName,category,regulationClass,quantity,unitPriceAtTime,subtotal);

@override
String toString() {
  return 'TransactionItemModel(id: $id, productId: $productId, productName: $productName, category: $category, regulationClass: $regulationClass, quantity: $quantity, unitPriceAtTime: $unitPriceAtTime, subtotal: $subtotal)';
}


}

/// @nodoc
abstract mixin class _$TransactionItemModelCopyWith<$Res> implements $TransactionItemModelCopyWith<$Res> {
  factory _$TransactionItemModelCopyWith(_TransactionItemModel value, $Res Function(_TransactionItemModel) _then) = __$TransactionItemModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'product_name') String productName, String category,@JsonKey(name: 'regulation_class') String regulationClass, int quantity,@JsonKey(name: 'unit_price_at_time') double unitPriceAtTime, double subtotal
});




}
/// @nodoc
class __$TransactionItemModelCopyWithImpl<$Res>
    implements _$TransactionItemModelCopyWith<$Res> {
  __$TransactionItemModelCopyWithImpl(this._self, this._then);

  final _TransactionItemModel _self;
  final $Res Function(_TransactionItemModel) _then;

/// Create a copy of TransactionItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productId = null,Object? productName = null,Object? category = null,Object? regulationClass = null,Object? quantity = null,Object? unitPriceAtTime = null,Object? subtotal = null,}) {
  return _then(_TransactionItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,regulationClass: null == regulationClass ? _self.regulationClass : regulationClass // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPriceAtTime: null == unitPriceAtTime ? _self.unitPriceAtTime : unitPriceAtTime // ignore: cast_nullable_to_non_nullable
as double,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
