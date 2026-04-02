// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checklist_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChecklistEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChecklistEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChecklistEvent()';
}


}

/// @nodoc
class $ChecklistEventCopyWith<$Res>  {
$ChecklistEventCopyWith(ChecklistEvent _, $Res Function(ChecklistEvent) __);
}


/// Adds pattern-matching-related methods to [ChecklistEvent].
extension ChecklistEventPatterns on ChecklistEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _CheckTodayStatus value)?  checkTodayStatus,TResult Function( _SubmitChecklist value)?  submitChecklist,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckTodayStatus() when checkTodayStatus != null:
return checkTodayStatus(_that);case _SubmitChecklist() when submitChecklist != null:
return submitChecklist(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _CheckTodayStatus value)  checkTodayStatus,required TResult Function( _SubmitChecklist value)  submitChecklist,}){
final _that = this;
switch (_that) {
case _CheckTodayStatus():
return checkTodayStatus(_that);case _SubmitChecklist():
return submitChecklist(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _CheckTodayStatus value)?  checkTodayStatus,TResult? Function( _SubmitChecklist value)?  submitChecklist,}){
final _that = this;
switch (_that) {
case _CheckTodayStatus() when checkTodayStatus != null:
return checkTodayStatus(_that);case _SubmitChecklist() when submitChecklist != null:
return submitChecklist(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  checkTodayStatus,TResult Function( String userId,  List<ChecklistItem> items)?  submitChecklist,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckTodayStatus() when checkTodayStatus != null:
return checkTodayStatus();case _SubmitChecklist() when submitChecklist != null:
return submitChecklist(_that.userId,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  checkTodayStatus,required TResult Function( String userId,  List<ChecklistItem> items)  submitChecklist,}) {final _that = this;
switch (_that) {
case _CheckTodayStatus():
return checkTodayStatus();case _SubmitChecklist():
return submitChecklist(_that.userId,_that.items);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  checkTodayStatus,TResult? Function( String userId,  List<ChecklistItem> items)?  submitChecklist,}) {final _that = this;
switch (_that) {
case _CheckTodayStatus() when checkTodayStatus != null:
return checkTodayStatus();case _SubmitChecklist() when submitChecklist != null:
return submitChecklist(_that.userId,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _CheckTodayStatus implements ChecklistEvent {
  const _CheckTodayStatus();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckTodayStatus);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChecklistEvent.checkTodayStatus()';
}


}




/// @nodoc


class _SubmitChecklist implements ChecklistEvent {
  const _SubmitChecklist({required this.userId, required final  List<ChecklistItem> items}): _items = items;
  

 final  String userId;
 final  List<ChecklistItem> _items;
 List<ChecklistItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of ChecklistEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubmitChecklistCopyWith<_SubmitChecklist> get copyWith => __$SubmitChecklistCopyWithImpl<_SubmitChecklist>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubmitChecklist&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,userId,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'ChecklistEvent.submitChecklist(userId: $userId, items: $items)';
}


}

/// @nodoc
abstract mixin class _$SubmitChecklistCopyWith<$Res> implements $ChecklistEventCopyWith<$Res> {
  factory _$SubmitChecklistCopyWith(_SubmitChecklist value, $Res Function(_SubmitChecklist) _then) = __$SubmitChecklistCopyWithImpl;
@useResult
$Res call({
 String userId, List<ChecklistItem> items
});




}
/// @nodoc
class __$SubmitChecklistCopyWithImpl<$Res>
    implements _$SubmitChecklistCopyWith<$Res> {
  __$SubmitChecklistCopyWithImpl(this._self, this._then);

  final _SubmitChecklist _self;
  final $Res Function(_SubmitChecklist) _then;

/// Create a copy of ChecklistEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? items = null,}) {
  return _then(_SubmitChecklist(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ChecklistItem>,
  ));
}


}

/// @nodoc
mixin _$ChecklistState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChecklistState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChecklistState()';
}


}

/// @nodoc
class $ChecklistStateCopyWith<$Res>  {
$ChecklistStateCopyWith(ChecklistState _, $Res Function(ChecklistState) __);
}


/// Adds pattern-matching-related methods to [ChecklistState].
extension ChecklistStatePatterns on ChecklistState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _NotCompleted value)?  notCompleted,TResult Function( _Completed value)?  completed,TResult Function( _Submitted value)?  submitted,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _NotCompleted() when notCompleted != null:
return notCompleted(_that);case _Completed() when completed != null:
return completed(_that);case _Submitted() when submitted != null:
return submitted(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _NotCompleted value)  notCompleted,required TResult Function( _Completed value)  completed,required TResult Function( _Submitted value)  submitted,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _NotCompleted():
return notCompleted(_that);case _Completed():
return completed(_that);case _Submitted():
return submitted(_that);case _Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _NotCompleted value)?  notCompleted,TResult? Function( _Completed value)?  completed,TResult? Function( _Submitted value)?  submitted,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _NotCompleted() when notCompleted != null:
return notCompleted(_that);case _Completed() when completed != null:
return completed(_that);case _Submitted() when submitted != null:
return submitted(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function()?  notCompleted,TResult Function()?  completed,TResult Function()?  submitted,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _NotCompleted() when notCompleted != null:
return notCompleted();case _Completed() when completed != null:
return completed();case _Submitted() when submitted != null:
return submitted();case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function()  notCompleted,required TResult Function()  completed,required TResult Function()  submitted,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _NotCompleted():
return notCompleted();case _Completed():
return completed();case _Submitted():
return submitted();case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function()?  notCompleted,TResult? Function()?  completed,TResult? Function()?  submitted,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _NotCompleted() when notCompleted != null:
return notCompleted();case _Completed() when completed != null:
return completed();case _Submitted() when submitted != null:
return submitted();case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements ChecklistState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChecklistState.initial()';
}


}




/// @nodoc


class _Loading implements ChecklistState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChecklistState.loading()';
}


}




/// @nodoc


class _NotCompleted implements ChecklistState {
  const _NotCompleted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotCompleted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChecklistState.notCompleted()';
}


}




/// @nodoc


class _Completed implements ChecklistState {
  const _Completed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Completed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChecklistState.completed()';
}


}




/// @nodoc


class _Submitted implements ChecklistState {
  const _Submitted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Submitted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChecklistState.submitted()';
}


}




/// @nodoc


class _Error implements ChecklistState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of ChecklistState
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
  return 'ChecklistState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $ChecklistStateCopyWith<$Res> {
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

/// Create a copy of ChecklistState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
