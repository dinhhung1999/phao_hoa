import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phao_hoa/core/errors/failures.dart';
import 'package:phao_hoa/domain/entities/warehouse.dart';
import 'package:phao_hoa/domain/usecases/warehouse/warehouse_usecases.dart';
import 'package:phao_hoa/presentation/warehouse/warehouse_bloc.dart';

class MockGetAllWarehouses extends Mock implements GetAllWarehouses {}
class MockAddWarehouse extends Mock implements AddWarehouse {}
class MockUpdateWarehouse extends Mock implements UpdateWarehouse {}
class MockDeleteWarehouse extends Mock implements DeleteWarehouse {}

void main() {
  late MockGetAllWarehouses mockGetAll;
  late MockAddWarehouse mockAdd;
  late MockUpdateWarehouse mockUpdate;
  late MockDeleteWarehouse mockDelete;

  final now = DateTime(2026, 4, 10);

  final tWarehouse = Warehouse(
    id: 'kho_1',
    name: 'Kho chính',
    address: '123 Nguyễn Huệ',
    area: 200,
    capacity: 500,
    createdAt: now,
    updatedAt: now,
  );

  final tWarehouseList = [
    tWarehouse,
    Warehouse(
      id: 'kho_2',
      name: 'Kho phụ',
      createdAt: now,
      updatedAt: now,
    ),
  ];

  setUp(() {
    mockGetAll = MockGetAllWarehouses();
    mockAdd = MockAddWarehouse();
    mockUpdate = MockUpdateWarehouse();
    mockDelete = MockDeleteWarehouse();
  });

  setUpAll(() {
    registerFallbackValue(tWarehouse);
  });

  WarehouseBloc buildBloc() => WarehouseBloc(
        getAllWarehouses: mockGetAll,
        addWarehouse: mockAdd,
        updateWarehouse: mockUpdate,
        deleteWarehouse: mockDelete,
      );

  group('WarehouseBloc', () {
    test('initial state is WarehouseState.initial()', () {
      final bloc = buildBloc();
      expect(bloc.state, const WarehouseState.initial());
      bloc.close();
    });

    group('loadWarehouses', () {
      blocTest<WarehouseBloc, WarehouseState>(
        'emits [loading, loaded] on success',
        build: () {
          when(() => mockGetAll()).thenAnswer((_) async => Right(tWarehouseList));
          return buildBloc();
        },
        act: (bloc) => bloc.add(const WarehouseEvent.loadWarehouses()),
        expect: () => [
          const WarehouseState.loading(),
          WarehouseState.loaded(tWarehouseList),
        ],
      );

      blocTest<WarehouseBloc, WarehouseState>(
        'emits [loading, error] on failure',
        build: () {
          when(() => mockGetAll())
              .thenAnswer((_) async => const Left(FirestoreFailure('DB Error')));
          return buildBloc();
        },
        act: (bloc) => bloc.add(const WarehouseEvent.loadWarehouses()),
        expect: () => [
          const WarehouseState.loading(),
          const WarehouseState.error('DB Error'),
        ],
      );
    });

    group('deleteWarehouse', () {
      blocTest<WarehouseBloc, WarehouseState>(
        'emits [loading, error] on failure',
        build: () {
          when(() => mockDelete('kho_1'))
              .thenAnswer((_) async => const Left(FirestoreFailure('Cannot delete')));
          return buildBloc();
        },
        act: (bloc) => bloc.add(const WarehouseEvent.deleteWarehouse('kho_1')),
        expect: () => [
          const WarehouseState.loading(),
          const WarehouseState.error('Cannot delete'),
        ],
      );
    });
  });
}
