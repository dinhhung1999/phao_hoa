import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/warehouse_stock.dart';
import '../../domain/usecases/inventory/inventory_usecases.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';
part 'dashboard_bloc.freezed.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetTotalInventoryValue _getTotalInventoryValue;
  final WatchDashboardStocks _watchDashboardStocks;

  StreamSubscription<List<WarehouseStock>>? _stockSubscription;

  DashboardBloc({
    required GetDashboardSummary getDashboardSummary,
    required GetTotalInventoryValue getTotalInventoryValue,
    required WatchDashboardStocks watchDashboardStocks,
  })  : _getTotalInventoryValue = getTotalInventoryValue,
        _watchDashboardStocks = watchDashboardStocks,
        super(const DashboardState.initial()) {
    on<DashboardEvent>((event, emit) async {
      await event.map(
        loadDashboard: (_) => _onLoad(emit),
        refreshDashboard: (_) => _onRefresh(emit),
        stocksUpdated: (e) => _onStocksUpdated(e, emit),
      );
    });
  }

  /// Initial load: start streaming and also calculate total value
  Future<void> _onLoad(Emitter<DashboardState> emit) async {
    emit(const DashboardState.loading());
    // Reload warehouse names from Firestore to pick up renames from other users
    await AppConstants.loadWarehouseNames();

    // Cancel any existing subscription
    await _stockSubscription?.cancel();

    // Subscribe to realtime stock updates
    _stockSubscription = _watchDashboardStocks().listen(
      (stocks) {
        add(DashboardEvent.stocksUpdated(stocks));
      },
      onError: (error) {
        add(DashboardEvent.stocksUpdated(const []));
      },
    );
  }

  /// Handle realtime stock updates
  Future<void> _onStocksUpdated(
    StocksUpdated event,
    Emitter<DashboardState> emit,
  ) async {
    // Calculate total value
    final valueResult = await _getTotalInventoryValue();
    valueResult.fold(
      (failure) => emit(DashboardState.loaded(
        stocks: event.stocks,
        totalValue: 0,
      )),
      (value) => emit(DashboardState.loaded(
        stocks: event.stocks,
        totalValue: value,
      )),
    );
  }

  /// Force refresh: re-subscribe to stream
  Future<void> _onRefresh(Emitter<DashboardState> emit) async {
    await _onLoad(emit);
  }

  @override
  Future<void> close() {
    _stockSubscription?.cancel();
    return super.close();
  }
}
