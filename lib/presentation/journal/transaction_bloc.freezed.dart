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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _LoadHistory value)?  loadHistory,TResult Function( _CreateExport value)?  createExport,TResult Function( _CreateImport value)?  createImport,TResult Function( _LoadHistoryPaginated value)?  loadHistoryPaginated,TResult Function( _LoadMoreHistory value)?  loadMoreHistory,TResult Function( _RefreshHistory value)?  refreshHistory,TResult Function( _UpdateDebtPayment value)?  updateDebtPayment,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoadHistory() when loadHistory != null:
return loadHistory(_that);case _CreateExport() when createExport != null:
return createExport(_that);case _CreateImport() when createImport != null:
return createImport(_that);case _LoadHistoryPaginated() when loadHistoryPaginated != null:
return loadHistoryPaginated(_that);case _LoadMoreHistory() when loadMoreHistory != null:
return loadMoreHistory(_that);case _RefreshHistory() when refreshHistory != null:
return refreshHistory(_that);case _UpdateDebtPayment() when updateDebtPayment != null:
return updateDebtPayment(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _LoadHistory value)  loadHistory,required TResult Function( _CreateExport value)  createExport,required TResult Function( _CreateImport value)  createImport,required TResult Function( _LoadHistoryPaginated value)  loadHistoryPaginated,required TResult Function( _LoadMoreHistory value)  loadMoreHistory,required TResult Function( _RefreshHistory value)  refreshHistory,required TResult Function( _UpdateDebtPayment value)  updateDebtPayment,}){
final _that = this;
switch (_that) {
case _LoadHistory():
return loadHistory(_that);case _CreateExport():
return createExport(_that);case _CreateImport():
return createImport(_that);case _LoadHistoryPaginated():
return loadHistoryPaginated(_that);case _LoadMoreHistory():
return loadMoreHistory(_that);case _RefreshHistory():
return refreshHistory(_that);case _UpdateDebtPayment():
return updateDebtPayment(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _LoadHistory value)?  loadHistory,TResult? Function( _CreateExport value)?  createExport,TResult? Function( _CreateImport value)?  createImport,TResult? Function( _LoadHistoryPaginated value)?  loadHistoryPaginated,TResult? Function( _LoadMoreHistory value)?  loadMoreHistory,TResult? Function( _RefreshHistory value)?  refreshHistory,TResult? Function( _UpdateDebtPayment value)?  updateDebtPayment,}){
final _that = this;
switch (_that) {
case _LoadHistory() when loadHistory != null:
return loadHistory(_that);case _CreateExport() when createExport != null:
return createExport(_that);case _CreateImport() when createImport != null:
return createImport(_that);case _LoadHistoryPaginated() when loadHistoryPaginated != null:
return loadHistoryPaginated(_that);case _LoadMoreHistory() when loadMoreHistory != null:
return loadMoreHistory(_that);case _RefreshHistory() when refreshHistory != null:
return refreshHistory(_that);case _UpdateDebtPayment() when updateDebtPayment != null:
return updateDebtPayment(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( DateTime? startDate,  DateTime? endDate,  String? type,  String? warehouseLocation)?  loadHistory,TResult Function( entity.Transaction transaction,  List<TransactionItem> items)?  createExport,TResult Function( entity.Transaction transaction,  List<TransactionItem> items)?  createImport,TResult Function( DateTime? startDate,  DateTime? endDate,  String? type,  String? warehouseLocation)?  loadHistoryPaginated,TResult Function()?  loadMoreHistory,TResult Function( DateTime? startDate,  DateTime? endDate,  String? type,  String? warehouseLocation)?  refreshHistory,TResult Function( String transactionId,  double newPaidAmount,  double totalValue,  String? customerId,  double previousPaidAmount)?  updateDebtPayment,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoadHistory() when loadHistory != null:
return loadHistory(_that.startDate,_that.endDate,_that.type,_that.warehouseLocation);case _CreateExport() when createExport != null:
return createExport(_that.transaction,_that.items);case _CreateImport() when createImport != null:
return createImport(_that.transaction,_that.items);case _LoadHistoryPaginated() when loadHistoryPaginated != null:
return loadHistoryPaginated(_that.startDate,_that.endDate,_that.type,_that.warehouseLocation);case _LoadMoreHistory() when loadMoreHistory != null:
return loadMoreHistory();case _RefreshHistory() when refreshHistory != null:
return refreshHistory(_that.startDate,_that.endDate,_that.type,_that.warehouseLocation);case _UpdateDebtPayment() when updateDebtPayment != null:
return updateDebtPayment(_that.transactionId,_that.newPaidAmount,_that.totalValue,_that.customerId,_that.previousPaidAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( DateTime? startDate,  DateTime? endDate,  String? type,  String? warehouseLocation)  loadHistory,required TResult Function( entity.Transaction transaction,  List<TransactionItem> items)  createExport,required TResult Function( entity.Transaction transaction,  List<TransactionItem> items)  createImport,required TResult Function( DateTime? startDate,  DateTime? endDate,  String? type,  String? warehouseLocation)  loadHistoryPaginated,required TResult Function()  loadMoreHistory,required TResult Function( DateTime? startDate,  DateTime? endDate,  String? type,  String? warehouseLocation)  refreshHistory,required TResult Function( String transactionId,  double newPaidAmount,  double totalValue,  String? customerId,  double previousPaidAmount)  updateDebtPayment,}) {final _that = this;
switch (_that) {
case _LoadHistory():
return loadHistory(_that.startDate,_that.endDate,_that.type,_that.warehouseLocation);case _CreateExport():
return createExport(_that.transaction,_that.items);case _CreateImport():
return createImport(_that.transaction,_that.items);case _LoadHistoryPaginated():
return loadHistoryPaginated(_that.startDate,_that.endDate,_that.type,_that.warehouseLocation);case _LoadMoreHistory():
return loadMoreHistory();case _RefreshHistory():
return refreshHistory(_that.startDate,_that.endDate,_that.type,_that.warehouseLocation);case _UpdateDebtPayment():
return updateDebtPayment(_that.transactionId,_that.newPaidAmount,_that.totalValue,_that.customerId,_that.previousPaidAmount);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( DateTime? startDate,  DateTime? endDate,  String? type,  String? warehouseLocation)?  loadHistory,TResult? Function( entity.Transaction transaction,  List<TransactionItem> items)?  createExport,TResult? Function( entity.Transaction transaction,  List<TransactionItem> items)?  createImport,TResult? Function( DateTime? startDate,  DateTime? endDate,  String? type,  String? warehouseLocation)?  loadHistoryPaginated,TResult? Function()?  loadMoreHistory,TResult? Function( DateTime? startDate,  DateTime? endDate,  String? type,  String? warehouseLocation)?  refreshHistory,TResult? Function( String transactionId,  double newPaidAmount,  double totalValue,  String? customerId,  double previousPaidAmount)?  updateDebtPayment,}) {final _that = this;
switch (_that) {
case _LoadHistory() when loadHistory != null:
return loadHistory(_that.startDate,_that.endDate,_that.type,_that.warehouseLocation);case _CreateExport() when createExport != null:
return createExport(_that.transaction,_that.items);case _CreateImport() when createImport != null:
return createImport(_that.transaction,_that.items);case _LoadHistoryPaginated() when loadHistoryPaginated != null:
return loadHistoryPaginated(_that.startDate,_that.endDate,_that.type,_that.warehouseLocation);case _LoadMoreHistory() when loadMoreHistory != null:
return loadMoreHistory();case _RefreshHistory() when refreshHistory != null:
return refreshHistory(_that.startDate,_that.endDate,_that.type,_that.warehouseLocation);case _UpdateDebtPayment() when updateDebtPayment != null:
return updateDebtPayment(_that.transactionId,_that.newPaidAmount,_that.totalValue,_that.customerId,_that.previousPaidAmount);case _:
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


class _LoadHistoryPaginated implements TransactionEvent {
  const _LoadHistoryPaginated({this.startDate, this.endDate, this.type, this.warehouseLocation});
  

 final  DateTime? startDate;
 final  DateTime? endDate;
 final  String? type;
 final  String? warehouseLocation;

/// Create a copy of TransactionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadHistoryPaginatedCopyWith<_LoadHistoryPaginated> get copyWith => __$LoadHistoryPaginatedCopyWithImpl<_LoadHistoryPaginated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadHistoryPaginated&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.type, type) || other.type == type)&&(identical(other.warehouseLocation, warehouseLocation) || other.warehouseLocation == warehouseLocation));
}


@override
int get hashCode => Object.hash(runtimeType,startDate,endDate,type,warehouseLocation);

@override
String toString() {
  return 'TransactionEvent.loadHistoryPaginated(startDate: $startDate, endDate: $endDate, type: $type, warehouseLocation: $warehouseLocation)';
}


}

/// @nodoc
abstract mixin class _$LoadHistoryPaginatedCopyWith<$Res> implements $TransactionEventCopyWith<$Res> {
  factory _$LoadHistoryPaginatedCopyWith(_LoadHistoryPaginated value, $Res Function(_LoadHistoryPaginated) _then) = __$LoadHistoryPaginatedCopyWithImpl;
@useResult
$Res call({
 DateTime? startDate, DateTime? endDate, String? type, String? warehouseLocation
});




}
/// @nodoc
class __$LoadHistoryPaginatedCopyWithImpl<$Res>
    implements _$LoadHistoryPaginatedCopyWith<$Res> {
  __$LoadHistoryPaginatedCopyWithImpl(this._self, this._then);

  final _LoadHistoryPaginated _self;
  final $Res Function(_LoadHistoryPaginated) _then;

/// Create a copy of TransactionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? startDate = freezed,Object? endDate = freezed,Object? type = freezed,Object? warehouseLocation = freezed,}) {
  return _then(_LoadHistoryPaginated(
startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,warehouseLocation: freezed == warehouseLocation ? _self.warehouseLocation : warehouseLocation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _LoadMoreHistory implements TransactionEvent {
  const _LoadMoreHistory();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadMoreHistory);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TransactionEvent.loadMoreHistory()';
}


}




/// @nodoc


class _RefreshHistory implements TransactionEvent {
  const _RefreshHistory({this.startDate, this.endDate, this.type, this.warehouseLocation});
  

 final  DateTime? startDate;
 final  DateTime? endDate;
 final  String? type;
 final  String? warehouseLocation;

/// Create a copy of TransactionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RefreshHistoryCopyWith<_RefreshHistory> get copyWith => __$RefreshHistoryCopyWithImpl<_RefreshHistory>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RefreshHistory&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.type, type) || other.type == type)&&(identical(other.warehouseLocation, warehouseLocation) || other.warehouseLocation == warehouseLocation));
}


@override
int get hashCode => Object.hash(runtimeType,startDate,endDate,type,warehouseLocation);

@override
String toString() {
  return 'TransactionEvent.refreshHistory(startDate: $startDate, endDate: $endDate, type: $type, warehouseLocation: $warehouseLocation)';
}


}

/// @nodoc
abstract mixin class _$RefreshHistoryCopyWith<$Res> implements $TransactionEventCopyWith<$Res> {
  factory _$RefreshHistoryCopyWith(_RefreshHistory value, $Res Function(_RefreshHistory) _then) = __$RefreshHistoryCopyWithImpl;
@useResult
$Res call({
 DateTime? startDate, DateTime? endDate, String? type, String? warehouseLocation
});




}
/// @nodoc
class __$RefreshHistoryCopyWithImpl<$Res>
    implements _$RefreshHistoryCopyWith<$Res> {
  __$RefreshHistoryCopyWithImpl(this._self, this._then);

  final _RefreshHistory _self;
  final $Res Function(_RefreshHistory) _then;

/// Create a copy of TransactionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? startDate = freezed,Object? endDate = freezed,Object? type = freezed,Object? warehouseLocation = freezed,}) {
  return _then(_RefreshHistory(
startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,warehouseLocation: freezed == warehouseLocation ? _self.warehouseLocation : warehouseLocation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _UpdateDebtPayment implements TransactionEvent {
  const _UpdateDebtPayment({required this.transactionId, required this.newPaidAmount, required this.totalValue, this.customerId, required this.previousPaidAmount});
  

 final  String transactionId;
 final  double newPaidAmount;
 final  double totalValue;
 final  String? customerId;
 final  double previousPaidAmount;

/// Create a copy of TransactionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateDebtPaymentCopyWith<_UpdateDebtPayment> get copyWith => __$UpdateDebtPaymentCopyWithImpl<_UpdateDebtPayment>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateDebtPayment&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.newPaidAmount, newPaidAmount) || other.newPaidAmount == newPaidAmount)&&(identical(other.totalValue, totalValue) || other.totalValue == totalValue)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.previousPaidAmount, previousPaidAmount) || other.previousPaidAmount == previousPaidAmount));
}


@override
int get hashCode => Object.hash(runtimeType,transactionId,newPaidAmount,totalValue,customerId,previousPaidAmount);

@override
String toString() {
  return 'TransactionEvent.updateDebtPayment(transactionId: $transactionId, newPaidAmount: $newPaidAmount, totalValue: $totalValue, customerId: $customerId, previousPaidAmount: $previousPaidAmount)';
}


}

/// @nodoc
abstract mixin class _$UpdateDebtPaymentCopyWith<$Res> implements $TransactionEventCopyWith<$Res> {
  factory _$UpdateDebtPaymentCopyWith(_UpdateDebtPayment value, $Res Function(_UpdateDebtPayment) _then) = __$UpdateDebtPaymentCopyWithImpl;
@useResult
$Res call({
 String transactionId, double newPaidAmount, double totalValue, String? customerId, double previousPaidAmount
});




}
/// @nodoc
class __$UpdateDebtPaymentCopyWithImpl<$Res>
    implements _$UpdateDebtPaymentCopyWith<$Res> {
  __$UpdateDebtPaymentCopyWithImpl(this._self, this._then);

  final _UpdateDebtPayment _self;
  final $Res Function(_UpdateDebtPayment) _then;

/// Create a copy of TransactionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? transactionId = null,Object? newPaidAmount = null,Object? totalValue = null,Object? customerId = freezed,Object? previousPaidAmount = null,}) {
  return _then(_UpdateDebtPayment(
transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String,newPaidAmount: null == newPaidAmount ? _self.newPaidAmount : newPaidAmount // ignore: cast_nullable_to_non_nullable
as double,totalValue: null == totalValue ? _self.totalValue : totalValue // ignore: cast_nullable_to_non_nullable
as double,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,previousPaidAmount: null == previousPaidAmount ? _self.previousPaidAmount : previousPaidAmount // ignore: cast_nullable_to_non_nullable
as double,
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _HistoryLoaded value)?  historyLoaded,TResult Function( _Created value)?  created,TResult Function( _Error value)?  error,TResult Function( _DebtUpdated value)?  debtUpdated,TResult Function( _PaginatedHistoryLoaded value)?  paginatedHistoryLoaded,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _HistoryLoaded() when historyLoaded != null:
return historyLoaded(_that);case _Created() when created != null:
return created(_that);case _Error() when error != null:
return error(_that);case _DebtUpdated() when debtUpdated != null:
return debtUpdated(_that);case _PaginatedHistoryLoaded() when paginatedHistoryLoaded != null:
return paginatedHistoryLoaded(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _HistoryLoaded value)  historyLoaded,required TResult Function( _Created value)  created,required TResult Function( _Error value)  error,required TResult Function( _DebtUpdated value)  debtUpdated,required TResult Function( _PaginatedHistoryLoaded value)  paginatedHistoryLoaded,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _HistoryLoaded():
return historyLoaded(_that);case _Created():
return created(_that);case _Error():
return error(_that);case _DebtUpdated():
return debtUpdated(_that);case _PaginatedHistoryLoaded():
return paginatedHistoryLoaded(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _HistoryLoaded value)?  historyLoaded,TResult? Function( _Created value)?  created,TResult? Function( _Error value)?  error,TResult? Function( _DebtUpdated value)?  debtUpdated,TResult? Function( _PaginatedHistoryLoaded value)?  paginatedHistoryLoaded,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _HistoryLoaded() when historyLoaded != null:
return historyLoaded(_that);case _Created() when created != null:
return created(_that);case _Error() when error != null:
return error(_that);case _DebtUpdated() when debtUpdated != null:
return debtUpdated(_that);case _PaginatedHistoryLoaded() when paginatedHistoryLoaded != null:
return paginatedHistoryLoaded(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<entity.Transaction> transactions)?  historyLoaded,TResult Function( String transactionId)?  created,TResult Function( String message)?  error,TResult Function( String transactionId)?  debtUpdated,TResult Function( List<entity.Transaction> transactions,  bool hasMore,  bool isLoadingMore,  dynamic lastDocument,  DateTime? startDate,  DateTime? endDate,  String? type,  String? warehouseLocation,  String? error)?  paginatedHistoryLoaded,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _HistoryLoaded() when historyLoaded != null:
return historyLoaded(_that.transactions);case _Created() when created != null:
return created(_that.transactionId);case _Error() when error != null:
return error(_that.message);case _DebtUpdated() when debtUpdated != null:
return debtUpdated(_that.transactionId);case _PaginatedHistoryLoaded() when paginatedHistoryLoaded != null:
return paginatedHistoryLoaded(_that.transactions,_that.hasMore,_that.isLoadingMore,_that.lastDocument,_that.startDate,_that.endDate,_that.type,_that.warehouseLocation,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<entity.Transaction> transactions)  historyLoaded,required TResult Function( String transactionId)  created,required TResult Function( String message)  error,required TResult Function( String transactionId)  debtUpdated,required TResult Function( List<entity.Transaction> transactions,  bool hasMore,  bool isLoadingMore,  dynamic lastDocument,  DateTime? startDate,  DateTime? endDate,  String? type,  String? warehouseLocation,  String? error)  paginatedHistoryLoaded,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _HistoryLoaded():
return historyLoaded(_that.transactions);case _Created():
return created(_that.transactionId);case _Error():
return error(_that.message);case _DebtUpdated():
return debtUpdated(_that.transactionId);case _PaginatedHistoryLoaded():
return paginatedHistoryLoaded(_that.transactions,_that.hasMore,_that.isLoadingMore,_that.lastDocument,_that.startDate,_that.endDate,_that.type,_that.warehouseLocation,_that.error);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<entity.Transaction> transactions)?  historyLoaded,TResult? Function( String transactionId)?  created,TResult? Function( String message)?  error,TResult? Function( String transactionId)?  debtUpdated,TResult? Function( List<entity.Transaction> transactions,  bool hasMore,  bool isLoadingMore,  dynamic lastDocument,  DateTime? startDate,  DateTime? endDate,  String? type,  String? warehouseLocation,  String? error)?  paginatedHistoryLoaded,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _HistoryLoaded() when historyLoaded != null:
return historyLoaded(_that.transactions);case _Created() when created != null:
return created(_that.transactionId);case _Error() when error != null:
return error(_that.message);case _DebtUpdated() when debtUpdated != null:
return debtUpdated(_that.transactionId);case _PaginatedHistoryLoaded() when paginatedHistoryLoaded != null:
return paginatedHistoryLoaded(_that.transactions,_that.hasMore,_that.isLoadingMore,_that.lastDocument,_that.startDate,_that.endDate,_that.type,_that.warehouseLocation,_that.error);case _:
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

/// @nodoc


class _DebtUpdated implements TransactionState {
  const _DebtUpdated(this.transactionId);
  

 final  String transactionId;

/// Create a copy of TransactionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DebtUpdatedCopyWith<_DebtUpdated> get copyWith => __$DebtUpdatedCopyWithImpl<_DebtUpdated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DebtUpdated&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId));
}


@override
int get hashCode => Object.hash(runtimeType,transactionId);

@override
String toString() {
  return 'TransactionState.debtUpdated(transactionId: $transactionId)';
}


}

/// @nodoc
abstract mixin class _$DebtUpdatedCopyWith<$Res> implements $TransactionStateCopyWith<$Res> {
  factory _$DebtUpdatedCopyWith(_DebtUpdated value, $Res Function(_DebtUpdated) _then) = __$DebtUpdatedCopyWithImpl;
@useResult
$Res call({
 String transactionId
});




}
/// @nodoc
class __$DebtUpdatedCopyWithImpl<$Res>
    implements _$DebtUpdatedCopyWith<$Res> {
  __$DebtUpdatedCopyWithImpl(this._self, this._then);

  final _DebtUpdated _self;
  final $Res Function(_DebtUpdated) _then;

/// Create a copy of TransactionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? transactionId = null,}) {
  return _then(_DebtUpdated(
null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _PaginatedHistoryLoaded implements TransactionState {
  const _PaginatedHistoryLoaded({required final  List<entity.Transaction> transactions, required this.hasMore, this.isLoadingMore = false, this.lastDocument, this.startDate, this.endDate, this.type, this.warehouseLocation, this.error}): _transactions = transactions;
  

 final  List<entity.Transaction> _transactions;
 List<entity.Transaction> get transactions {
  if (_transactions is EqualUnmodifiableListView) return _transactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transactions);
}

 final  bool hasMore;
@JsonKey() final  bool isLoadingMore;
 final  dynamic lastDocument;
// Preserve current filter params
 final  DateTime? startDate;
 final  DateTime? endDate;
 final  String? type;
 final  String? warehouseLocation;
 final  String? error;

/// Create a copy of TransactionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaginatedHistoryLoadedCopyWith<_PaginatedHistoryLoaded> get copyWith => __$PaginatedHistoryLoadedCopyWithImpl<_PaginatedHistoryLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaginatedHistoryLoaded&&const DeepCollectionEquality().equals(other._transactions, _transactions)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&const DeepCollectionEquality().equals(other.lastDocument, lastDocument)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.type, type) || other.type == type)&&(identical(other.warehouseLocation, warehouseLocation) || other.warehouseLocation == warehouseLocation)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_transactions),hasMore,isLoadingMore,const DeepCollectionEquality().hash(lastDocument),startDate,endDate,type,warehouseLocation,error);

@override
String toString() {
  return 'TransactionState.paginatedHistoryLoaded(transactions: $transactions, hasMore: $hasMore, isLoadingMore: $isLoadingMore, lastDocument: $lastDocument, startDate: $startDate, endDate: $endDate, type: $type, warehouseLocation: $warehouseLocation, error: $error)';
}


}

/// @nodoc
abstract mixin class _$PaginatedHistoryLoadedCopyWith<$Res> implements $TransactionStateCopyWith<$Res> {
  factory _$PaginatedHistoryLoadedCopyWith(_PaginatedHistoryLoaded value, $Res Function(_PaginatedHistoryLoaded) _then) = __$PaginatedHistoryLoadedCopyWithImpl;
@useResult
$Res call({
 List<entity.Transaction> transactions, bool hasMore, bool isLoadingMore, dynamic lastDocument, DateTime? startDate, DateTime? endDate, String? type, String? warehouseLocation, String? error
});




}
/// @nodoc
class __$PaginatedHistoryLoadedCopyWithImpl<$Res>
    implements _$PaginatedHistoryLoadedCopyWith<$Res> {
  __$PaginatedHistoryLoadedCopyWithImpl(this._self, this._then);

  final _PaginatedHistoryLoaded _self;
  final $Res Function(_PaginatedHistoryLoaded) _then;

/// Create a copy of TransactionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? transactions = null,Object? hasMore = null,Object? isLoadingMore = null,Object? lastDocument = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? type = freezed,Object? warehouseLocation = freezed,Object? error = freezed,}) {
  return _then(_PaginatedHistoryLoaded(
transactions: null == transactions ? _self._transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<entity.Transaction>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,lastDocument: freezed == lastDocument ? _self.lastDocument : lastDocument // ignore: cast_nullable_to_non_nullable
as dynamic,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,warehouseLocation: freezed == warehouseLocation ? _self.warehouseLocation : warehouseLocation // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
