// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_formula_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FormulaComponentModel {

@JsonKey(name: 'product_id') String get productId;@JsonKey(name: 'product_name') String get productName; int get quantity;
/// Create a copy of FormulaComponentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormulaComponentModelCopyWith<FormulaComponentModel> get copyWith => _$FormulaComponentModelCopyWithImpl<FormulaComponentModel>(this as FormulaComponentModel, _$identity);

  /// Serializes this FormulaComponentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormulaComponentModel&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,productName,quantity);

@override
String toString() {
  return 'FormulaComponentModel(productId: $productId, productName: $productName, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $FormulaComponentModelCopyWith<$Res>  {
  factory $FormulaComponentModelCopyWith(FormulaComponentModel value, $Res Function(FormulaComponentModel) _then) = _$FormulaComponentModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'product_name') String productName, int quantity
});




}
/// @nodoc
class _$FormulaComponentModelCopyWithImpl<$Res>
    implements $FormulaComponentModelCopyWith<$Res> {
  _$FormulaComponentModelCopyWithImpl(this._self, this._then);

  final FormulaComponentModel _self;
  final $Res Function(FormulaComponentModel) _then;

/// Create a copy of FormulaComponentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? productName = null,Object? quantity = null,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FormulaComponentModel].
extension FormulaComponentModelPatterns on FormulaComponentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FormulaComponentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FormulaComponentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FormulaComponentModel value)  $default,){
final _that = this;
switch (_that) {
case _FormulaComponentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FormulaComponentModel value)?  $default,){
final _that = this;
switch (_that) {
case _FormulaComponentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'product_name')  String productName,  int quantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FormulaComponentModel() when $default != null:
return $default(_that.productId,_that.productName,_that.quantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'product_name')  String productName,  int quantity)  $default,) {final _that = this;
switch (_that) {
case _FormulaComponentModel():
return $default(_that.productId,_that.productName,_that.quantity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'product_name')  String productName,  int quantity)?  $default,) {final _that = this;
switch (_that) {
case _FormulaComponentModel() when $default != null:
return $default(_that.productId,_that.productName,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FormulaComponentModel implements FormulaComponentModel {
  const _FormulaComponentModel({@JsonKey(name: 'product_id') required this.productId, @JsonKey(name: 'product_name') required this.productName, required this.quantity});
  factory _FormulaComponentModel.fromJson(Map<String, dynamic> json) => _$FormulaComponentModelFromJson(json);

@override@JsonKey(name: 'product_id') final  String productId;
@override@JsonKey(name: 'product_name') final  String productName;
@override final  int quantity;

/// Create a copy of FormulaComponentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FormulaComponentModelCopyWith<_FormulaComponentModel> get copyWith => __$FormulaComponentModelCopyWithImpl<_FormulaComponentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FormulaComponentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FormulaComponentModel&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,productName,quantity);

@override
String toString() {
  return 'FormulaComponentModel(productId: $productId, productName: $productName, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$FormulaComponentModelCopyWith<$Res> implements $FormulaComponentModelCopyWith<$Res> {
  factory _$FormulaComponentModelCopyWith(_FormulaComponentModel value, $Res Function(_FormulaComponentModel) _then) = __$FormulaComponentModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'product_name') String productName, int quantity
});




}
/// @nodoc
class __$FormulaComponentModelCopyWithImpl<$Res>
    implements _$FormulaComponentModelCopyWith<$Res> {
  __$FormulaComponentModelCopyWithImpl(this._self, this._then);

  final _FormulaComponentModel _self;
  final $Res Function(_FormulaComponentModel) _then;

/// Create a copy of FormulaComponentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? productName = null,Object? quantity = null,}) {
  return _then(_FormulaComponentModel(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ProductFormulaModel {

 String get id;@JsonKey(name: 'product_id') String get productId;@JsonKey(name: 'product_name') String get productName; List<FormulaComponentModel> get components;@JsonKey(name: 'labor_cost') double get laborCost; String? get notes;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'updated_at', fromJson: timestampFromJson, toJson: timestampToJson) DateTime get updatedAt;@JsonKey(name: 'updated_by') String? get updatedBy;
/// Create a copy of ProductFormulaModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductFormulaModelCopyWith<ProductFormulaModel> get copyWith => _$ProductFormulaModelCopyWithImpl<ProductFormulaModel>(this as ProductFormulaModel, _$identity);

  /// Serializes this ProductFormulaModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductFormulaModel&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&const DeepCollectionEquality().equals(other.components, components)&&(identical(other.laborCost, laborCost) || other.laborCost == laborCost)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,productName,const DeepCollectionEquality().hash(components),laborCost,notes,isActive,updatedAt,updatedBy);

@override
String toString() {
  return 'ProductFormulaModel(id: $id, productId: $productId, productName: $productName, components: $components, laborCost: $laborCost, notes: $notes, isActive: $isActive, updatedAt: $updatedAt, updatedBy: $updatedBy)';
}


}

/// @nodoc
abstract mixin class $ProductFormulaModelCopyWith<$Res>  {
  factory $ProductFormulaModelCopyWith(ProductFormulaModel value, $Res Function(ProductFormulaModel) _then) = _$ProductFormulaModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'product_name') String productName, List<FormulaComponentModel> components,@JsonKey(name: 'labor_cost') double laborCost, String? notes,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'updated_at', fromJson: timestampFromJson, toJson: timestampToJson) DateTime updatedAt,@JsonKey(name: 'updated_by') String? updatedBy
});




}
/// @nodoc
class _$ProductFormulaModelCopyWithImpl<$Res>
    implements $ProductFormulaModelCopyWith<$Res> {
  _$ProductFormulaModelCopyWithImpl(this._self, this._then);

  final ProductFormulaModel _self;
  final $Res Function(ProductFormulaModel) _then;

/// Create a copy of ProductFormulaModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productId = null,Object? productName = null,Object? components = null,Object? laborCost = null,Object? notes = freezed,Object? isActive = null,Object? updatedAt = null,Object? updatedBy = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,components: null == components ? _self.components : components // ignore: cast_nullable_to_non_nullable
as List<FormulaComponentModel>,laborCost: null == laborCost ? _self.laborCost : laborCost // ignore: cast_nullable_to_non_nullable
as double,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedBy: freezed == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductFormulaModel].
extension ProductFormulaModelPatterns on ProductFormulaModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductFormulaModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductFormulaModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductFormulaModel value)  $default,){
final _that = this;
switch (_that) {
case _ProductFormulaModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductFormulaModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProductFormulaModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'product_name')  String productName,  List<FormulaComponentModel> components, @JsonKey(name: 'labor_cost')  double laborCost,  String? notes, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'updated_at', fromJson: timestampFromJson, toJson: timestampToJson)  DateTime updatedAt, @JsonKey(name: 'updated_by')  String? updatedBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductFormulaModel() when $default != null:
return $default(_that.id,_that.productId,_that.productName,_that.components,_that.laborCost,_that.notes,_that.isActive,_that.updatedAt,_that.updatedBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'product_name')  String productName,  List<FormulaComponentModel> components, @JsonKey(name: 'labor_cost')  double laborCost,  String? notes, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'updated_at', fromJson: timestampFromJson, toJson: timestampToJson)  DateTime updatedAt, @JsonKey(name: 'updated_by')  String? updatedBy)  $default,) {final _that = this;
switch (_that) {
case _ProductFormulaModel():
return $default(_that.id,_that.productId,_that.productName,_that.components,_that.laborCost,_that.notes,_that.isActive,_that.updatedAt,_that.updatedBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'product_name')  String productName,  List<FormulaComponentModel> components, @JsonKey(name: 'labor_cost')  double laborCost,  String? notes, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'updated_at', fromJson: timestampFromJson, toJson: timestampToJson)  DateTime updatedAt, @JsonKey(name: 'updated_by')  String? updatedBy)?  $default,) {final _that = this;
switch (_that) {
case _ProductFormulaModel() when $default != null:
return $default(_that.id,_that.productId,_that.productName,_that.components,_that.laborCost,_that.notes,_that.isActive,_that.updatedAt,_that.updatedBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductFormulaModel implements ProductFormulaModel {
  const _ProductFormulaModel({this.id = '', @JsonKey(name: 'product_id') required this.productId, @JsonKey(name: 'product_name') required this.productName, required final  List<FormulaComponentModel> components, @JsonKey(name: 'labor_cost') this.laborCost = 0, this.notes, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'updated_at', fromJson: timestampFromJson, toJson: timestampToJson) required this.updatedAt, @JsonKey(name: 'updated_by') this.updatedBy}): _components = components;
  factory _ProductFormulaModel.fromJson(Map<String, dynamic> json) => _$ProductFormulaModelFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey(name: 'product_id') final  String productId;
@override@JsonKey(name: 'product_name') final  String productName;
 final  List<FormulaComponentModel> _components;
@override List<FormulaComponentModel> get components {
  if (_components is EqualUnmodifiableListView) return _components;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_components);
}

@override@JsonKey(name: 'labor_cost') final  double laborCost;
@override final  String? notes;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'updated_at', fromJson: timestampFromJson, toJson: timestampToJson) final  DateTime updatedAt;
@override@JsonKey(name: 'updated_by') final  String? updatedBy;

/// Create a copy of ProductFormulaModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductFormulaModelCopyWith<_ProductFormulaModel> get copyWith => __$ProductFormulaModelCopyWithImpl<_ProductFormulaModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductFormulaModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductFormulaModel&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&const DeepCollectionEquality().equals(other._components, _components)&&(identical(other.laborCost, laborCost) || other.laborCost == laborCost)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,productName,const DeepCollectionEquality().hash(_components),laborCost,notes,isActive,updatedAt,updatedBy);

@override
String toString() {
  return 'ProductFormulaModel(id: $id, productId: $productId, productName: $productName, components: $components, laborCost: $laborCost, notes: $notes, isActive: $isActive, updatedAt: $updatedAt, updatedBy: $updatedBy)';
}


}

/// @nodoc
abstract mixin class _$ProductFormulaModelCopyWith<$Res> implements $ProductFormulaModelCopyWith<$Res> {
  factory _$ProductFormulaModelCopyWith(_ProductFormulaModel value, $Res Function(_ProductFormulaModel) _then) = __$ProductFormulaModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'product_name') String productName, List<FormulaComponentModel> components,@JsonKey(name: 'labor_cost') double laborCost, String? notes,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'updated_at', fromJson: timestampFromJson, toJson: timestampToJson) DateTime updatedAt,@JsonKey(name: 'updated_by') String? updatedBy
});




}
/// @nodoc
class __$ProductFormulaModelCopyWithImpl<$Res>
    implements _$ProductFormulaModelCopyWith<$Res> {
  __$ProductFormulaModelCopyWithImpl(this._self, this._then);

  final _ProductFormulaModel _self;
  final $Res Function(_ProductFormulaModel) _then;

/// Create a copy of ProductFormulaModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productId = null,Object? productName = null,Object? components = null,Object? laborCost = null,Object? notes = freezed,Object? isActive = null,Object? updatedAt = null,Object? updatedBy = freezed,}) {
  return _then(_ProductFormulaModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,components: null == components ? _self._components : components // ignore: cast_nullable_to_non_nullable
as List<FormulaComponentModel>,laborCost: null == laborCost ? _self.laborCost : laborCost // ignore: cast_nullable_to_non_nullable
as double,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedBy: freezed == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
