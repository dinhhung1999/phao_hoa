import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phao_hoa/core/errors/failures.dart';
import 'package:phao_hoa/domain/entities/warehouse_stock.dart';
import 'package:phao_hoa/domain/usecases/inventory/inventory_usecases.dart';
import 'package:phao_hoa/presentation/dashboard/dashboard_bloc.dart';

class MockGetDashboardSummary extends Mock implements GetDashboardSummary {}
class MockGetTotalInventoryValue extends Mock implements GetTotalInventoryValue {}

void main() {
  late MockGetDashboardSummary mockGetSummary;
  late MockGetTotalInventoryValue mockGetValue;

  final tStocks = [
    const WarehouseStock(
      productId: 'p1',
      productName: 'Pháo hoa A',
      totalQuantity: 100,
      stockByLocation: {'kho_1': 60, 'kho_2': 40},
    ),
    const WarehouseStock(
      productId: 'p2',
      productName: 'Pháo hoa B',
      totalQuantity: 50,
      stockByLocation: {'kho_1': 50},
    ),
  ];

  const tTotalValue = 15000000.0;

  setUp(() {
    mockGetSummary = MockGetDashboardSummary();
    mockGetValue = MockGetTotalInventoryValue();
  });

  DashboardBloc buildBloc() => DashboardBloc(
        getDashboardSummary: mockGetSummary,
        getTotalInventoryValue: mockGetValue,
      );

  group('DashboardBloc', () {
    test('initial state is DashboardState.initial()', () {
      final bloc = buildBloc();
      expect(bloc.state, const DashboardState.initial());
      bloc.close();
    });

    group('loadDashboard', () {
      blocTest<DashboardBloc, DashboardState>(
        'emits [loading, loaded] on success',
        build: () {
          when(() => mockGetSummary()).thenAnswer((_) async => Right(tStocks));
          when(() => mockGetValue())
              .thenAnswer((_) async => const Right(tTotalValue));
          return buildBloc();
        },
        act: (bloc) => bloc.add(const DashboardEvent.loadDashboard()),
        expect: () => [
          const DashboardState.loading(),
          DashboardState.loaded(stocks: tStocks, totalValue: tTotalValue),
        ],
      );

      blocTest<DashboardBloc, DashboardState>(
        'emits [loading, error] when stock fetch fails',
        build: () {
          when(() => mockGetSummary())
              .thenAnswer((_) async => const Left(FirestoreFailure('Stock error')));
          when(() => mockGetValue())
              .thenAnswer((_) async => const Right(0.0));
          return buildBloc();
        },
        act: (bloc) => bloc.add(const DashboardEvent.loadDashboard()),
        expect: () => [
          const DashboardState.loading(),
          const DashboardState.error('Stock error'),
        ],
      );

      blocTest<DashboardBloc, DashboardState>(
        'emits [loading, error] when value fetch fails',
        build: () {
          when(() => mockGetSummary()).thenAnswer((_) async => Right(tStocks));
          when(() => mockGetValue())
              .thenAnswer((_) async => const Left(FirestoreFailure('Value error')));
          return buildBloc();
        },
        act: (bloc) => bloc.add(const DashboardEvent.loadDashboard()),
        expect: () => [
          const DashboardState.loading(),
          const DashboardState.error('Value error'),
        ],
      );
    });

    group('refreshDashboard', () {
      blocTest<DashboardBloc, DashboardState>(
        'emits [loading, loaded] same as loadDashboard',
        build: () {
          when(() => mockGetSummary()).thenAnswer((_) async => Right(tStocks));
          when(() => mockGetValue())
              .thenAnswer((_) async => const Right(tTotalValue));
          return buildBloc();
        },
        act: (bloc) => bloc.add(const DashboardEvent.refreshDashboard()),
        expect: () => [
          const DashboardState.loading(),
          DashboardState.loaded(stocks: tStocks, totalValue: tTotalValue),
        ],
      );
    });
  });
}
