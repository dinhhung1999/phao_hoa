part of 'dashboard_bloc.dart';

@freezed
sealed class DashboardEvent with _$DashboardEvent {
  const factory DashboardEvent.loadDashboard() = _LoadDashboard;
  const factory DashboardEvent.refreshDashboard() = _RefreshDashboard;
}
