part of 'warehouse_bloc.dart';

@freezed
sealed class WarehouseState with _$WarehouseState {
  const factory WarehouseState.initial() = _Initial;
  const factory WarehouseState.loading() = _Loading;
  const factory WarehouseState.loaded(List<Warehouse> warehouses) = _Loaded;
  const factory WarehouseState.actionSuccess(String message) = _ActionSuccess;
  const factory WarehouseState.error(String message) = _Error;
}
