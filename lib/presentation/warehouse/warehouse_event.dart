part of 'warehouse_bloc.dart';

@freezed
sealed class WarehouseEvent with _$WarehouseEvent {
  const factory WarehouseEvent.loadWarehouses() = _LoadWarehouses;
  const factory WarehouseEvent.addWarehouse(Warehouse warehouse) = _AddWarehouse;
  const factory WarehouseEvent.updateWarehouse(Warehouse warehouse) = _UpdateWarehouse;
  const factory WarehouseEvent.deleteWarehouse(String id) = _DeleteWarehouse;
}
