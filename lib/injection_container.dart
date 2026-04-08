import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

// Data sources
import 'data/datasources/auth_remote_datasource.dart';
import 'data/datasources/product_remote_datasource.dart';
import 'data/datasources/transaction_remote_datasource.dart';
import 'data/datasources/customer_remote_datasource.dart';
import 'data/datasources/inventory_remote_datasource.dart';
import 'data/datasources/checklist_remote_datasource.dart';
import 'data/datasources/warehouse_remote_datasource.dart';

// Repository implementations
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/product_repository_impl.dart';
import 'data/repositories/transaction_repository_impl.dart';
import 'data/repositories/customer_repository_impl.dart';
import 'data/repositories/inventory_repository_impl.dart';
import 'data/repositories/checklist_repository_impl.dart';
import 'data/repositories/warehouse_repository_impl.dart';

// Domain repositories (contracts)
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/product_repository.dart';
import 'domain/repositories/transaction_repository.dart';
import 'domain/repositories/customer_repository.dart';
import 'domain/repositories/inventory_repository.dart';
import 'domain/repositories/checklist_repository.dart';
import 'domain/repositories/warehouse_repository.dart';

// Use cases
import 'domain/usecases/auth/auth_usecases.dart';
import 'domain/usecases/product/product_usecases.dart';
import 'domain/usecases/transaction/transaction_usecases.dart';
import 'domain/usecases/customer/customer_usecases.dart';
import 'domain/usecases/inventory/inventory_usecases.dart';
import 'domain/usecases/checklist/checklist_usecases.dart';
import 'domain/usecases/warehouse/warehouse_usecases.dart';

// BLoCs (feature-based paths)
import 'presentation/auth/auth_bloc.dart';
import 'presentation/dashboard/dashboard_bloc.dart';
import 'presentation/category/category_bloc.dart';
import 'presentation/journal/transaction_bloc.dart';
import 'presentation/customer/customer_bloc.dart';
import 'presentation/checklist/checklist_bloc.dart';
import 'presentation/warehouse/warehouse_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ── External ──
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  // ── Data Sources ──
  sl.registerLazySingleton(() => AuthRemoteDatasource(sl()));
  sl.registerLazySingleton(() => ProductRemoteDatasource(sl()));
  sl.registerLazySingleton(() => TransactionRemoteDatasource(sl()));
  sl.registerLazySingleton(() => CustomerRemoteDatasource(sl()));
  sl.registerLazySingleton(() => InventoryRemoteDatasource(sl()));
  sl.registerLazySingleton(() => ChecklistRemoteDatasource(sl()));
  sl.registerLazySingleton(() => WarehouseRemoteDatasource(sl()));

  // ── Repositories ──
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<CustomerRepository>(
    () => CustomerRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<InventoryRepository>(
    () => InventoryRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<ChecklistRepository>(
    () => ChecklistRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<WarehouseRepository>(
    () => WarehouseRepositoryImpl(sl()),
  );

  // ── Use Cases: Auth ──
  sl.registerLazySingleton(() => SignInWithEmail(sl()));
  sl.registerLazySingleton(() => RegisterWithEmail(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => GetAuthStateChanges(sl()));

  // ── Use Cases: Product ──
  sl.registerLazySingleton(() => GetAllProducts(sl()));
  sl.registerLazySingleton(() => GetProductsPaginated(sl()));
  sl.registerLazySingleton(() => AddProduct(sl()));
  sl.registerLazySingleton(() => UpdateProduct(sl()));
  sl.registerLazySingleton(() => DeleteProduct(sl()));
  sl.registerLazySingleton(() => UpdateProductPrice(sl()));
  sl.registerLazySingleton(() => GetPriceHistory(sl()));
  sl.registerLazySingleton(() => AddInitialPriceRecord(sl()));

  // ── Use Cases: Transaction ──
  sl.registerLazySingleton(() => CreateExportOrder(sl()));
  sl.registerLazySingleton(() => CreateImportOrder(sl()));
  sl.registerLazySingleton(() => GetTransactionHistory(sl()));
  sl.registerLazySingleton(() => GetTransactionHistoryPaginated(sl()));
  sl.registerLazySingleton(() => GetTransactionsByDate(sl()));
  sl.registerLazySingleton(() => UpdateDebtPayment(sl()));

  // ── Use Cases: Customer ──
  sl.registerLazySingleton(() => GetAllCustomers(sl()));
  sl.registerLazySingleton(() => GetCustomersPaginated(sl()));
  sl.registerLazySingleton(() => AddCustomer(sl()));
  sl.registerLazySingleton(() => UpdateCustomer(sl()));
  sl.registerLazySingleton(() => DeleteCustomer(sl()));
  sl.registerLazySingleton(() => GetCustomerDebts(sl()));
  sl.registerLazySingleton(() => MakePartialPayment(sl()));
  sl.registerLazySingleton(() => SettleAllDebts(sl()));

  // ── Use Cases: Inventory ──
  sl.registerLazySingleton(() => GetDashboardSummary(sl()));
  sl.registerLazySingleton(() => GetStockByLocation(sl()));
  sl.registerLazySingleton(() => PerformStockReconciliation(sl()));
  sl.registerLazySingleton(() => GetReconciliationHistory(sl()));
  sl.registerLazySingleton(() => GetTotalInventoryValue(sl()));

  // ── Use Cases: Checklist ──
  sl.registerLazySingleton(() => SubmitDailyChecklist(sl()));
  sl.registerLazySingleton(() => CheckTodayChecklistStatus(sl()));

  // ── Use Cases: Warehouse ──
  sl.registerLazySingleton(() => GetAllWarehouses(sl()));
  sl.registerLazySingleton(() => GetWarehouseById(sl()));
  sl.registerLazySingleton(() => AddWarehouse(sl()));
  sl.registerLazySingleton(() => UpdateWarehouse(sl()));
  sl.registerLazySingleton(() => DeleteWarehouse(sl()));
  sl.registerLazySingleton(() => WatchAllWarehouses(sl()));
  sl.registerLazySingleton(() => GetChecklistHistory(sl()));

  // ── BLoCs ──
  sl.registerFactory(() => AuthBloc(
    signInWithEmail: sl(),
    registerWithEmail: sl(),
    signOut: sl(),
    getAuthStateChanges: sl(),
  ));

  sl.registerFactory(() => DashboardBloc(
    getDashboardSummary: sl(),
    getTotalInventoryValue: sl(),
  ));

  sl.registerFactory(() => CategoryBloc(
    getAllProducts: sl(),
    getProductsPaginated: sl(),
    addProduct: sl(),
    updateProduct: sl(),
    deleteProduct: sl(),
    updateProductPrice: sl(),
    getPriceHistory: sl(),
    addInitialPriceRecord: sl(),
  ));

  sl.registerFactory(() => TransactionBloc(
    getHistory: sl(),
    getHistoryPaginated: sl(),
    createExport: sl(),
    createImport: sl(),
    updateDebtPayment: sl(),
  ));

  sl.registerFactory(() => CustomerBloc(
    getAllCustomers: sl(),
    getCustomersPaginated: sl(),
    addCustomer: sl(),
    updateCustomer: sl(),
    deleteCustomer: sl(),
    getDebts: sl(),
    makePayment: sl(),
    settleAll: sl(),
  ));

  sl.registerFactory(() => ChecklistBloc(
    checkStatus: sl(),
    submitChecklist: sl(),
  ));

  sl.registerFactory(() => WarehouseBloc(
    getAllWarehouses: sl(),
    addWarehouse: sl(),
    updateWarehouse: sl(),
    deleteWarehouse: sl(),
  ));
}
