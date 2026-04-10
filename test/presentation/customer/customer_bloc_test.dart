import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phao_hoa/core/errors/failures.dart';
import 'package:phao_hoa/core/models/paginated_result.dart';
import 'package:phao_hoa/domain/entities/customer.dart';
import 'package:phao_hoa/domain/entities/debt_record.dart';
import 'package:phao_hoa/domain/usecases/customer/customer_usecases.dart';
import 'package:phao_hoa/presentation/customer/customer_bloc.dart';

class MockGetAllCustomers extends Mock implements GetAllCustomers {}
class MockGetCustomersPaginated extends Mock implements GetCustomersPaginated {}
class MockAddCustomer extends Mock implements AddCustomer {}
class MockUpdateCustomer extends Mock implements UpdateCustomer {}
class MockDeleteCustomer extends Mock implements DeleteCustomer {}
class MockGetCustomerDebts extends Mock implements GetCustomerDebts {}
class MockMakePartialPayment extends Mock implements MakePartialPayment {}
class MockSettleAllDebts extends Mock implements SettleAllDebts {}

void main() {
  late MockGetAllCustomers mockGetAll;
  late MockGetCustomersPaginated mockGetPaginated;
  late MockAddCustomer mockAdd;
  late MockUpdateCustomer mockUpdate;
  late MockDeleteCustomer mockDelete;
  late MockGetCustomerDebts mockGetDebts;
  late MockMakePartialPayment mockPayment;
  late MockSettleAllDebts mockSettle;

  final now = DateTime(2026, 4, 10);

  final tCustomer = Customer(
    id: 'c1',
    name: 'Nguyễn Văn A',
    phone: '0912345678',
    type: 'khach_quen',
    createdAt: now,
    updatedAt: now,
  );

  final tCustomerList = [tCustomer];

  setUp(() {
    mockGetAll = MockGetAllCustomers();
    mockGetPaginated = MockGetCustomersPaginated();
    mockAdd = MockAddCustomer();
    mockUpdate = MockUpdateCustomer();
    mockDelete = MockDeleteCustomer();
    mockGetDebts = MockGetCustomerDebts();
    mockPayment = MockMakePartialPayment();
    mockSettle = MockSettleAllDebts();
  });

  setUpAll(() {
    registerFallbackValue(tCustomer);
  });

  CustomerBloc buildBloc() => CustomerBloc(
        getAllCustomers: mockGetAll,
        getCustomersPaginated: mockGetPaginated,
        addCustomer: mockAdd,
        updateCustomer: mockUpdate,
        deleteCustomer: mockDelete,
        getDebts: mockGetDebts,
        makePayment: mockPayment,
        settleAll: mockSettle,
      );

  group('CustomerBloc', () {
    test('initial state is CustomerState.initial()', () {
      final bloc = buildBloc();
      expect(bloc.state, const CustomerState.initial());
      bloc.close();
    });

    group('loadCustomers (legacy)', () {
      blocTest<CustomerBloc, CustomerState>(
        'emits [loading, customersLoaded] on success',
        build: () {
          when(() => mockGetAll()).thenAnswer((_) async => Right(tCustomerList));
          return buildBloc();
        },
        act: (bloc) => bloc.add(const CustomerEvent.loadCustomers()),
        expect: () => [
          const CustomerState.loading(),
          CustomerState.customersLoaded(tCustomerList),
        ],
      );

      blocTest<CustomerBloc, CustomerState>(
        'emits [loading, error] on failure',
        build: () {
          when(() => mockGetAll())
              .thenAnswer((_) async => const Left(FirestoreFailure('DB error')));
          return buildBloc();
        },
        act: (bloc) => bloc.add(const CustomerEvent.loadCustomers()),
        expect: () => [
          const CustomerState.loading(),
          const CustomerState.error('DB error'),
        ],
      );
    });

    group('loadCustomersPaginated', () {
      blocTest<CustomerBloc, CustomerState>(
        'emits [loading, paginatedLoaded] on success',
        build: () {
          when(() => mockGetPaginated(limit: 20)).thenAnswer(
            (_) async => Right(PaginatedResult(
              items: tCustomerList,
              hasMore: true,
              lastDocument: 'cursor_1',
            )),
          );
          return buildBloc();
        },
        act: (bloc) => bloc.add(const CustomerEvent.loadCustomersPaginated()),
        expect: () => [
          const CustomerState.loading(),
          CustomerState.paginatedLoaded(
            customers: tCustomerList,
            hasMore: true,
            lastDocument: 'cursor_1',
          ),
        ],
      );
    });

    group('addCustomer', () {
      blocTest<CustomerBloc, CustomerState>(
        'emits [loading, actionSuccess] then reloads on success',
        build: () {
          when(() => mockAdd(any())).thenAnswer((_) async => const Right('new_id'));
          when(() => mockGetPaginated(limit: 20)).thenAnswer(
            (_) async => Right(PaginatedResult(
              items: tCustomerList,
              hasMore: false,
            )),
          );
          return buildBloc();
        },
        act: (bloc) => bloc.add(CustomerEvent.addCustomer(tCustomer)),
        expect: () => [
          const CustomerState.loading(),
          const CustomerState.actionSuccess('Đã thêm khách hàng'),
          // Next: loadCustomersPaginated is triggered internally
          const CustomerState.loading(),
          isA<CustomerState>(), // paginatedLoaded
        ],
      );

      blocTest<CustomerBloc, CustomerState>(
        'emits [loading, error] on failure',
        build: () {
          when(() => mockAdd(any()))
              .thenAnswer((_) async => const Left(FirestoreFailure('Error')));
          return buildBloc();
        },
        act: (bloc) => bloc.add(CustomerEvent.addCustomer(tCustomer)),
        expect: () => [
          const CustomerState.loading(),
          const CustomerState.error('Error'),
        ],
      );
    });

    group('deleteCustomer', () {
      blocTest<CustomerBloc, CustomerState>(
        'emits [loading, actionSuccess] then reloads on success',
        build: () {
          when(() => mockDelete('c1')).thenAnswer((_) async => const Right(null));
          when(() => mockGetPaginated(limit: 20)).thenAnswer(
            (_) async => Right(PaginatedResult(items: [], hasMore: false)),
          );
          return buildBloc();
        },
        act: (bloc) => bloc.add(const CustomerEvent.deleteCustomer('c1')),
        expect: () => [
          const CustomerState.loading(),
          const CustomerState.actionSuccess('Đã xóa khách hàng'),
          const CustomerState.loading(),
          isA<CustomerState>(),
        ],
      );
    });

    group('loadDebts', () {
      blocTest<CustomerBloc, CustomerState>(
        'emits [loading, debtsLoaded] on success',
        build: () {
          final tDebts = [
            DebtRecord(id: 'd1', type: 'debt', amount: 500000, runningBalance: 500000, createdAt: now),
          ];
          when(() => mockGetDebts('c1')).thenAnswer((_) async => Right(tDebts));
          return buildBloc();
        },
        act: (bloc) => bloc.add(CustomerEvent.loadDebts(
          customerId: 'c1',
          customer: tCustomer,
        )),
        expect: () => [
          const CustomerState.loading(),
          isA<CustomerState>(), // debtsLoaded
        ],
      );
    });

    group('makePayment', () {
      blocTest<CustomerBloc, CustomerState>(
        'emits [loading, actionSuccess] on success',
        build: () {
          when(() => mockPayment(customerId: 'c1', amount: 200000, note: null))
              .thenAnswer((_) async => const Right(null));
          return buildBloc();
        },
        act: (bloc) => bloc.add(const CustomerEvent.makePayment(
          customerId: 'c1',
          amount: 200000,
        )),
        expect: () => [
          const CustomerState.loading(),
          const CustomerState.actionSuccess('Đã ghi nhận thanh toán'),
        ],
      );
    });

    group('settleAll', () {
      blocTest<CustomerBloc, CustomerState>(
        'emits [loading, actionSuccess] on success',
        build: () {
          when(() => mockSettle('c1')).thenAnswer((_) async => const Right(null));
          return buildBloc();
        },
        act: (bloc) => bloc.add(const CustomerEvent.settleAll('c1')),
        expect: () => [
          const CustomerState.loading(),
          const CustomerState.actionSuccess('Đã tất toán công nợ'),
        ],
      );
    });
  });
}
