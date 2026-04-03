/// Firestore collection and document path constants
class FirestorePaths {
  FirestorePaths._();

  // Top-level collections
  static const String products = 'products';
  static const String inventory = 'inventory';
  static const String transactions = 'transactions';
  static const String customers = 'customers';
  static const String reconciliations = 'reconciliations';
  static const String dailyChecklists = 'daily_checklists';
  static const String appConfig = 'app_config';

  // Sub-collections
  static const String transactionItems = 'items';
  static const String debtRecords = 'debt_records';
  static const String reconciliationItems = 'items';

  // App config documents
  static const String settingsDoc = 'settings';
  static const String warehouseConfigDoc = 'warehouse_config';
}
