import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/warehouse_stock.dart';
import '../../domain/usecases/inventory/inventory_usecases.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';
part 'dashboard_bloc.freezed.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardSummary _getDashboardSummary;
  final GetTotalInventoryValue _getTotalInventoryValue;

  DashboardBloc({
    required GetDashboardSummary getDashboardSummary,
    required GetTotalInventoryValue getTotalInventoryValue,
  })  : _getDashboardSummary = getDashboardSummary,
        _getTotalInventoryValue = getTotalInventoryValue,
        super(const DashboardState.initial()) {
    on<DashboardEvent>((event, emit) async {
      await event.map(
        loadDashboard: (_) => _onLoad(emit),
        refreshDashboard: (_) => _onLoad(emit),
      );
    });
  }

  Future<void> _onLoad(Emitter<DashboardState> emit) async {
    emit(const DashboardState.loading());
    final stocksResult = await _getDashboardSummary();
    final valueResult = await _getTotalInventoryValue();
    stocksResult.fold(
      (failure) => emit(DashboardState.error(failure.message)),
      (stocks) {
        valueResult.fold(
          (failure) => emit(DashboardState.error(failure.message)),
          (value) => emit(DashboardState.loaded(
            stocks: stocks,
            totalValue: value,
          )),
        );
      },
    );
  }
}
