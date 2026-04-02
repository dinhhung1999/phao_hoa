// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_snapshot_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InventorySnapshotModel {

 String get id;@JsonKey(name: 'date', fromJson: timestampFromJson, toJson: timestampToJson) DateTime get date;@JsonKey(name: 'created_by') String get createdBy; String get status; String? get notes;@JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson) DateTime get createdAt;
/// Create a copy of InventorySnapshotModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventorySnapshotModelCopyWith<InventorySnapshotModel> get copyWith => _$InventorySnapshotModelCopyWithImpl<InventorySnapshotModel>(this as InventorySnapshotModel, _$identity);

  /// Serializes this InventorySnapshotModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventorySnapshotModel&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.status, status) || other.status == status)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,createdBy,status,notes,createdAt);

@override
String toString() {
  return 'InventorySnapshotModel(id: $id, date: $date, createdBy: $createdBy, status: $status, notes: $notes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $InventorySnapshotModelCopyWith<$Res>  {
  factory $InventorySnapshotModelCopyWith(InventorySnapshotModel value, $Res Function(InventorySnapshotModel) _then) = _$InventorySnapshotModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'date', fromJson: timestampFromJson, toJson: timestampToJson) DateTime date,@JsonKey(name: 'created_by') String createdBy, String status, String? notes,@JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson) DateTime createdAt
});




}
/// @nodoc
class _$InventorySnapshotModelCopyWithImpl<$Res>
    implements $InventorySnapshotModelCopyWith<$Res> {
  _$InventorySnapshotModelCopyWithImpl(this._self, this._then);

  final InventorySnapshotModel _self;
  final $Res Function(InventorySnapshotModel) _then;

/// Create a copy of InventorySnapshotModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? date = null,Object? createdBy = null,Object? status = null,Object? notes = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [InventorySnapshotModel].
extension InventorySnapshotModelPatterns on InventorySnapshotModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventorySnapshotModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventorySnapshotModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventorySnapshotModel value)  $default,){
final _that = this;
switch (_that) {
case _InventorySnapshotModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventorySnapshotModel value)?  $default,){
final _that = this;
switch (_that) {
case _InventorySnapshotModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'date', fromJson: timestampFromJson, toJson: timestampToJson)  DateTime date, @JsonKey(name: 'created_by')  String createdBy,  String status,  String? notes, @JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson)  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventorySnapshotModel() when $default != null:
return $default(_that.id,_that.date,_that.createdBy,_that.status,_that.notes,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'date', fromJson: timestampFromJson, toJson: timestampToJson)  DateTime date, @JsonKey(name: 'created_by')  String createdBy,  String status,  String? notes, @JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson)  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _InventorySnapshotModel():
return $default(_that.id,_that.date,_that.createdBy,_that.status,_that.notes,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'date', fromJson: timestampFromJson, toJson: timestampToJson)  DateTime date, @JsonKey(name: 'created_by')  String createdBy,  String status,  String? notes, @JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson)  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _InventorySnapshotModel() when $default != null:
return $default(_that.id,_that.date,_that.createdBy,_that.status,_that.notes,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InventorySnapshotModel implements InventorySnapshotModel {
  const _InventorySnapshotModel({this.id = '', @JsonKey(name: 'date', fromJson: timestampFromJson, toJson: timestampToJson) required this.date, @JsonKey(name: 'created_by') required this.createdBy, required this.status, this.notes, @JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson) required this.createdAt});
  factory _InventorySnapshotModel.fromJson(Map<String, dynamic> json) => _$InventorySnapshotModelFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey(name: 'date', fromJson: timestampFromJson, toJson: timestampToJson) final  DateTime date;
@override@JsonKey(name: 'created_by') final  String createdBy;
@override final  String status;
@override final  String? notes;
@override@JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson) final  DateTime createdAt;

/// Create a copy of InventorySnapshotModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventorySnapshotModelCopyWith<_InventorySnapshotModel> get copyWith => __$InventorySnapshotModelCopyWithImpl<_InventorySnapshotModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventorySnapshotModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventorySnapshotModel&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.status, status) || other.status == status)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,createdBy,status,notes,createdAt);

@override
String toString() {
  return 'InventorySnapshotModel(id: $id, date: $date, createdBy: $createdBy, status: $status, notes: $notes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$InventorySnapshotModelCopyWith<$Res> implements $InventorySnapshotModelCopyWith<$Res> {
  factory _$InventorySnapshotModelCopyWith(_InventorySnapshotModel value, $Res Function(_InventorySnapshotModel) _then) = __$InventorySnapshotModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'date', fromJson: timestampFromJson, toJson: timestampToJson) DateTime date,@JsonKey(name: 'created_by') String createdBy, String status, String? notes,@JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson) DateTime createdAt
});




}
/// @nodoc
class __$InventorySnapshotModelCopyWithImpl<$Res>
    implements _$InventorySnapshotModelCopyWith<$Res> {
  __$InventorySnapshotModelCopyWithImpl(this._self, this._then);

  final _InventorySnapshotModel _self;
  final $Res Function(_InventorySnapshotModel) _then;

/// Create a copy of InventorySnapshotModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,Object? createdBy = null,Object? status = null,Object? notes = freezed,Object? createdAt = null,}) {
  return _then(_InventorySnapshotModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
