// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TransactionEvent()';
}


}

/// @nodoc
class $TransactionEventCopyWith<$Res>  {
$TransactionEventCopyWith(TransactionEvent _, $Res Function(TransactionEvent) __);
}


/// Adds pattern-matching-related methods to [TransactionEvent].
extension TransactionEventPatterns on TransactionEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _LoadHistory value)?  loadHistory,TResult Function( _CreateExport value)?  createExport,TResult Function( _CreateImport value)?  createImport,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoadHistory() when loadHistory != null:
return loadHistory(_that);case _CreateExport() when createExport != null:
return createExport(_that);case _CreateImport() when createImport != null:
return createImport(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _LoadHistory value)  loadHistory,required TResult Function( _CreateExport value)  createExport,required TResult Function( _CreateImport value)  createImport,}){
final _that = this;
switch (_that) {
case _LoadHistory():
return loadHistory(_that);case _CreateExport():
return createExport(_that);case _CreateImport():
return createImport(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _LoadHistory value)?  loadHistory,TResult? Function( _CreateExport value)?  createExport,TResult? Function( _CreateImport value)?  createImport,}){
final _that = this;
switch (_that) {
case _LoadHistory() when loadHistory != null:
return loadHistory(_that);case _CreateExport() when createExport != null:
return createExport(_that);case _CreateImport() when createImport != null:
return createImport(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( DateTime? startDate,  DateTime? endDate,  String? type,  String? warehouseLocation)?  loadHistory,TResult Function( entity.Transaction transaction,  List<TransactionItem> items)?  createExport,TResult Function( entity.Transaction transaction,  List<TransactionItem> items)?  createImport,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoadHistory() when loadHistory != null:
return loadHistory(_that.startDate,_that.endDate,_that.type,_that.warehouseLocation);case _CreateExport() when createExport != null:
return createExport(_that.transaction,_that.items);case _CreateImport() when createImport != null:
return createImport(_that.transaction,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( DateTime? startDate,  DateTime? endDate,  String? type,  String? warehouseLocation)  loadHistory,required TResult Function( entity.Transaction transaction,  List<TransactionItem> items)  createExport,required TResult Function( entity.Transaction transaction,  List<TransactionItem> items)  createImport,}) {final _that = this;
switch (_that) {
case _LoadHistory():
return loadHistory(_that.startDate,_that.endDate,_that.type,_that.warehouseLocation);case _CreateExport():
return createExport(_that.transaction,_that.items);case _CreateImport():
return createImport(_that.transaction,_that.items);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( DateTime? startDate,  DateTime? endDate,  String? type,  String? warehouseLocation)?  loadHistory,TResult? Function( entity.Transaction transaction,  List<TransactionItem> items)?  createExport,TResult? Function( entity.Transaction transaction,  List<TransactionItem> items)?  createImport,}) {final _that = this;
switch (_that) {
case _LoadHistory() when loadHistory != null:
return loadHistory(_that.startDate,_that.endDate,_that.type,_that.warehouseLocation);case _CreateExport() when createExport != null:
return createExport(_that.transaction,_that.items);case _CreateImport() when createImport != null:
return createImport(_that.transaction,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _LoadHistory implements TransactionEvent {
  const _LoadHistory({this.startDate, this.endDate, this.type, this.warehouseLocation});
  

 final  DateTime? startDate;
 final  DateTime? endDate;
 final  String? type;
 final  String? warehouseLocation;

/// Create a copy of TransactionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadHistoryCopyWith<_LoadHistory> get copyWith => __$LoadHistoryCopyWithImpl<_LoadHistory>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadHistory&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.type, type) || other.type == type)&&(identical(other.warehouseLocation, warehouseLocation) || other.warehouseLocation == warehouseLocation));
}


@override
int get hashCode => Object.hash(runtimeType,startDate,endDate,type,warehouseLocation);

@override
String toString() {
  return 'TransactionEvent.loadHistory(startDate: $startDate, endDate: $endDate, type: $type, warehouseLocation: $warehouseLocation)';
}


}

/// @nodoc
abstract mixin class _$LoadHistoryCopyWith<$Res> implements $TransactionEventCopyWith<$Res> {
  factory _$LoadHistoryCopyWith(_LoadHistory value, $Res Function(_LoadHistory) _then) = __$LoadHistoryCopyWithImpl;
@useResult
$Res call({
 DateTime? startDate, DateTime? endDate, String? type, String? warehouseLocation
});




}
/// @nodoc
class __$LoadHistoryCopyWithImpl<$Res>
    implements _$LoadHistoryCopyWith<$Res> {
  __$LoadHistoryCopyWithImpl(this._self, this._then);

  final _LoadHistory _self;
  final $Res Function(_LoadHistory) _then;

/// Create a copy of TransactionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? startDate = freezed,Object? endDate = freezed,Object? type = freezed,Object? warehouseLocation = freezed,}) {
  return _then(_LoadHistory(
startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,warehouseLocation: freezed == warehouseLocation ? _self.warehouseLocation : warehouseLocation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _CreateExport implements TransactionEvent {
  const _CreateExport({required this.transaction, required final  List<TransactionItem> items}): _items = items;
  

 final  entity.Transaction transaction;
 final  List<TransactionItem> _items;
 List<TransactionItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of TransactionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateExportCopyWith<_CreateExport> get copyWith => __$CreateExportCopyWithImpl<_CreateExport>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateExport&&(identical(other.transaction, transaction) || other.transaction == transaction)&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,transaction,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'TransactionEvent.createExport(transaction: $transaction, items: $items)';
}


}

/// @nodoc
abstract mixin class _$CreateExportCopyWith<$Res> implements $TransactionEventCopyWith<$Res> {
  factory _$CreateExportCopyWith(_CreateExport value, $Res Function(_CreateExport) _then) = __$CreateExportCopyWithImpl;
@useResult
$Res call({
 entity.Transaction transaction, List<TransactionItem> items
});




}
/// @nodoc
class __$CreateExportCopyWithImpl<$Res>
    implements _$CreateExportCopyWith<$Res> {
  __$CreateExportCopyWithImpl(this._self, this._then);

  final _CreateExport _self;
  final $Res Function(_CreateExport) _then;

/// Create a copy of TransactionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? transaction = null,Object? items = null,}) {
  return _then(_CreateExport(
transaction: null == transaction ? _self.transaction : transaction // ignore: cast_nullable_to_non_nullable
as entity.Transaction,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<TransactionItem>,
  ));
}


}

/// @nodoc


class _CreateImport implements TransactionEvent {
  const _CreateImport({required this.transaction, required final  List<TransactionItem> items}): _items = items;
  

 final  entity.Transaction transaction;
 final  List<TransactionItem> _items;
 List<TransactionItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of TransactionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateImportCopyWith<_CreateImport> get copyWith => __$CreateImportCopyWithImpl<_CreateImport>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateImport&&(identical(other.transaction, transaction) || other.transaction == transaction)&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,transaction,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'TransactionEvent.createImport(transaction: $transaction, items: $items)';
}


}

/// @nodoc
abstract mixin class _$CreateImportCopyWith<$Res> implements $TransactionEventCopyWith<$Res> {
  factory _$CreateImportCopyWith(_CreateImport value, $Res Function(_CreateImport) _then) = __$CreateImportCopyWithImpl;
@useResult
$Res call({
 entity.Transaction transaction, List<TransactionItem> items
});




}
/// @nodoc
class __$CreateImportCopyWithImpl<$Res>
    implements _$CreateImportCopyWith<$Res> {
  __$CreateImportCopyWithImpl(this._self, this._then);

  final _CreateImport _self;
  final $Res Function(_CreateImport) _then;

/// Create a copy of TransactionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? transaction = null,Object? items = null,}) {
  return _then(_CreateImport(
transaction: null == transaction ? _self.transaction : transaction // ignore: cast_nullable_to_non_nullable
as entity.Transaction,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<TransactionItem>,
  ));
}


}

/// @nodoc
mixin _$TransactionState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TransactionState()';
}


}

/// @nodoc
class $TransactionStateCopyWith<$Res>  {
$TransactionStateCopyWith(TransactionState _, $Res Function(TransactionState) __);
}


/// Adds pattern-matching-related methods to [TransactionState].
extension TransactionStatePatterns on TransactionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _HistoryLoaded value)?  historyLoaded,TResult Function( _Created value)?  created,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _HistoryLoaded() when historyLoaded != null:
return historyLoaded(_that);case _Created() when created != null:
return created(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _HistoryLoaded value)  historyLoaded,required TResult Function( _Created value)  created,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _HistoryLoaded():
return historyLoaded(_that);case _Created():
return created(_that);case _Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _HistoryLoaded value)?  historyLoaded,TResult? Function( _Created value)?  created,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _HistoryLoaded() when historyLoaded != null:
return historyLoaded(_that);case _Created() when created != null:
return created(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<entity.Transaction> transactions)?  historyLoaded,TResult Function( String transactionId)?  created,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _HistoryLoaded() when historyLoaded != null:
return historyLoaded(_that.transactions);case _Created() when created != null:
return created(_that.transactionId);case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<entity.Transaction> transactions)  historyLoaded,required TResult Function( String transactionId)  created,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _HistoryLoaded():
return historyLoaded(_that.transactions);case _Created():
return created(_that.transactionId);case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<entity.Transaction> transactions)?  historyLoaded,TResult? Function( String transactionId)?  created,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _HistoryLoaded() when historyLoaded != null:
return historyLoaded(_that.transactions);case _Created() when created != null:
return created(_that.transactionId);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements TransactionState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TransactionState.initial()';
}


}




/// @nodoc


class _Loading implements TransactionState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TransactionState.loading()';
}


}




/// @nodoc


class _HistoryLoaded implements TransactionState {
  const _HistoryLoaded(final  List<entity.Transaction> transactions): _transactions = transactions;
  

 final  List<entity.Transaction> _transactions;
 List<entity.Transaction> get transactions {
  if (_transactions is EqualUnmodifiableListView) return _transactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transactions);
}


/// Create a copy of TransactionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoryLoadedCopyWith<_HistoryLoaded> get copyWith => __$HistoryLoadedCopyWithImpl<_HistoryLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryLoaded&&const DeepCollectionEquality().equals(other._transactions, _transactions));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_transactions));

@override
String toString() {
  return 'TransactionState.historyLoaded(transactions: $transactions)';
}


}

/// @nodoc
abstract mixin class _$HistoryLoadedCopyWith<$Res> implements $TransactionStateCopyWith<$Res> {
  factory _$HistoryLoadedCopyWith(_HistoryLoaded value, $Res Function(_HistoryLoaded) _then) = __$HistoryLoadedCopyWithImpl;
@useResult
$Res call({
 List<entity.Transaction> transactions
});




}
/// @nodoc
class __$HistoryLoadedCopyWithImpl<$Res>
    implements _$HistoryLoadedCopyWith<$Res> {
  __$HistoryLoadedCopyWithImpl(this._self, this._then);

  final _HistoryLoaded _self;
  final $Res Function(_HistoryLoaded) _then;

/// Create a copy of TransactionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? transactions = null,}) {
  return _then(_HistoryLoaded(
null == transactions ? _self._transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<entity.Transaction>,
  ));
}


}

/// @nodoc


class _Created implements TransactionState {
  const _Created(this.transactionId);
  

 final  String transactionId;

/// Create a copy of TransactionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatedCopyWith<_Created> get copyWith => __$CreatedCopyWithImpl<_Created>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Created&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId));
}


@override
int get hashCode => Object.hash(runtimeType,transactionId);

@override
String toString() {
  return 'TransactionState.created(transactionId: $transactionId)';
}


}

/// @nodoc
abstract mixin class _$CreatedCopyWith<$Res> implements $TransactionStateCopyWith<$Res> {
  factory _$CreatedCopyWith(_Created value, $Res Function(_Created) _then) = __$CreatedCopyWithImpl;
@useResult
$Res call({
 String transactionId
});




}
/// @nodoc
class __$CreatedCopyWithImpl<$Res>
    implements _$CreatedCopyWith<$Res> {
  __$CreatedCopyWithImpl(this._self, this._then);

  final _Created _self;
  final $Res Function(_Created) _then;

/// Create a copy of TransactionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? transactionId = null,}) {
  return _then(_Created(
null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Error implements TransactionState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of TransactionState
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
  return 'TransactionState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $TransactionStateCopyWith<$Res> {
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

/// Create a copy of TransactionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
