// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checklist_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChecklistModel {

 String get date;// yyyyMMdd
@JsonKey(name: 'completed_by') String get completedBy;@JsonKey(name: 'completed_at') DateTime get completedAt;@JsonKey(name: 'is_passed') bool get isPassed; List<ChecklistItemModel> get items;
/// Create a copy of ChecklistModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChecklistModelCopyWith<ChecklistModel> get copyWith => _$ChecklistModelCopyWithImpl<ChecklistModel>(this as ChecklistModel, _$identity);

  /// Serializes this ChecklistModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChecklistModel&&(identical(other.date, date) || other.date == date)&&(identical(other.completedBy, completedBy) || other.completedBy == completedBy)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.isPassed, isPassed) || other.isPassed == isPassed)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,completedBy,completedAt,isPassed,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'ChecklistModel(date: $date, completedBy: $completedBy, completedAt: $completedAt, isPassed: $isPassed, items: $items)';
}


}

/// @nodoc
abstract mixin class $ChecklistModelCopyWith<$Res>  {
  factory $ChecklistModelCopyWith(ChecklistModel value, $Res Function(ChecklistModel) _then) = _$ChecklistModelCopyWithImpl;
@useResult
$Res call({
 String date,@JsonKey(name: 'completed_by') String completedBy,@JsonKey(name: 'completed_at') DateTime completedAt,@JsonKey(name: 'is_passed') bool isPassed, List<ChecklistItemModel> items
});




}
/// @nodoc
class _$ChecklistModelCopyWithImpl<$Res>
    implements $ChecklistModelCopyWith<$Res> {
  _$ChecklistModelCopyWithImpl(this._self, this._then);

  final ChecklistModel _self;
  final $Res Function(ChecklistModel) _then;

/// Create a copy of ChecklistModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? completedBy = null,Object? completedAt = null,Object? isPassed = null,Object? items = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,completedBy: null == completedBy ? _self.completedBy : completedBy // ignore: cast_nullable_to_non_nullable
as String,completedAt: null == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isPassed: null == isPassed ? _self.isPassed : isPassed // ignore: cast_nullable_to_non_nullable
as bool,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ChecklistItemModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [ChecklistModel].
extension ChecklistModelPatterns on ChecklistModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChecklistModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChecklistModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChecklistModel value)  $default,){
final _that = this;
switch (_that) {
case _ChecklistModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChecklistModel value)?  $default,){
final _that = this;
switch (_that) {
case _ChecklistModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date, @JsonKey(name: 'completed_by')  String completedBy, @JsonKey(name: 'completed_at')  DateTime completedAt, @JsonKey(name: 'is_passed')  bool isPassed,  List<ChecklistItemModel> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChecklistModel() when $default != null:
return $default(_that.date,_that.completedBy,_that.completedAt,_that.isPassed,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date, @JsonKey(name: 'completed_by')  String completedBy, @JsonKey(name: 'completed_at')  DateTime completedAt, @JsonKey(name: 'is_passed')  bool isPassed,  List<ChecklistItemModel> items)  $default,) {final _that = this;
switch (_that) {
case _ChecklistModel():
return $default(_that.date,_that.completedBy,_that.completedAt,_that.isPassed,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date, @JsonKey(name: 'completed_by')  String completedBy, @JsonKey(name: 'completed_at')  DateTime completedAt, @JsonKey(name: 'is_passed')  bool isPassed,  List<ChecklistItemModel> items)?  $default,) {final _that = this;
switch (_that) {
case _ChecklistModel() when $default != null:
return $default(_that.date,_that.completedBy,_that.completedAt,_that.isPassed,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChecklistModel implements ChecklistModel {
  const _ChecklistModel({required this.date, @JsonKey(name: 'completed_by') required this.completedBy, @JsonKey(name: 'completed_at') required this.completedAt, @JsonKey(name: 'is_passed') required this.isPassed, required final  List<ChecklistItemModel> items}): _items = items;
  factory _ChecklistModel.fromJson(Map<String, dynamic> json) => _$ChecklistModelFromJson(json);

@override final  String date;
// yyyyMMdd
@override@JsonKey(name: 'completed_by') final  String completedBy;
@override@JsonKey(name: 'completed_at') final  DateTime completedAt;
@override@JsonKey(name: 'is_passed') final  bool isPassed;
 final  List<ChecklistItemModel> _items;
@override List<ChecklistItemModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of ChecklistModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChecklistModelCopyWith<_ChecklistModel> get copyWith => __$ChecklistModelCopyWithImpl<_ChecklistModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChecklistModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChecklistModel&&(identical(other.date, date) || other.date == date)&&(identical(other.completedBy, completedBy) || other.completedBy == completedBy)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.isPassed, isPassed) || other.isPassed == isPassed)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,completedBy,completedAt,isPassed,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'ChecklistModel(date: $date, completedBy: $completedBy, completedAt: $completedAt, isPassed: $isPassed, items: $items)';
}


}

/// @nodoc
abstract mixin class _$ChecklistModelCopyWith<$Res> implements $ChecklistModelCopyWith<$Res> {
  factory _$ChecklistModelCopyWith(_ChecklistModel value, $Res Function(_ChecklistModel) _then) = __$ChecklistModelCopyWithImpl;
@override @useResult
$Res call({
 String date,@JsonKey(name: 'completed_by') String completedBy,@JsonKey(name: 'completed_at') DateTime completedAt,@JsonKey(name: 'is_passed') bool isPassed, List<ChecklistItemModel> items
});




}
/// @nodoc
class __$ChecklistModelCopyWithImpl<$Res>
    implements _$ChecklistModelCopyWith<$Res> {
  __$ChecklistModelCopyWithImpl(this._self, this._then);

  final _ChecklistModel _self;
  final $Res Function(_ChecklistModel) _then;

/// Create a copy of ChecklistModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? completedBy = null,Object? completedAt = null,Object? isPassed = null,Object? items = null,}) {
  return _then(_ChecklistModel(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,completedBy: null == completedBy ? _self.completedBy : completedBy // ignore: cast_nullable_to_non_nullable
as String,completedAt: null == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isPassed: null == isPassed ? _self.isPassed : isPassed // ignore: cast_nullable_to_non_nullable
as bool,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ChecklistItemModel>,
  ));
}


}


/// @nodoc
mixin _$ChecklistItemModel {

 String get label;@JsonKey(name: 'is_checked') bool get isChecked; String? get note;
/// Create a copy of ChecklistItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChecklistItemModelCopyWith<ChecklistItemModel> get copyWith => _$ChecklistItemModelCopyWithImpl<ChecklistItemModel>(this as ChecklistItemModel, _$identity);

  /// Serializes this ChecklistItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChecklistItemModel&&(identical(other.label, label) || other.label == label)&&(identical(other.isChecked, isChecked) || other.isChecked == isChecked)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,isChecked,note);

@override
String toString() {
  return 'ChecklistItemModel(label: $label, isChecked: $isChecked, note: $note)';
}


}

/// @nodoc
abstract mixin class $ChecklistItemModelCopyWith<$Res>  {
  factory $ChecklistItemModelCopyWith(ChecklistItemModel value, $Res Function(ChecklistItemModel) _then) = _$ChecklistItemModelCopyWithImpl;
@useResult
$Res call({
 String label,@JsonKey(name: 'is_checked') bool isChecked, String? note
});




}
/// @nodoc
class _$ChecklistItemModelCopyWithImpl<$Res>
    implements $ChecklistItemModelCopyWith<$Res> {
  _$ChecklistItemModelCopyWithImpl(this._self, this._then);

  final ChecklistItemModel _self;
  final $Res Function(ChecklistItemModel) _then;

/// Create a copy of ChecklistItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? isChecked = null,Object? note = freezed,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,isChecked: null == isChecked ? _self.isChecked : isChecked // ignore: cast_nullable_to_non_nullable
as bool,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChecklistItemModel].
extension ChecklistItemModelPatterns on ChecklistItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChecklistItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChecklistItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChecklistItemModel value)  $default,){
final _that = this;
switch (_that) {
case _ChecklistItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChecklistItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _ChecklistItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label, @JsonKey(name: 'is_checked')  bool isChecked,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChecklistItemModel() when $default != null:
return $default(_that.label,_that.isChecked,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label, @JsonKey(name: 'is_checked')  bool isChecked,  String? note)  $default,) {final _that = this;
switch (_that) {
case _ChecklistItemModel():
return $default(_that.label,_that.isChecked,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label, @JsonKey(name: 'is_checked')  bool isChecked,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _ChecklistItemModel() when $default != null:
return $default(_that.label,_that.isChecked,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChecklistItemModel implements ChecklistItemModel {
  const _ChecklistItemModel({required this.label, @JsonKey(name: 'is_checked') this.isChecked = false, this.note});
  factory _ChecklistItemModel.fromJson(Map<String, dynamic> json) => _$ChecklistItemModelFromJson(json);

@override final  String label;
@override@JsonKey(name: 'is_checked') final  bool isChecked;
@override final  String? note;

/// Create a copy of ChecklistItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChecklistItemModelCopyWith<_ChecklistItemModel> get copyWith => __$ChecklistItemModelCopyWithImpl<_ChecklistItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChecklistItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChecklistItemModel&&(identical(other.label, label) || other.label == label)&&(identical(other.isChecked, isChecked) || other.isChecked == isChecked)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,isChecked,note);

@override
String toString() {
  return 'ChecklistItemModel(label: $label, isChecked: $isChecked, note: $note)';
}


}

/// @nodoc
abstract mixin class _$ChecklistItemModelCopyWith<$Res> implements $ChecklistItemModelCopyWith<$Res> {
  factory _$ChecklistItemModelCopyWith(_ChecklistItemModel value, $Res Function(_ChecklistItemModel) _then) = __$ChecklistItemModelCopyWithImpl;
@override @useResult
$Res call({
 String label,@JsonKey(name: 'is_checked') bool isChecked, String? note
});




}
/// @nodoc
class __$ChecklistItemModelCopyWithImpl<$Res>
    implements _$ChecklistItemModelCopyWith<$Res> {
  __$ChecklistItemModelCopyWithImpl(this._self, this._then);

  final _ChecklistItemModel _self;
  final $Res Function(_ChecklistItemModel) _then;

/// Create a copy of ChecklistItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? isChecked = null,Object? note = freezed,}) {
  return _then(_ChecklistItemModel(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,isChecked: null == isChecked ? _self.isChecked : isChecked // ignore: cast_nullable_to_non_nullable
as bool,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
