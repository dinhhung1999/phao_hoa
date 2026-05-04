// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'formula_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FormulaEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormulaEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FormulaEvent()';
}


}

/// @nodoc
class $FormulaEventCopyWith<$Res>  {
$FormulaEventCopyWith(FormulaEvent _, $Res Function(FormulaEvent) __);
}


/// Adds pattern-matching-related methods to [FormulaEvent].
extension FormulaEventPatterns on FormulaEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _LoadFormulas value)?  loadFormulas,TResult Function( _SaveFormula value)?  saveFormula,TResult Function( _DeleteFormula value)?  deleteFormula,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoadFormulas() when loadFormulas != null:
return loadFormulas(_that);case _SaveFormula() when saveFormula != null:
return saveFormula(_that);case _DeleteFormula() when deleteFormula != null:
return deleteFormula(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _LoadFormulas value)  loadFormulas,required TResult Function( _SaveFormula value)  saveFormula,required TResult Function( _DeleteFormula value)  deleteFormula,}){
final _that = this;
switch (_that) {
case _LoadFormulas():
return loadFormulas(_that);case _SaveFormula():
return saveFormula(_that);case _DeleteFormula():
return deleteFormula(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _LoadFormulas value)?  loadFormulas,TResult? Function( _SaveFormula value)?  saveFormula,TResult? Function( _DeleteFormula value)?  deleteFormula,}){
final _that = this;
switch (_that) {
case _LoadFormulas() when loadFormulas != null:
return loadFormulas(_that);case _SaveFormula() when saveFormula != null:
return saveFormula(_that);case _DeleteFormula() when deleteFormula != null:
return deleteFormula(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadFormulas,TResult Function( ProductFormula formula)?  saveFormula,TResult Function( String formulaId)?  deleteFormula,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoadFormulas() when loadFormulas != null:
return loadFormulas();case _SaveFormula() when saveFormula != null:
return saveFormula(_that.formula);case _DeleteFormula() when deleteFormula != null:
return deleteFormula(_that.formulaId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadFormulas,required TResult Function( ProductFormula formula)  saveFormula,required TResult Function( String formulaId)  deleteFormula,}) {final _that = this;
switch (_that) {
case _LoadFormulas():
return loadFormulas();case _SaveFormula():
return saveFormula(_that.formula);case _DeleteFormula():
return deleteFormula(_that.formulaId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadFormulas,TResult? Function( ProductFormula formula)?  saveFormula,TResult? Function( String formulaId)?  deleteFormula,}) {final _that = this;
switch (_that) {
case _LoadFormulas() when loadFormulas != null:
return loadFormulas();case _SaveFormula() when saveFormula != null:
return saveFormula(_that.formula);case _DeleteFormula() when deleteFormula != null:
return deleteFormula(_that.formulaId);case _:
  return null;

}
}

}

/// @nodoc


class _LoadFormulas implements FormulaEvent {
  const _LoadFormulas();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadFormulas);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FormulaEvent.loadFormulas()';
}


}




/// @nodoc


class _SaveFormula implements FormulaEvent {
  const _SaveFormula(this.formula);
  

 final  ProductFormula formula;

/// Create a copy of FormulaEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaveFormulaCopyWith<_SaveFormula> get copyWith => __$SaveFormulaCopyWithImpl<_SaveFormula>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaveFormula&&(identical(other.formula, formula) || other.formula == formula));
}


@override
int get hashCode => Object.hash(runtimeType,formula);

@override
String toString() {
  return 'FormulaEvent.saveFormula(formula: $formula)';
}


}

/// @nodoc
abstract mixin class _$SaveFormulaCopyWith<$Res> implements $FormulaEventCopyWith<$Res> {
  factory _$SaveFormulaCopyWith(_SaveFormula value, $Res Function(_SaveFormula) _then) = __$SaveFormulaCopyWithImpl;
@useResult
$Res call({
 ProductFormula formula
});




}
/// @nodoc
class __$SaveFormulaCopyWithImpl<$Res>
    implements _$SaveFormulaCopyWith<$Res> {
  __$SaveFormulaCopyWithImpl(this._self, this._then);

  final _SaveFormula _self;
  final $Res Function(_SaveFormula) _then;

/// Create a copy of FormulaEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? formula = null,}) {
  return _then(_SaveFormula(
null == formula ? _self.formula : formula // ignore: cast_nullable_to_non_nullable
as ProductFormula,
  ));
}


}

/// @nodoc


class _DeleteFormula implements FormulaEvent {
  const _DeleteFormula(this.formulaId);
  

 final  String formulaId;

/// Create a copy of FormulaEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeleteFormulaCopyWith<_DeleteFormula> get copyWith => __$DeleteFormulaCopyWithImpl<_DeleteFormula>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteFormula&&(identical(other.formulaId, formulaId) || other.formulaId == formulaId));
}


@override
int get hashCode => Object.hash(runtimeType,formulaId);

@override
String toString() {
  return 'FormulaEvent.deleteFormula(formulaId: $formulaId)';
}


}

/// @nodoc
abstract mixin class _$DeleteFormulaCopyWith<$Res> implements $FormulaEventCopyWith<$Res> {
  factory _$DeleteFormulaCopyWith(_DeleteFormula value, $Res Function(_DeleteFormula) _then) = __$DeleteFormulaCopyWithImpl;
@useResult
$Res call({
 String formulaId
});




}
/// @nodoc
class __$DeleteFormulaCopyWithImpl<$Res>
    implements _$DeleteFormulaCopyWith<$Res> {
  __$DeleteFormulaCopyWithImpl(this._self, this._then);

  final _DeleteFormula _self;
  final $Res Function(_DeleteFormula) _then;

/// Create a copy of FormulaEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? formulaId = null,}) {
  return _then(_DeleteFormula(
null == formulaId ? _self.formulaId : formulaId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$FormulaState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormulaState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FormulaState()';
}


}

/// @nodoc
class $FormulaStateCopyWith<$Res>  {
$FormulaStateCopyWith(FormulaState _, $Res Function(FormulaState) __);
}


/// Adds pattern-matching-related methods to [FormulaState].
extension FormulaStatePatterns on FormulaState {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<ProductFormula> formulas)?  loaded,TResult Function( String message)?  actionSuccess,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.formulas);case _ActionSuccess() when actionSuccess != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<ProductFormula> formulas)  loaded,required TResult Function( String message)  actionSuccess,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.formulas);case _ActionSuccess():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<ProductFormula> formulas)?  loaded,TResult? Function( String message)?  actionSuccess,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.formulas);case _ActionSuccess() when actionSuccess != null:
return actionSuccess(_that.message);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements FormulaState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FormulaState.initial()';
}


}




/// @nodoc


class _Loading implements FormulaState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FormulaState.loading()';
}


}




/// @nodoc


class _Loaded implements FormulaState {
  const _Loaded(final  List<ProductFormula> formulas): _formulas = formulas;
  

 final  List<ProductFormula> _formulas;
 List<ProductFormula> get formulas {
  if (_formulas is EqualUnmodifiableListView) return _formulas;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_formulas);
}


/// Create a copy of FormulaState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&const DeepCollectionEquality().equals(other._formulas, _formulas));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_formulas));

@override
String toString() {
  return 'FormulaState.loaded(formulas: $formulas)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $FormulaStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 List<ProductFormula> formulas
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of FormulaState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? formulas = null,}) {
  return _then(_Loaded(
null == formulas ? _self._formulas : formulas // ignore: cast_nullable_to_non_nullable
as List<ProductFormula>,
  ));
}


}

/// @nodoc


class _ActionSuccess implements FormulaState {
  const _ActionSuccess(this.message);
  

 final  String message;

/// Create a copy of FormulaState
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
  return 'FormulaState.actionSuccess(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ActionSuccessCopyWith<$Res> implements $FormulaStateCopyWith<$Res> {
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

/// Create a copy of FormulaState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_ActionSuccess(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Error implements FormulaState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of FormulaState
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
  return 'FormulaState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $FormulaStateCopyWith<$Res> {
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

/// Create a copy of FormulaState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
