/// Transaction types for inventory operations
enum TransactionType {
  nhap('nhap', 'Nhập kho'),
  xuat('xuat', 'Xuất kho');

  const TransactionType(this.value, this.displayName);

  final String value;
  final String displayName;

  static TransactionType fromValue(String value) {
    return TransactionType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TransactionType.nhap,
    );
  }
}
