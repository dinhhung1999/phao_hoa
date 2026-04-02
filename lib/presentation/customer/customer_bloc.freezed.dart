// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CustomerEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CustomerEvent()';
}


}

/// @nodoc
class $CustomerEventCopyWith<$Res>  {
$CustomerEventCopyWith(CustomerEvent _, $Res Function(CustomerEvent) __);
}


/// Adds pattern-matching-related methods to [CustomerEvent].
extension CustomerEventPatterns on CustomerEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _LoadCustomers value)?  loadCustomers,TResult Function( _AddCustomer value)?  addCustomer,TResult Function( _LoadDebts value)?  loadDebts,TResult Function( _MakePayment value)?  makePayment,TResult Function( _SettleAll value)?  settleAll,TResult Function( _UpdateCustomer value)?  updateCustomer,TResult Function( _DeleteCustomer value)?  deleteCustomer,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoadCustomers() when loadCustomers != null:
return loadCustomers(_that);case _AddCustomer() when addCustomer != null:
return addCustomer(_that);case _LoadDebts() when loadDebts != null:
return loadDebts(_that);case _MakePayment() when makePayment != null:
return makePayment(_that);case _SettleAll() when settleAll != null:
return settleAll(_that);case _UpdateCustomer() when updateCustomer != null:
return updateCustomer(_that);case _DeleteCustomer() when deleteCustomer != null:
return deleteCustomer(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _LoadCustomers value)  loadCustomers,required TResult Function( _AddCustomer value)  addCustomer,required TResult Function( _LoadDebts value)  loadDebts,required TResult Function( _MakePayment value)  makePayment,required TResult Function( _SettleAll value)  settleAll,required TResult Function( _UpdateCustomer value)  updateCustomer,required TResult Function( _DeleteCustomer value)  deleteCustomer,}){
final _that = this;
switch (_that) {
case _LoadCustomers():
return loadCustomers(_that);case _AddCustomer():
return addCustomer(_that);case _LoadDebts():
return loadDebts(_that);case _MakePayment():
return makePayment(_that);case _SettleAll():
return settleAll(_that);case _UpdateCustomer():
return updateCustomer(_that);case _DeleteCustomer():
return deleteCustomer(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _LoadCustomers value)?  loadCustomers,TResult? Function( _AddCustomer value)?  addCustomer,TResult? Function( _LoadDebts value)?  loadDebts,TResult? Function( _MakePayment value)?  makePayment,TResult? Function( _SettleAll value)?  settleAll,TResult? Function( _UpdateCustomer value)?  updateCustomer,TResult? Function( _DeleteCustomer value)?  deleteCustomer,}){
final _that = this;
switch (_that) {
case _LoadCustomers() when loadCustomers != null:
return loadCustomers(_that);case _AddCustomer() when addCustomer != null:
return addCustomer(_that);case _LoadDebts() when loadDebts != null:
return loadDebts(_that);case _MakePayment() when makePayment != null:
return makePayment(_that);case _SettleAll() when settleAll != null:
return settleAll(_that);case _UpdateCustomer() when updateCustomer != null:
return updateCustomer(_that);case _DeleteCustomer() when deleteCustomer != null:
return deleteCustomer(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadCustomers,TResult Function( Customer customer)?  addCustomer,TResult Function( String customerId,  Customer customer)?  loadDebts,TResult Function( String customerId,  double amount,  String? note)?  makePayment,TResult Function( String customerId)?  settleAll,TResult Function( Customer customer)?  updateCustomer,TResult Function( String customerId)?  deleteCustomer,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoadCustomers() when loadCustomers != null:
return loadCustomers();case _AddCustomer() when addCustomer != null:
return addCustomer(_that.customer);case _LoadDebts() when loadDebts != null:
return loadDebts(_that.customerId,_that.customer);case _MakePayment() when makePayment != null:
return makePayment(_that.customerId,_that.amount,_that.note);case _SettleAll() when settleAll != null:
return settleAll(_that.customerId);case _UpdateCustomer() when updateCustomer != null:
return updateCustomer(_that.customer);case _DeleteCustomer() when deleteCustomer != null:
return deleteCustomer(_that.customerId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadCustomers,required TResult Function( Customer customer)  addCustomer,required TResult Function( String customerId,  Customer customer)  loadDebts,required TResult Function( String customerId,  double amount,  String? note)  makePayment,required TResult Function( String customerId)  settleAll,required TResult Function( Customer customer)  updateCustomer,required TResult Function( String customerId)  deleteCustomer,}) {final _that = this;
switch (_that) {
case _LoadCustomers():
return loadCustomers();case _AddCustomer():
return addCustomer(_that.customer);case _LoadDebts():
return loadDebts(_that.customerId,_that.customer);case _MakePayment():
return makePayment(_that.customerId,_that.amount,_that.note);case _SettleAll():
return settleAll(_that.customerId);case _UpdateCustomer():
return updateCustomer(_that.customer);case _DeleteCustomer():
return deleteCustomer(_that.customerId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadCustomers,TResult? Function( Customer customer)?  addCustomer,TResult? Function( String customerId,  Customer customer)?  loadDebts,TResult? Function( String customerId,  double amount,  String? note)?  makePayment,TResult? Function( String customerId)?  settleAll,TResult? Function( Customer customer)?  updateCustomer,TResult? Function( String customerId)?  deleteCustomer,}) {final _that = this;
switch (_that) {
case _LoadCustomers() when loadCustomers != null:
return loadCustomers();case _AddCustomer() when addCustomer != null:
return addCustomer(_that.customer);case _LoadDebts() when loadDebts != null:
return loadDebts(_that.customerId,_that.customer);case _MakePayment() when makePayment != null:
return makePayment(_that.customerId,_that.amount,_that.note);case _SettleAll() when settleAll != null:
return settleAll(_that.customerId);case _UpdateCustomer() when updateCustomer != null:
return updateCustomer(_that.customer);case _DeleteCustomer() when deleteCustomer != null:
return deleteCustomer(_that.customerId);case _:
  return null;

}
}

}

/// @nodoc


class _LoadCustomers implements CustomerEvent {
  const _LoadCustomers();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadCustomers);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CustomerEvent.loadCustomers()';
}


}




/// @nodoc


class _AddCustomer implements CustomerEvent {
  const _AddCustomer(this.customer);
  

 final  Customer customer;

/// Create a copy of CustomerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddCustomerCopyWith<_AddCustomer> get copyWith => __$AddCustomerCopyWithImpl<_AddCustomer>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddCustomer&&(identical(other.customer, customer) || other.customer == customer));
}


@override
int get hashCode => Object.hash(runtimeType,customer);

@override
String toString() {
  return 'CustomerEvent.addCustomer(customer: $customer)';
}


}

/// @nodoc
abstract mixin class _$AddCustomerCopyWith<$Res> implements $CustomerEventCopyWith<$Res> {
  factory _$AddCustomerCopyWith(_AddCustomer value, $Res Function(_AddCustomer) _then) = __$AddCustomerCopyWithImpl;
@useResult
$Res call({
 Customer customer
});




}
/// @nodoc
class __$AddCustomerCopyWithImpl<$Res>
    implements _$AddCustomerCopyWith<$Res> {
  __$AddCustomerCopyWithImpl(this._self, this._then);

  final _AddCustomer _self;
  final $Res Function(_AddCustomer) _then;

/// Create a copy of CustomerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? customer = null,}) {
  return _then(_AddCustomer(
null == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as Customer,
  ));
}


}

/// @nodoc


class _LoadDebts implements CustomerEvent {
  const _LoadDebts({required this.customerId, required this.customer});
  

 final  String customerId;
 final  Customer customer;

/// Create a copy of CustomerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadDebtsCopyWith<_LoadDebts> get copyWith => __$LoadDebtsCopyWithImpl<_LoadDebts>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadDebts&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.customer, customer) || other.customer == customer));
}


@override
int get hashCode => Object.hash(runtimeType,customerId,customer);

@override
String toString() {
  return 'CustomerEvent.loadDebts(customerId: $customerId, customer: $customer)';
}


}

/// @nodoc
abstract mixin class _$LoadDebtsCopyWith<$Res> implements $CustomerEventCopyWith<$Res> {
  factory _$LoadDebtsCopyWith(_LoadDebts value, $Res Function(_LoadDebts) _then) = __$LoadDebtsCopyWithImpl;
@useResult
$Res call({
 String customerId, Customer customer
});




}
/// @nodoc
class __$LoadDebtsCopyWithImpl<$Res>
    implements _$LoadDebtsCopyWith<$Res> {
  __$LoadDebtsCopyWithImpl(this._self, this._then);

  final _LoadDebts _self;
  final $Res Function(_LoadDebts) _then;

/// Create a copy of CustomerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? customerId = null,Object? customer = null,}) {
  return _then(_LoadDebts(
customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,customer: null == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as Customer,
  ));
}


}

/// @nodoc


class _MakePayment implements CustomerEvent {
  const _MakePayment({required this.customerId, required this.amount, this.note});
  

 final  String customerId;
 final  double amount;
 final  String? note;

/// Create a copy of CustomerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MakePaymentCopyWith<_MakePayment> get copyWith => __$MakePaymentCopyWithImpl<_MakePayment>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MakePayment&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,customerId,amount,note);

@override
String toString() {
  return 'CustomerEvent.makePayment(customerId: $customerId, amount: $amount, note: $note)';
}


}

/// @nodoc
abstract mixin class _$MakePaymentCopyWith<$Res> implements $CustomerEventCopyWith<$Res> {
  factory _$MakePaymentCopyWith(_MakePayment value, $Res Function(_MakePayment) _then) = __$MakePaymentCopyWithImpl;
@useResult
$Res call({
 String customerId, double amount, String? note
});




}
/// @nodoc
class __$MakePaymentCopyWithImpl<$Res>
    implements _$MakePaymentCopyWith<$Res> {
  __$MakePaymentCopyWithImpl(this._self, this._then);

  final _MakePayment _self;
  final $Res Function(_MakePayment) _then;

/// Create a copy of CustomerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? customerId = null,Object? amount = null,Object? note = freezed,}) {
  return _then(_MakePayment(
customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _SettleAll implements CustomerEvent {
  const _SettleAll(this.customerId);
  

 final  String customerId;

/// Create a copy of CustomerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettleAllCopyWith<_SettleAll> get copyWith => __$SettleAllCopyWithImpl<_SettleAll>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettleAll&&(identical(other.customerId, customerId) || other.customerId == customerId));
}


@override
int get hashCode => Object.hash(runtimeType,customerId);

@override
String toString() {
  return 'CustomerEvent.settleAll(customerId: $customerId)';
}


}

/// @nodoc
abstract mixin class _$SettleAllCopyWith<$Res> implements $CustomerEventCopyWith<$Res> {
  factory _$SettleAllCopyWith(_SettleAll value, $Res Function(_SettleAll) _then) = __$SettleAllCopyWithImpl;
@useResult
$Res call({
 String customerId
});




}
/// @nodoc
class __$SettleAllCopyWithImpl<$Res>
    implements _$SettleAllCopyWith<$Res> {
  __$SettleAllCopyWithImpl(this._self, this._then);

  final _SettleAll _self;
  final $Res Function(_SettleAll) _then;

/// Create a copy of CustomerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? customerId = null,}) {
  return _then(_SettleAll(
null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _UpdateCustomer implements CustomerEvent {
  const _UpdateCustomer(this.customer);
  

 final  Customer customer;

/// Create a copy of CustomerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateCustomerCopyWith<_UpdateCustomer> get copyWith => __$UpdateCustomerCopyWithImpl<_UpdateCustomer>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateCustomer&&(identical(other.customer, customer) || other.customer == customer));
}


@override
int get hashCode => Object.hash(runtimeType,customer);

@override
String toString() {
  return 'CustomerEvent.updateCustomer(customer: $customer)';
}


}

/// @nodoc
abstract mixin class _$UpdateCustomerCopyWith<$Res> implements $CustomerEventCopyWith<$Res> {
  factory _$UpdateCustomerCopyWith(_UpdateCustomer value, $Res Function(_UpdateCustomer) _then) = __$UpdateCustomerCopyWithImpl;
@useResult
$Res call({
 Customer customer
});




}
/// @nodoc
class __$UpdateCustomerCopyWithImpl<$Res>
    implements _$UpdateCustomerCopyWith<$Res> {
  __$UpdateCustomerCopyWithImpl(this._self, this._then);

  final _UpdateCustomer _self;
  final $Res Function(_UpdateCustomer) _then;

/// Create a copy of CustomerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? customer = null,}) {
  return _then(_UpdateCustomer(
null == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as Customer,
  ));
}


}

/// @nodoc


class _DeleteCustomer implements CustomerEvent {
  const _DeleteCustomer(this.customerId);
  

 final  String customerId;

/// Create a copy of CustomerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeleteCustomerCopyWith<_DeleteCustomer> get copyWith => __$DeleteCustomerCopyWithImpl<_DeleteCustomer>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteCustomer&&(identical(other.customerId, customerId) || other.customerId == customerId));
}


@override
int get hashCode => Object.hash(runtimeType,customerId);

@override
String toString() {
  return 'CustomerEvent.deleteCustomer(customerId: $customerId)';
}


}

/// @nodoc
abstract mixin class _$DeleteCustomerCopyWith<$Res> implements $CustomerEventCopyWith<$Res> {
  factory _$DeleteCustomerCopyWith(_DeleteCustomer value, $Res Function(_DeleteCustomer) _then) = __$DeleteCustomerCopyWithImpl;
@useResult
$Res call({
 String customerId
});




}
/// @nodoc
class __$DeleteCustomerCopyWithImpl<$Res>
    implements _$DeleteCustomerCopyWith<$Res> {
  __$DeleteCustomerCopyWithImpl(this._self, this._then);

  final _DeleteCustomer _self;
  final $Res Function(_DeleteCustomer) _then;

/// Create a copy of CustomerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? customerId = null,}) {
  return _then(_DeleteCustomer(
null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$CustomerState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CustomerState()';
}


}

/// @nodoc
class $CustomerStateCopyWith<$Res>  {
$CustomerStateCopyWith(CustomerState _, $Res Function(CustomerState) __);
}


/// Adds pattern-matching-related methods to [CustomerState].
extension CustomerStatePatterns on CustomerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _CustomersLoaded value)?  customersLoaded,TResult Function( _DebtsLoaded value)?  debtsLoaded,TResult Function( _ActionSuccess value)?  actionSuccess,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _CustomersLoaded() when customersLoaded != null:
return customersLoaded(_that);case _DebtsLoaded() when debtsLoaded != null:
return debtsLoaded(_that);case _ActionSuccess() when actionSuccess != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _CustomersLoaded value)  customersLoaded,required TResult Function( _DebtsLoaded value)  debtsLoaded,required TResult Function( _ActionSuccess value)  actionSuccess,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _CustomersLoaded():
return customersLoaded(_that);case _DebtsLoaded():
return debtsLoaded(_that);case _ActionSuccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _CustomersLoaded value)?  customersLoaded,TResult? Function( _DebtsLoaded value)?  debtsLoaded,TResult? Function( _ActionSuccess value)?  actionSuccess,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _CustomersLoaded() when customersLoaded != null:
return customersLoaded(_that);case _DebtsLoaded() when debtsLoaded != null:
return debtsLoaded(_that);case _ActionSuccess() when actionSuccess != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Customer> customers)?  customersLoaded,TResult Function( Customer customer,  List<DebtRecord> records)?  debtsLoaded,TResult Function( String message)?  actionSuccess,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _CustomersLoaded() when customersLoaded != null:
return customersLoaded(_that.customers);case _DebtsLoaded() when debtsLoaded != null:
return debtsLoaded(_that.customer,_that.records);case _ActionSuccess() when actionSuccess != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Customer> customers)  customersLoaded,required TResult Function( Customer customer,  List<DebtRecord> records)  debtsLoaded,required TResult Function( String message)  actionSuccess,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _CustomersLoaded():
return customersLoaded(_that.customers);case _DebtsLoaded():
return debtsLoaded(_that.customer,_that.records);case _ActionSuccess():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Customer> customers)?  customersLoaded,TResult? Function( Customer customer,  List<DebtRecord> records)?  debtsLoaded,TResult? Function( String message)?  actionSuccess,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _CustomersLoaded() when customersLoaded != null:
return customersLoaded(_that.customers);case _DebtsLoaded() when debtsLoaded != null:
return debtsLoaded(_that.customer,_that.records);case _ActionSuccess() when actionSuccess != null:
return actionSuccess(_that.message);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements CustomerState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CustomerState.initial()';
}


}




/// @nodoc


class _Loading implements CustomerState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CustomerState.loading()';
}


}




/// @nodoc


class _CustomersLoaded implements CustomerState {
  const _CustomersLoaded(final  List<Customer> customers): _customers = customers;
  

 final  List<Customer> _customers;
 List<Customer> get customers {
  if (_customers is EqualUnmodifiableListView) return _customers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_customers);
}


/// Create a copy of CustomerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomersLoadedCopyWith<_CustomersLoaded> get copyWith => __$CustomersLoadedCopyWithImpl<_CustomersLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomersLoaded&&const DeepCollectionEquality().equals(other._customers, _customers));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_customers));

@override
String toString() {
  return 'CustomerState.customersLoaded(customers: $customers)';
}


}

/// @nodoc
abstract mixin class _$CustomersLoadedCopyWith<$Res> implements $CustomerStateCopyWith<$Res> {
  factory _$CustomersLoadedCopyWith(_CustomersLoaded value, $Res Function(_CustomersLoaded) _then) = __$CustomersLoadedCopyWithImpl;
@useResult
$Res call({
 List<Customer> customers
});




}
/// @nodoc
class __$CustomersLoadedCopyWithImpl<$Res>
    implements _$CustomersLoadedCopyWith<$Res> {
  __$CustomersLoadedCopyWithImpl(this._self, this._then);

  final _CustomersLoaded _self;
  final $Res Function(_CustomersLoaded) _then;

/// Create a copy of CustomerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? customers = null,}) {
  return _then(_CustomersLoaded(
null == customers ? _self._customers : customers // ignore: cast_nullable_to_non_nullable
as List<Customer>,
  ));
}


}

/// @nodoc


class _DebtsLoaded implements CustomerState {
  const _DebtsLoaded({required this.customer, required final  List<DebtRecord> records}): _records = records;
  

 final  Customer customer;
 final  List<DebtRecord> _records;
 List<DebtRecord> get records {
  if (_records is EqualUnmodifiableListView) return _records;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_records);
}


/// Create a copy of CustomerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DebtsLoadedCopyWith<_DebtsLoaded> get copyWith => __$DebtsLoadedCopyWithImpl<_DebtsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DebtsLoaded&&(identical(other.customer, customer) || other.customer == customer)&&const DeepCollectionEquality().equals(other._records, _records));
}


@override
int get hashCode => Object.hash(runtimeType,customer,const DeepCollectionEquality().hash(_records));

@override
String toString() {
  return 'CustomerState.debtsLoaded(customer: $customer, records: $records)';
}


}

/// @nodoc
abstract mixin class _$DebtsLoadedCopyWith<$Res> implements $CustomerStateCopyWith<$Res> {
  factory _$DebtsLoadedCopyWith(_DebtsLoaded value, $Res Function(_DebtsLoaded) _then) = __$DebtsLoadedCopyWithImpl;
@useResult
$Res call({
 Customer customer, List<DebtRecord> records
});




}
/// @nodoc
class __$DebtsLoadedCopyWithImpl<$Res>
    implements _$DebtsLoadedCopyWith<$Res> {
  __$DebtsLoadedCopyWithImpl(this._self, this._then);

  final _DebtsLoaded _self;
  final $Res Function(_DebtsLoaded) _then;

/// Create a copy of CustomerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? customer = null,Object? records = null,}) {
  return _then(_DebtsLoaded(
customer: null == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as Customer,records: null == records ? _self._records : records // ignore: cast_nullable_to_non_nullable
as List<DebtRecord>,
  ));
}


}

/// @nodoc


class _ActionSuccess implements CustomerState {
  const _ActionSuccess(this.message);
  

 final  String message;

/// Create a copy of CustomerState
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
  return 'CustomerState.actionSuccess(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ActionSuccessCopyWith<$Res> implements $CustomerStateCopyWith<$Res> {
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

/// Create a copy of CustomerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_ActionSuccess(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Error implements CustomerState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of CustomerState
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
  return 'CustomerState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $CustomerStateCopyWith<$Res> {
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

/// Create a copy of CustomerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
