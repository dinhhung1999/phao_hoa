// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductModel {

 String get id; String get name; String get category;@JsonKey(name: 'regulation_class') String get regulationClass; String get unit;@JsonKey(name: 'import_price') double get importPrice;@JsonKey(name: 'export_price') double get exportPrice;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson) DateTime get createdAt;@JsonKey(name: 'updated_at', fromJson: timestampFromJson, toJson: timestampToJson) DateTime get updatedAt;@JsonKey(name: 'updated_by') String? get updatedBy;
/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductModelCopyWith<ProductModel> get copyWith => _$ProductModelCopyWithImpl<ProductModel>(this as ProductModel, _$identity);

  /// Serializes this ProductModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.regulationClass, regulationClass) || other.regulationClass == regulationClass)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.importPrice, importPrice) || other.importPrice == importPrice)&&(identical(other.exportPrice, exportPrice) || other.exportPrice == exportPrice)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,category,regulationClass,unit,importPrice,exportPrice,isActive,createdAt,updatedAt,updatedBy);

@override
String toString() {
  return 'ProductModel(id: $id, name: $name, category: $category, regulationClass: $regulationClass, unit: $unit, importPrice: $importPrice, exportPrice: $exportPrice, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, updatedBy: $updatedBy)';
}


}

/// @nodoc
abstract mixin class $ProductModelCopyWith<$Res>  {
  factory $ProductModelCopyWith(ProductModel value, $Res Function(ProductModel) _then) = _$ProductModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String category,@JsonKey(name: 'regulation_class') String regulationClass, String unit,@JsonKey(name: 'import_price') double importPrice,@JsonKey(name: 'export_price') double exportPrice,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson) DateTime createdAt,@JsonKey(name: 'updated_at', fromJson: timestampFromJson, toJson: timestampToJson) DateTime updatedAt,@JsonKey(name: 'updated_by') String? updatedBy
});




}
/// @nodoc
class _$ProductModelCopyWithImpl<$Res>
    implements $ProductModelCopyWith<$Res> {
  _$ProductModelCopyWithImpl(this._self, this._then);

  final ProductModel _self;
  final $Res Function(ProductModel) _then;

/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? category = null,Object? regulationClass = null,Object? unit = null,Object? importPrice = null,Object? exportPrice = null,Object? isActive = null,Object? createdAt = null,Object? updatedAt = null,Object? updatedBy = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,regulationClass: null == regulationClass ? _self.regulationClass : regulationClass // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,importPrice: null == importPrice ? _self.importPrice : importPrice // ignore: cast_nullable_to_non_nullable
as double,exportPrice: null == exportPrice ? _self.exportPrice : exportPrice // ignore: cast_nullable_to_non_nullable
as double,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedBy: freezed == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductModel].
extension ProductModelPatterns on ProductModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductModel value)  $default,){
final _that = this;
switch (_that) {
case _ProductModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String category, @JsonKey(name: 'regulation_class')  String regulationClass,  String unit, @JsonKey(name: 'import_price')  double importPrice, @JsonKey(name: 'export_price')  double exportPrice, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson)  DateTime createdAt, @JsonKey(name: 'updated_at', fromJson: timestampFromJson, toJson: timestampToJson)  DateTime updatedAt, @JsonKey(name: 'updated_by')  String? updatedBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.regulationClass,_that.unit,_that.importPrice,_that.exportPrice,_that.isActive,_that.createdAt,_that.updatedAt,_that.updatedBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String category, @JsonKey(name: 'regulation_class')  String regulationClass,  String unit, @JsonKey(name: 'import_price')  double importPrice, @JsonKey(name: 'export_price')  double exportPrice, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson)  DateTime createdAt, @JsonKey(name: 'updated_at', fromJson: timestampFromJson, toJson: timestampToJson)  DateTime updatedAt, @JsonKey(name: 'updated_by')  String? updatedBy)  $default,) {final _that = this;
switch (_that) {
case _ProductModel():
return $default(_that.id,_that.name,_that.category,_that.regulationClass,_that.unit,_that.importPrice,_that.exportPrice,_that.isActive,_that.createdAt,_that.updatedAt,_that.updatedBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String category, @JsonKey(name: 'regulation_class')  String regulationClass,  String unit, @JsonKey(name: 'import_price')  double importPrice, @JsonKey(name: 'export_price')  double exportPrice, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson)  DateTime createdAt, @JsonKey(name: 'updated_at', fromJson: timestampFromJson, toJson: timestampToJson)  DateTime updatedAt, @JsonKey(name: 'updated_by')  String? updatedBy)?  $default,) {final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.regulationClass,_that.unit,_that.importPrice,_that.exportPrice,_that.isActive,_that.createdAt,_that.updatedAt,_that.updatedBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductModel implements ProductModel {
  const _ProductModel({this.id = '', required this.name, required this.category, @JsonKey(name: 'regulation_class') required this.regulationClass, required this.unit, @JsonKey(name: 'import_price') required this.importPrice, @JsonKey(name: 'export_price') required this.exportPrice, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson) required this.createdAt, @JsonKey(name: 'updated_at', fromJson: timestampFromJson, toJson: timestampToJson) required this.updatedAt, @JsonKey(name: 'updated_by') this.updatedBy});
  factory _ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);

@override@JsonKey() final  String id;
@override final  String name;
@override final  String category;
@override@JsonKey(name: 'regulation_class') final  String regulationClass;
@override final  String unit;
@override@JsonKey(name: 'import_price') final  double importPrice;
@override@JsonKey(name: 'export_price') final  double exportPrice;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson) final  DateTime createdAt;
@override@JsonKey(name: 'updated_at', fromJson: timestampFromJson, toJson: timestampToJson) final  DateTime updatedAt;
@override@JsonKey(name: 'updated_by') final  String? updatedBy;

/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductModelCopyWith<_ProductModel> get copyWith => __$ProductModelCopyWithImpl<_ProductModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.regulationClass, regulationClass) || other.regulationClass == regulationClass)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.importPrice, importPrice) || other.importPrice == importPrice)&&(identical(other.exportPrice, exportPrice) || other.exportPrice == exportPrice)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,category,regulationClass,unit,importPrice,exportPrice,isActive,createdAt,updatedAt,updatedBy);

@override
String toString() {
  return 'ProductModel(id: $id, name: $name, category: $category, regulationClass: $regulationClass, unit: $unit, importPrice: $importPrice, exportPrice: $exportPrice, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, updatedBy: $updatedBy)';
}


}

/// @nodoc
abstract mixin class _$ProductModelCopyWith<$Res> implements $ProductModelCopyWith<$Res> {
  factory _$ProductModelCopyWith(_ProductModel value, $Res Function(_ProductModel) _then) = __$ProductModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String category,@JsonKey(name: 'regulation_class') String regulationClass, String unit,@JsonKey(name: 'import_price') double importPrice,@JsonKey(name: 'export_price') double exportPrice,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'created_at', fromJson: timestampFromJson, toJson: timestampToJson) DateTime createdAt,@JsonKey(name: 'updated_at', fromJson: timestampFromJson, toJson: timestampToJson) DateTime updatedAt,@JsonKey(name: 'updated_by') String? updatedBy
});




}
/// @nodoc
class __$ProductModelCopyWithImpl<$Res>
    implements _$ProductModelCopyWith<$Res> {
  __$ProductModelCopyWithImpl(this._self, this._then);

  final _ProductModel _self;
  final $Res Function(_ProductModel) _then;

/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? category = null,Object? regulationClass = null,Object? unit = null,Object? importPrice = null,Object? exportPrice = null,Object? isActive = null,Object? createdAt = null,Object? updatedAt = null,Object? updatedBy = freezed,}) {
  return _then(_ProductModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,regulationClass: null == regulationClass ? _self.regulationClass : regulationClass // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,importPrice: null == importPrice ? _self.importPrice : importPrice // ignore: cast_nullable_to_non_nullable
as double,exportPrice: null == exportPrice ? _self.exportPrice : exportPrice // ignore: cast_nullable_to_non_nullable
as double,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedBy: freezed == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
