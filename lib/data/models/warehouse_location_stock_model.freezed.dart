// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'warehouse_location_stock_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WarehouseLocationStockModel {

 String get id;@JsonKey(name: 'product_id') String get productId;@JsonKey(name: 'product_name') String get productName;@JsonKey(name: 'total_quantity') int get totalQuantity;@JsonKey(name: 'stock_by_location') Map<String, int> get stockByLocation;@JsonKey(name: 'last_updated', fromJson: timestampFromJson, toJson: timestampToJson) DateTime get lastUpdated;@JsonKey(name: 'updated_by') String? get updatedBy;
/// Create a copy of WarehouseLocationStockModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WarehouseLocationStockModelCopyWith<WarehouseLocationStockModel> get copyWith => _$WarehouseLocationStockModelCopyWithImpl<WarehouseLocationStockModel>(this as WarehouseLocationStockModel, _$identity);

  /// Serializes this WarehouseLocationStockModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WarehouseLocationStockModel&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.totalQuantity, totalQuantity) || other.totalQuantity == totalQuantity)&&const DeepCollectionEquality().equals(other.stockByLocation, stockByLocation)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,productName,totalQuantity,const DeepCollectionEquality().hash(stockByLocation),lastUpdated,updatedBy);

@override
String toString() {
  return 'WarehouseLocationStockModel(id: $id, productId: $productId, productName: $productName, totalQuantity: $totalQuantity, stockByLocation: $stockByLocation, lastUpdated: $lastUpdated, updatedBy: $updatedBy)';
}


}

/// @nodoc
abstract mixin class $WarehouseLocationStockModelCopyWith<$Res>  {
  factory $WarehouseLocationStockModelCopyWith(WarehouseLocationStockModel value, $Res Function(WarehouseLocationStockModel) _then) = _$WarehouseLocationStockModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'product_name') String productName,@JsonKey(name: 'total_quantity') int totalQuantity,@JsonKey(name: 'stock_by_location') Map<String, int> stockByLocation,@JsonKey(name: 'last_updated', fromJson: timestampFromJson, toJson: timestampToJson) DateTime lastUpdated,@JsonKey(name: 'updated_by') String? updatedBy
});




}
/// @nodoc
class _$WarehouseLocationStockModelCopyWithImpl<$Res>
    implements $WarehouseLocationStockModelCopyWith<$Res> {
  _$WarehouseLocationStockModelCopyWithImpl(this._self, this._then);

  final WarehouseLocationStockModel _self;
  final $Res Function(WarehouseLocationStockModel) _then;

/// Create a copy of WarehouseLocationStockModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productId = null,Object? productName = null,Object? totalQuantity = null,Object? stockByLocation = null,Object? lastUpdated = null,Object? updatedBy = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,totalQuantity: null == totalQuantity ? _self.totalQuantity : totalQuantity // ignore: cast_nullable_to_non_nullable
as int,stockByLocation: null == stockByLocation ? _self.stockByLocation : stockByLocation // ignore: cast_nullable_to_non_nullable
as Map<String, int>,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,updatedBy: freezed == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WarehouseLocationStockModel].
extension WarehouseLocationStockModelPatterns on WarehouseLocationStockModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WarehouseLocationStockModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WarehouseLocationStockModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WarehouseLocationStockModel value)  $default,){
final _that = this;
switch (_that) {
case _WarehouseLocationStockModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WarehouseLocationStockModel value)?  $default,){
final _that = this;
switch (_that) {
case _WarehouseLocationStockModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'product_name')  String productName, @JsonKey(name: 'total_quantity')  int totalQuantity, @JsonKey(name: 'stock_by_location')  Map<String, int> stockByLocation, @JsonKey(name: 'last_updated', fromJson: timestampFromJson, toJson: timestampToJson)  DateTime lastUpdated, @JsonKey(name: 'updated_by')  String? updatedBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WarehouseLocationStockModel() when $default != null:
return $default(_that.id,_that.productId,_that.productName,_that.totalQuantity,_that.stockByLocation,_that.lastUpdated,_that.updatedBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'product_name')  String productName, @JsonKey(name: 'total_quantity')  int totalQuantity, @JsonKey(name: 'stock_by_location')  Map<String, int> stockByLocation, @JsonKey(name: 'last_updated', fromJson: timestampFromJson, toJson: timestampToJson)  DateTime lastUpdated, @JsonKey(name: 'updated_by')  String? updatedBy)  $default,) {final _that = this;
switch (_that) {
case _WarehouseLocationStockModel():
return $default(_that.id,_that.productId,_that.productName,_that.totalQuantity,_that.stockByLocation,_that.lastUpdated,_that.updatedBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'product_name')  String productName, @JsonKey(name: 'total_quantity')  int totalQuantity, @JsonKey(name: 'stock_by_location')  Map<String, int> stockByLocation, @JsonKey(name: 'last_updated', fromJson: timestampFromJson, toJson: timestampToJson)  DateTime lastUpdated, @JsonKey(name: 'updated_by')  String? updatedBy)?  $default,) {final _that = this;
switch (_that) {
case _WarehouseLocationStockModel() when $default != null:
return $default(_that.id,_that.productId,_that.productName,_that.totalQuantity,_that.stockByLocation,_that.lastUpdated,_that.updatedBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WarehouseLocationStockModel implements WarehouseLocationStockModel {
  const _WarehouseLocationStockModel({this.id = '', @JsonKey(name: 'product_id') required this.productId, @JsonKey(name: 'product_name') required this.productName, @JsonKey(name: 'total_quantity') required this.totalQuantity, @JsonKey(name: 'stock_by_location') required final  Map<String, int> stockByLocation, @JsonKey(name: 'last_updated', fromJson: timestampFromJson, toJson: timestampToJson) required this.lastUpdated, @JsonKey(name: 'updated_by') this.updatedBy}): _stockByLocation = stockByLocation;
  factory _WarehouseLocationStockModel.fromJson(Map<String, dynamic> json) => _$WarehouseLocationStockModelFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey(name: 'product_id') final  String productId;
@override@JsonKey(name: 'product_name') final  String productName;
@override@JsonKey(name: 'total_quantity') final  int totalQuantity;
 final  Map<String, int> _stockByLocation;
@override@JsonKey(name: 'stock_by_location') Map<String, int> get stockByLocation {
  if (_stockByLocation is EqualUnmodifiableMapView) return _stockByLocation;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_stockByLocation);
}

@override@JsonKey(name: 'last_updated', fromJson: timestampFromJson, toJson: timestampToJson) final  DateTime lastUpdated;
@override@JsonKey(name: 'updated_by') final  String? updatedBy;

/// Create a copy of WarehouseLocationStockModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WarehouseLocationStockModelCopyWith<_WarehouseLocationStockModel> get copyWith => __$WarehouseLocationStockModelCopyWithImpl<_WarehouseLocationStockModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WarehouseLocationStockModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WarehouseLocationStockModel&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.totalQuantity, totalQuantity) || other.totalQuantity == totalQuantity)&&const DeepCollectionEquality().equals(other._stockByLocation, _stockByLocation)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,productName,totalQuantity,const DeepCollectionEquality().hash(_stockByLocation),lastUpdated,updatedBy);

@override
String toString() {
  return 'WarehouseLocationStockModel(id: $id, productId: $productId, productName: $productName, totalQuantity: $totalQuantity, stockByLocation: $stockByLocation, lastUpdated: $lastUpdated, updatedBy: $updatedBy)';
}


}

/// @nodoc
abstract mixin class _$WarehouseLocationStockModelCopyWith<$Res> implements $WarehouseLocationStockModelCopyWith<$Res> {
  factory _$WarehouseLocationStockModelCopyWith(_WarehouseLocationStockModel value, $Res Function(_WarehouseLocationStockModel) _then) = __$WarehouseLocationStockModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'product_name') String productName,@JsonKey(name: 'total_quantity') int totalQuantity,@JsonKey(name: 'stock_by_location') Map<String, int> stockByLocation,@JsonKey(name: 'last_updated', fromJson: timestampFromJson, toJson: timestampToJson) DateTime lastUpdated,@JsonKey(name: 'updated_by') String? updatedBy
});




}
/// @nodoc
class __$WarehouseLocationStockModelCopyWithImpl<$Res>
    implements _$WarehouseLocationStockModelCopyWith<$Res> {
  __$WarehouseLocationStockModelCopyWithImpl(this._self, this._then);

  final _WarehouseLocationStockModel _self;
  final $Res Function(_WarehouseLocationStockModel) _then;

/// Create a copy of WarehouseLocationStockModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productId = null,Object? productName = null,Object? totalQuantity = null,Object? stockByLocation = null,Object? lastUpdated = null,Object? updatedBy = freezed,}) {
  return _then(_WarehouseLocationStockModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,totalQuantity: null == totalQuantity ? _self.totalQuantity : totalQuantity // ignore: cast_nullable_to_non_nullable
as int,stockByLocation: null == stockByLocation ? _self._stockByLocation : stockByLocation // ignore: cast_nullable_to_non_nullable
as Map<String, int>,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,updatedBy: freezed == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
