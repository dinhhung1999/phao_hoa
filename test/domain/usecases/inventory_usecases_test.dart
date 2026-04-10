import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phao_hoa/core/errors/failures.dart';
import 'package:phao_hoa/domain/entities/warehouse_stock.dart';
import 'package:phao_hoa/domain/entities/inventory_snapshot.dart';
import 'package:phao_hoa/domain/repositories/inventory_repository.dart';
import 'package:phao_hoa/domain/usecases/inventory/inventory_usecases.dart';

class MockInventoryRepository extends Mock implements InventoryRepository {}

void main() {
  late MockInventoryRepository mockRepository;

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

  setUp(() {
    mockRepository = MockInventoryRepository();
  });

  group('GetDashboardSummary', () {
    late GetDashboardSummary usecase;

    setUp(() => usecase = GetDashboardSummary(mockRepository));

    test('should return all stocks on success', () async {
      when(() => mockRepository.getAllStocks())
          .thenAnswer((_) async => Right(tStocks));

      final result = await usecase();

      result.fold(
        (failure) => fail('Should not be Left'),
        (stocks) {
          expect(stocks.length, equals(2));
          expect(stocks[0].productName, equals('Pháo hoa A'));
        },
      );
      verify(() => mockRepository.getAllStocks()).called(1);
    });

    test('should return failure on error', () async {
      when(() => mockRepository.getAllStocks())
          .thenAnswer((_) async => const Left(FirestoreFailure()));

      final result = await usecase();

      expect(result, isA<Left>());
    });
  });

  group('GetStockByLocation', () {
    late GetStockByLocation usecase;

    setUp(() => usecase = GetStockByLocation(mockRepository));

    test('should return stocks filtered by location', () async {
      when(() => mockRepository.getStocksByLocation('kho_1'))
          .thenAnswer((_) async => Right(tStocks));

      final result = await usecase('kho_1');

      expect(result, Right(tStocks));
      verify(() => mockRepository.getStocksByLocation('kho_1')).called(1);
    });
  });

  group('GetTotalInventoryValue', () {
    late GetTotalInventoryValue usecase;

    setUp(() => usecase = GetTotalInventoryValue(mockRepository));

    test('should return total value', () async {
      when(() => mockRepository.getTotalInventoryValue())
          .thenAnswer((_) async => const Right(15000000.0));

      final result = await usecase();

      result.fold(
        (failure) => fail('Should not be Left'),
        (value) => expect(value, equals(15000000.0)),
      );
    });
  });

  group('PerformStockReconciliation', () {
    late PerformStockReconciliation usecase;

    setUp(() => usecase = PerformStockReconciliation(mockRepository));

    test('should perform reconciliation and return snapshot ID', () async {
      final items = [
        const ReconciliationItem(
          productId: 'p1',
          productName: 'Pháo A',
          warehouseLocation: 'kho_1',
          systemQuantity: 100,
          actualQuantity: 98,
          difference: -2,
          isMatched: false,
        ),
      ];

      when(() => mockRepository.performReconciliation(
            userId: 'user@example.com',
            warehouseLocation: 'kho_1',
            items: items,
            shouldAdjust: true,
            notes: 'Kiểm kê tháng 4',
          )).thenAnswer((_) async => const Right('snapshot_id'));

      final result = await usecase(
        userId: 'user@example.com',
        warehouseLocation: 'kho_1',
        items: items,
        shouldAdjust: true,
        notes: 'Kiểm kê tháng 4',
      );

      expect(result, const Right('snapshot_id'));
    });
  });

  group('GetReconciliationHistory', () {
    late GetReconciliationHistory usecase;

    setUp(() => usecase = GetReconciliationHistory(mockRepository));

    test('should return list of inventory snapshots', () async {
      final snapshots = [
        InventorySnapshot(
          id: 's1',
          date: DateTime(2026, 4, 10),
          createdBy: 'user@example.com',
          status: 'completed',
        ),
      ];

      when(() => mockRepository.getReconciliationHistory())
          .thenAnswer((_) async => Right(snapshots));

      final result = await usecase();

      result.fold(
        (failure) => fail('Should not be Left'),
        (history) => expect(history.length, equals(1)),
      );
    });
  });
}
