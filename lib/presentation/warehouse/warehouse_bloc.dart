import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/warehouse.dart';
import '../../domain/usecases/warehouse/warehouse_usecases.dart';

part 'warehouse_event.dart';
part 'warehouse_state.dart';
part 'warehouse_bloc.freezed.dart';

class WarehouseBloc extends Bloc<WarehouseEvent, WarehouseState> {
  final GetAllWarehouses _getAllWarehouses;
  final AddWarehouse _addWarehouse;
  final UpdateWarehouse _updateWarehouse;
  final DeleteWarehouse _deleteWarehouse;

  WarehouseBloc({
    required GetAllWarehouses getAllWarehouses,
    required AddWarehouse addWarehouse,
    required UpdateWarehouse updateWarehouse,
    required DeleteWarehouse deleteWarehouse,
  })  : _getAllWarehouses = getAllWarehouses,
        _addWarehouse = addWarehouse,
        _updateWarehouse = updateWarehouse,
        _deleteWarehouse = deleteWarehouse,
        super(const WarehouseState.initial()) {
    on<WarehouseEvent>((event, emit) async {
      await event.map(
        loadWarehouses: (_) => _onLoad(emit),
        addWarehouse: (e) => _onAdd(e, emit),
        updateWarehouse: (e) => _onUpdate(e, emit),
        deleteWarehouse: (e) => _onDelete(e, emit),
      );
    });
  }

  Future<void> _onLoad(Emitter<WarehouseState> emit) async {
    emit(const WarehouseState.loading());
    final result = await _getAllWarehouses();
    result.fold(
      (f) => emit(WarehouseState.error(f.message)),
      (warehouses) => emit(WarehouseState.loaded(warehouses)),
    );
  }

  Future<void> _onAdd(
    _AddWarehouse event, Emitter<WarehouseState> emit,
  ) async {
    emit(const WarehouseState.loading());
    final result = await _addWarehouse(event.warehouse);
    result.fold(
      (f) => emit(WarehouseState.error(f.message)),
      (_) {
        emit(const WarehouseState.actionSuccess('Đã thêm kho hàng'));
        add(const WarehouseEvent.loadWarehouses());
      },
    );
  }

  Future<void> _onUpdate(
    _UpdateWarehouse event, Emitter<WarehouseState> emit,
  ) async {
    emit(const WarehouseState.loading());
    final result = await _updateWarehouse(event.warehouse);
    result.fold(
      (f) => emit(WarehouseState.error(f.message)),
      (_) {
        emit(const WarehouseState.actionSuccess('Đã cập nhật kho hàng'));
        add(const WarehouseEvent.loadWarehouses());
      },
    );
  }

  Future<void> _onDelete(
    _DeleteWarehouse event, Emitter<WarehouseState> emit,
  ) async {
    emit(const WarehouseState.loading());
    final result = await _deleteWarehouse(event.id);
    result.fold(
      (f) => emit(WarehouseState.error(f.message)),
      (_) {
        emit(const WarehouseState.actionSuccess('Đã xóa kho hàng'));
        add(const WarehouseEvent.loadWarehouses());
      },
    );
  }
}
