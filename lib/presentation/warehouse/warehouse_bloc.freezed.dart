// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'warehouse_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WarehouseEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WarehouseEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WarehouseEvent()';
}


}

/// @nodoc
class $WarehouseEventCopyWith<$Res>  {
$WarehouseEventCopyWith(WarehouseEvent _, $Res Function(WarehouseEvent) __);
}


/// Adds pattern-matching-related methods to [WarehouseEvent].
extension WarehouseEventPatterns on WarehouseEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _LoadWarehouses value)?  loadWarehouses,TResult Function( _AddWarehouse value)?  addWarehouse,TResult Function( _UpdateWarehouse value)?  updateWarehouse,TResult Function( _DeleteWarehouse value)?  deleteWarehouse,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoadWarehouses() when loadWarehouses != null:
return loadWarehouses(_that);case _AddWarehouse() when addWarehouse != null:
return addWarehouse(_that);case _UpdateWarehouse() when updateWarehouse != null:
return updateWarehouse(_that);case _DeleteWarehouse() when deleteWarehouse != null:
return deleteWarehouse(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _LoadWarehouses value)  loadWarehouses,required TResult Function( _AddWarehouse value)  addWarehouse,required TResult Function( _UpdateWarehouse value)  updateWarehouse,required TResult Function( _DeleteWarehouse value)  deleteWarehouse,}){
final _that = this;
switch (_that) {
case _LoadWarehouses():
return loadWarehouses(_that);case _AddWarehouse():
return addWarehouse(_that);case _UpdateWarehouse():
return updateWarehouse(_that);case _DeleteWarehouse():
return deleteWarehouse(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _LoadWarehouses value)?  loadWarehouses,TResult? Function( _AddWarehouse value)?  addWarehouse,TResult? Function( _UpdateWarehouse value)?  updateWarehouse,TResult? Function( _DeleteWarehouse value)?  deleteWarehouse,}){
final _that = this;
switch (_that) {
case _LoadWarehouses() when loadWarehouses != null:
return loadWarehouses(_that);case _AddWarehouse() when addWarehouse != null:
return addWarehouse(_that);case _UpdateWarehouse() when updateWarehouse != null:
return updateWarehouse(_that);case _DeleteWarehouse() when deleteWarehouse != null:
return deleteWarehouse(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadWarehouses,TResult Function( Warehouse warehouse)?  addWarehouse,TResult Function( Warehouse warehouse)?  updateWarehouse,TResult Function( String id)?  deleteWarehouse,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoadWarehouses() when loadWarehouses != null:
return loadWarehouses();case _AddWarehouse() when addWarehouse != null:
return addWarehouse(_that.warehouse);case _UpdateWarehouse() when updateWarehouse != null:
return updateWarehouse(_that.warehouse);case _DeleteWarehouse() when deleteWarehouse != null:
return deleteWarehouse(_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadWarehouses,required TResult Function( Warehouse warehouse)  addWarehouse,required TResult Function( Warehouse warehouse)  updateWarehouse,required TResult Function( String id)  deleteWarehouse,}) {final _that = this;
switch (_that) {
case _LoadWarehouses():
return loadWarehouses();case _AddWarehouse():
return addWarehouse(_that.warehouse);case _UpdateWarehouse():
return updateWarehouse(_that.warehouse);case _DeleteWarehouse():
return deleteWarehouse(_that.id);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadWarehouses,TResult? Function( Warehouse warehouse)?  addWarehouse,TResult? Function( Warehouse warehouse)?  updateWarehouse,TResult? Function( String id)?  deleteWarehouse,}) {final _that = this;
switch (_that) {
case _LoadWarehouses() when loadWarehouses != null:
return loadWarehouses();case _AddWarehouse() when addWarehouse != null:
return addWarehouse(_that.warehouse);case _UpdateWarehouse() when updateWarehouse != null:
return updateWarehouse(_that.warehouse);case _DeleteWarehouse() when deleteWarehouse != null:
return deleteWarehouse(_that.id);case _:
  return null;

}
}

}

/// @nodoc


class _LoadWarehouses implements WarehouseEvent {
  const _LoadWarehouses();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadWarehouses);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WarehouseEvent.loadWarehouses()';
}


}




/// @nodoc


class _AddWarehouse implements WarehouseEvent {
  const _AddWarehouse(this.warehouse);
  

 final  Warehouse warehouse;

/// Create a copy of WarehouseEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddWarehouseCopyWith<_AddWarehouse> get copyWith => __$AddWarehouseCopyWithImpl<_AddWarehouse>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddWarehouse&&(identical(other.warehouse, warehouse) || other.warehouse == warehouse));
}


@override
int get hashCode => Object.hash(runtimeType,warehouse);

@override
String toString() {
  return 'WarehouseEvent.addWarehouse(warehouse: $warehouse)';
}


}

/// @nodoc
abstract mixin class _$AddWarehouseCopyWith<$Res> implements $WarehouseEventCopyWith<$Res> {
  factory _$AddWarehouseCopyWith(_AddWarehouse value, $Res Function(_AddWarehouse) _then) = __$AddWarehouseCopyWithImpl;
@useResult
$Res call({
 Warehouse warehouse
});




}
/// @nodoc
class __$AddWarehouseCopyWithImpl<$Res>
    implements _$AddWarehouseCopyWith<$Res> {
  __$AddWarehouseCopyWithImpl(this._self, this._then);

  final _AddWarehouse _self;
  final $Res Function(_AddWarehouse) _then;

/// Create a copy of WarehouseEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? warehouse = null,}) {
  return _then(_AddWarehouse(
null == warehouse ? _self.warehouse : warehouse // ignore: cast_nullable_to_non_nullable
as Warehouse,
  ));
}


}

/// @nodoc


class _UpdateWarehouse implements WarehouseEvent {
  const _UpdateWarehouse(this.warehouse);
  

 final  Warehouse warehouse;

/// Create a copy of WarehouseEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateWarehouseCopyWith<_UpdateWarehouse> get copyWith => __$UpdateWarehouseCopyWithImpl<_UpdateWarehouse>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateWarehouse&&(identical(other.warehouse, warehouse) || other.warehouse == warehouse));
}


@override
int get hashCode => Object.hash(runtimeType,warehouse);

@override
String toString() {
  return 'WarehouseEvent.updateWarehouse(warehouse: $warehouse)';
}


}

/// @nodoc
abstract mixin class _$UpdateWarehouseCopyWith<$Res> implements $WarehouseEventCopyWith<$Res> {
  factory _$UpdateWarehouseCopyWith(_UpdateWarehouse value, $Res Function(_UpdateWarehouse) _then) = __$UpdateWarehouseCopyWithImpl;
@useResult
$Res call({
 Warehouse warehouse
});




}
/// @nodoc
class __$UpdateWarehouseCopyWithImpl<$Res>
    implements _$UpdateWarehouseCopyWith<$Res> {
  __$UpdateWarehouseCopyWithImpl(this._self, this._then);

  final _UpdateWarehouse _self;
  final $Res Function(_UpdateWarehouse) _then;

/// Create a copy of WarehouseEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? warehouse = null,}) {
  return _then(_UpdateWarehouse(
null == warehouse ? _self.warehouse : warehouse // ignore: cast_nullable_to_non_nullable
as Warehouse,
  ));
}


}

/// @nodoc


class _DeleteWarehouse implements WarehouseEvent {
  const _DeleteWarehouse(this.id);
  

 final  String id;

/// Create a copy of WarehouseEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeleteWarehouseCopyWith<_DeleteWarehouse> get copyWith => __$DeleteWarehouseCopyWithImpl<_DeleteWarehouse>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteWarehouse&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'WarehouseEvent.deleteWarehouse(id: $id)';
}


}

/// @nodoc
abstract mixin class _$DeleteWarehouseCopyWith<$Res> implements $WarehouseEventCopyWith<$Res> {
  factory _$DeleteWarehouseCopyWith(_DeleteWarehouse value, $Res Function(_DeleteWarehouse) _then) = __$DeleteWarehouseCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class __$DeleteWarehouseCopyWithImpl<$Res>
    implements _$DeleteWarehouseCopyWith<$Res> {
  __$DeleteWarehouseCopyWithImpl(this._self, this._then);

  final _DeleteWarehouse _self;
  final $Res Function(_DeleteWarehouse) _then;

/// Create a copy of WarehouseEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(_DeleteWarehouse(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$WarehouseState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WarehouseState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WarehouseState()';
}


}

/// @nodoc
class $WarehouseStateCopyWith<$Res>  {
$WarehouseStateCopyWith(WarehouseState _, $Res Function(WarehouseState) __);
}


/// Adds pattern-matching-related methods to [WarehouseState].
extension WarehouseStatePatterns on WarehouseState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _ActionSuccess value)?  actionSuccess,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _ActionSuccess() when actionSuccess != null:
return actionSuccess(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _ActionSuccess value)  actionSuccess,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _ActionSuccess():
return actionSuccess(_that);case _Error():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _ActionSuccess value)?  actionSuccess,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _ActionSuccess() when actionSuccess != null:
return actionSuccess(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Warehouse> warehouses)?  loaded,TResult Function( String message)?  actionSuccess,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.warehouses);case _ActionSuccess() when actionSuccess != null:
return actionSuccess(_that.message);case _Error() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Warehouse> warehouses)  loaded,required TResult Function( String message)  actionSuccess,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.warehouses);case _ActionSuccess():
return actionSuccess(_that.message);case _Error():
return error(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Warehouse> warehouses)?  loaded,TResult? Function( String message)?  actionSuccess,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.warehouses);case _ActionSuccess() when actionSuccess != null:
return actionSuccess(_that.message);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements WarehouseState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WarehouseState.initial()';
}


}




/// @nodoc


class _Loading implements WarehouseState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WarehouseState.loading()';
}


}




/// @nodoc


class _Loaded implements WarehouseState {
  const _Loaded(final  List<Warehouse> warehouses): _warehouses = warehouses;
  

 final  List<Warehouse> _warehouses;
 List<Warehouse> get warehouses {
  if (_warehouses is EqualUnmodifiableListView) return _warehouses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_warehouses);
}


/// Create a copy of WarehouseState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&const DeepCollectionEquality().equals(other._warehouses, _warehouses));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_warehouses));

@override
String toString() {
  return 'WarehouseState.loaded(warehouses: $warehouses)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $WarehouseStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 List<Warehouse> warehouses
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of WarehouseState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? warehouses = null,}) {
  return _then(_Loaded(
null == warehouses ? _self._warehouses : warehouses // ignore: cast_nullable_to_non_nullable
as List<Warehouse>,
  ));
}


}

/// @nodoc


class _ActionSuccess implements WarehouseState {
  const _ActionSuccess(this.message);
  

 final  String message;

/// Create a copy of WarehouseState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActionSuccessCopyWith<_ActionSuccess> get copyWith => __$ActionSuccessCopyWithImpl<_ActionSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActionSuccess&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'WarehouseState.actionSuccess(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ActionSuccessCopyWith<$Res> implements $WarehouseStateCopyWith<$Res> {
  factory _$ActionSuccessCopyWith(_ActionSuccess value, $Res Function(_ActionSuccess) _then) = __$ActionSuccessCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ActionSuccessCopyWithImpl<$Res>
    implements _$ActionSuccessCopyWith<$Res> {
  __$ActionSuccessCopyWithImpl(this._self, this._then);

  final _ActionSuccess _self;
  final $Res Function(_ActionSuccess) _then;

/// Create a copy of WarehouseState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_ActionSuccess(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Error implements WarehouseState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of WarehouseState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'WarehouseState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $WarehouseStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of WarehouseState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
