import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phao_hoa/core/errors/failures.dart';
import 'package:phao_hoa/core/models/paginated_result.dart';
import 'package:phao_hoa/domain/entities/customer.dart';
import 'package:phao_hoa/domain/entities/debt_record.dart';
import 'package:phao_hoa/domain/repositories/customer_repository.dart';
import 'package:phao_hoa/domain/usecases/customer/customer_usecases.dart';

class MockCustomerRepository extends Mock implements CustomerRepository {}

void main() {
  late MockCustomerRepository mockRepository;
  final now = DateTime(2026, 4, 10);

  final tCustomer = Customer(
    id: 'c1',
    name: 'Nguyễn Văn A',
    phone: '0912345678',
    type: 'khach_quen',
    createdAt: now,
    updatedAt: now,
  );

  final tCustomerList = [
    tCustomer,
    Customer(id: 'c2', name: 'Trần Thị B', type: 'khach_le', createdAt: now, updatedAt: now),
  ];

  final tDebtRecords = [
    DebtRecord(id: 'd1', type: 'debt', amount: 500000, runningBalance: 500000, createdAt: now),
    DebtRecord(id: 'd2', type: 'payment', amount: 200000, runningBalance: 300000, createdAt: now),
  ];

  setUp(() {
    mockRepository = MockCustomerRepository();
  });

  group('GetAllCustomers', () {
    late GetAllCustomers usecase;

    setUp(() => usecase = GetAllCustomers(mockRepository));

    test('should return list of customers on success', () async {
      when(() => mockRepository.getAllCustomers())
          .thenAnswer((_) async => Right(tCustomerList));

      final result = await usecase();

      expect(result, Right(tCustomerList));
      verify(() => mockRepository.getAllCustomers()).called(1);
    });

    test('should return failure on error', () async {
      when(() => mockRepository.getAllCustomers())
          .thenAnswer((_) async => const Left(FirestoreFailure()));

      final result = await usecase();

      expect(result, isA<Left>());
      verify(() => mockRepository.getAllCustomers()).called(1);
    });
  });

  group('AddCustomer', () {
    late AddCustomer usecase;

    setUp(() => usecase = AddCustomer(mockRepository));

    test('should return new customer ID on success', () async {
      when(() => mockRepository.addCustomer(tCustomer))
          .thenAnswer((_) async => const Right('new_id'));

      final result = await usecase(tCustomer);

      expect(result, const Right('new_id'));
      verify(() => mockRepository.addCustomer(tCustomer)).called(1);
    });

    test('should return failure on error', () async {
      when(() => mockRepository.addCustomer(tCustomer))
          .thenAnswer((_) async => const Left(FirestoreFailure()));

      final result = await usecase(tCustomer);

      expect(result, isA<Left>());
    });
  });

  group('UpdateCustomer', () {
    late UpdateCustomer usecase;

    setUp(() => usecase = UpdateCustomer(mockRepository));

    test('should return void on success', () async {
      when(() => mockRepository.updateCustomer(tCustomer))
          .thenAnswer((_) async => const Right(null));

      final result = await usecase(tCustomer);

      expect(result, const Right(null));
      verify(() => mockRepository.updateCustomer(tCustomer)).called(1);
    });
  });

  group('DeleteCustomer', () {
    late DeleteCustomer usecase;

    setUp(() => usecase = DeleteCustomer(mockRepository));

    test('should call repository deleteCustomer', () async {
      when(() => mockRepository.deleteCustomer('c1'))
          .thenAnswer((_) async => const Right(null));

      final result = await usecase('c1');

      expect(result, const Right(null));
      verify(() => mockRepository.deleteCustomer('c1')).called(1);
    });
  });

  group('GetCustomerDebts', () {
    late GetCustomerDebts usecase;

    setUp(() => usecase = GetCustomerDebts(mockRepository));

    test('should return list of debt records', () async {
      when(() => mockRepository.getCustomerDebts('c1'))
          .thenAnswer((_) async => Right(tDebtRecords));

      final result = await usecase('c1');

      expect(result, Right(tDebtRecords));
      verify(() => mockRepository.getCustomerDebts('c1')).called(1);
    });
  });

  group('MakePartialPayment', () {
    late MakePartialPayment usecase;

    setUp(() => usecase = MakePartialPayment(mockRepository));

    test('should call repository with correct params', () async {
      when(() => mockRepository.makePartialPayment(
            customerId: 'c1',
            amount: 200000,
            note: 'Thanh toán đợt 1',
          )).thenAnswer((_) async => const Right(null));

      final result = await usecase(
        customerId: 'c1',
        amount: 200000,
        note: 'Thanh toán đợt 1',
      );

      expect(result, const Right(null));
      verify(() => mockRepository.makePartialPayment(
            customerId: 'c1',
            amount: 200000,
            note: 'Thanh toán đợt 1',
          )).called(1);
    });
  });

  group('SettleAllDebts', () {
    late SettleAllDebts usecase;

    setUp(() => usecase = SettleAllDebts(mockRepository));

    test('should call repository settleAllDebts', () async {
      when(() => mockRepository.settleAllDebts('c1'))
          .thenAnswer((_) async => const Right(null));

      final result = await usecase('c1');

      expect(result, const Right(null));
      verify(() => mockRepository.settleAllDebts('c1')).called(1);
    });
  });

  group('GetCustomersPaginated', () {
    late GetCustomersPaginated usecase;

    setUp(() => usecase = GetCustomersPaginated(mockRepository));

    test('should return paginated result', () async {
      final paginatedResult = PaginatedResult<Customer>(
        items: tCustomerList,
        hasMore: true,
        lastDocument: 'cursor_1',
      );

      when(() => mockRepository.getCustomersPaginated(limit: 20))
          .thenAnswer((_) async => Right(paginatedResult));

      final result = await usecase(limit: 20);

      result.fold(
        (failure) => fail('Should not be Left'),
        (paginated) {
          expect(paginated.items.length, equals(2));
          expect(paginated.hasMore, isTrue);
        },
      );
    });

    test('should pass startAfter for pagination', () async {
      final paginatedResult = PaginatedResult<Customer>(
        items: [tCustomer],
        hasMore: false,
      );

      when(() => mockRepository.getCustomersPaginated(
            limit: 20,
            startAfter: 'cursor_1',
          )).thenAnswer((_) async => Right(paginatedResult));

      final result = await usecase(limit: 20, startAfter: 'cursor_1');

      result.fold(
        (failure) => fail('Should not be Left'),
        (paginated) {
          expect(paginated.items.length, equals(1));
          expect(paginated.hasMore, isFalse);
        },
      );
    });
  });
}
