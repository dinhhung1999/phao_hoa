/// Customer classification types
enum CustomerType {
  khachQuen('khach_quen', 'Khách quen'),
  khachLe('khach_le', 'Khách lẻ');

  const CustomerType(this.value, this.displayName);

  final String value;
  final String displayName;

  static CustomerType fromValue(String value) {
    return CustomerType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => CustomerType.khachLe,
    );
  }
}
