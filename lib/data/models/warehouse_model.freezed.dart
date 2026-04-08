// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'warehouse_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WarehouseModel {

 String get id; String get name; String? get address; double? get area; int? get capacity; String? get notes;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson) DateTime get createdAt;@JsonKey(name: 'updated_at', fromJson: timestampFromJson, toJson: timestampToJson) DateTime get updatedAt;@JsonKey(name: 'updated_by') String? get updatedBy;
/// Create a copy of WarehouseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WarehouseModelCopyWith<WarehouseModel> get copyWith => _$WarehouseModelCopyWithImpl<WarehouseModel>(this as WarehouseModel, _$identity);

  /// Serializes this WarehouseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WarehouseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.area, area) || other.area == area)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,address,area,capacity,notes,isActive,createdAt,updatedAt,updatedBy);

@override
String toString() {
  return 'WarehouseModel(id: $id, name: $name, address: $address, area: $area, capacity: $capacity, notes: $notes, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, updatedBy: $updatedBy)';
}


}

/// @nodoc
abstract mixin class $WarehouseModelCopyWith<$Res>  {
  factory $WarehouseModelCopyWith(WarehouseModel value, $Res Function(WarehouseModel) _then) = _$WarehouseModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? address, double? area, int? capacity, String? notes,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson) DateTime createdAt,@JsonKey(name: 'updated_at', fromJson: timestampFromJson, toJson: timestampToJson) DateTime updatedAt,@JsonKey(name: 'updated_by') String? updatedBy
});




}
/// @nodoc
class _$WarehouseModelCopyWithImpl<$Res>
    implements $WarehouseModelCopyWith<$Res> {
  _$WarehouseModelCopyWithImpl(this._self, this._then);

  final WarehouseModel _self;
  final $Res Function(WarehouseModel) _then;

/// Create a copy of WarehouseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? address = freezed,Object? area = freezed,Object? capacity = freezed,Object? notes = freezed,Object? isActive = null,Object? createdAt = null,Object? updatedAt = null,Object? updatedBy = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as double?,capacity: freezed == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedBy: freezed == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WarehouseModel].
extension WarehouseModelPatterns on WarehouseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WarehouseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WarehouseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WarehouseModel value)  $default,){
final _that = this;
switch (_that) {
case _WarehouseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WarehouseModel value)?  $default,){
final _that = this;
switch (_that) {
case _WarehouseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? address,  double? area,  int? capacity,  String? notes, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson)  DateTime createdAt, @JsonKey(name: 'updated_at', fromJson: timestampFromJson, toJson: timestampToJson)  DateTime updatedAt, @JsonKey(name: 'updated_by')  String? updatedBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WarehouseModel() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.area,_that.capacity,_that.notes,_that.isActive,_that.createdAt,_that.updatedAt,_that.updatedBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? address,  double? area,  int? capacity,  String? notes, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson)  DateTime createdAt, @JsonKey(name: 'updated_at', fromJson: timestampFromJson, toJson: timestampToJson)  DateTime updatedAt, @JsonKey(name: 'updated_by')  String? updatedBy)  $default,) {final _that = this;
switch (_that) {
case _WarehouseModel():
return $default(_that.id,_that.name,_that.address,_that.area,_that.capacity,_that.notes,_that.isActive,_that.createdAt,_that.updatedAt,_that.updatedBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? address,  double? area,  int? capacity,  String? notes, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson)  DateTime createdAt, @JsonKey(name: 'updated_at', fromJson: timestampFromJson, toJson: timestampToJson)  DateTime updatedAt, @JsonKey(name: 'updated_by')  String? updatedBy)?  $default,) {final _that = this;
switch (_that) {
case _WarehouseModel() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.area,_that.capacity,_that.notes,_that.isActive,_that.createdAt,_that.updatedAt,_that.updatedBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WarehouseModel implements WarehouseModel {
  const _WarehouseModel({this.id = '', required this.name, this.address, this.area, this.capacity, this.notes, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson) required this.createdAt, @JsonKey(name: 'updated_at', fromJson: timestampFromJson, toJson: timestampToJson) required this.updatedAt, @JsonKey(name: 'updated_by') this.updatedBy});
  factory _WarehouseModel.fromJson(Map<String, dynamic> json) => _$WarehouseModelFromJson(json);

@override@JsonKey() final  String id;
@override final  String name;
@override final  String? address;
@override final  double? area;
@override final  int? capacity;
@override final  String? notes;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson) final  DateTime createdAt;
@override@JsonKey(name: 'updated_at', fromJson: timestampFromJson, toJson: timestampToJson) final  DateTime updatedAt;
@override@JsonKey(name: 'updated_by') final  String? updatedBy;

/// Create a copy of WarehouseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WarehouseModelCopyWith<_WarehouseModel> get copyWith => __$WarehouseModelCopyWithImpl<_WarehouseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WarehouseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WarehouseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.area, area) || other.area == area)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,address,area,capacity,notes,isActive,createdAt,updatedAt,updatedBy);

@override
String toString() {
  return 'WarehouseModel(id: $id, name: $name, address: $address, area: $area, capacity: $capacity, notes: $notes, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, updatedBy: $updatedBy)';
}


}

/// @nodoc
abstract mixin class _$WarehouseModelCopyWith<$Res> implements $WarehouseModelCopyWith<$Res> {
  factory _$WarehouseModelCopyWith(_WarehouseModel value, $Res Function(_WarehouseModel) _then) = __$WarehouseModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? address, double? area, int? capacity, String? notes,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson) DateTime createdAt,@JsonKey(name: 'updated_at', fromJson: timestampFromJson, toJson: timestampToJson) DateTime updatedAt,@JsonKey(name: 'updated_by') String? updatedBy
});




}
/// @nodoc
class __$WarehouseModelCopyWithImpl<$Res>
    implements _$WarehouseModelCopyWith<$Res> {
  __$WarehouseModelCopyWithImpl(this._self, this._then);

  final _WarehouseModel _self;
  final $Res Function(_WarehouseModel) _then;

/// Create a copy of WarehouseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? address = freezed,Object? area = freezed,Object? capacity = freezed,Object? notes = freezed,Object? isActive = null,Object? createdAt = null,Object? updatedAt = null,Object? updatedBy = freezed,}) {
  return _then(_WarehouseModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as double?,capacity: freezed == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedBy: freezed == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
