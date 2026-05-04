part of 'dashboard_bloc.dart';

@freezed
sealed class DashboardEvent with _$DashboardEvent {
  const factory DashboardEvent.loadDashboard() = _LoadDashboard;
  const factory DashboardEvent.refreshDashboard() = _RefreshDashboard;
  /// Internal: emitted by realtime stock stream — not for external use
  const factory DashboardEvent.stocksUpdated(List<WarehouseStock> stocks) = StocksUpdated;
}
