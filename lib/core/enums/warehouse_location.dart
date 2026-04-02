/// Physical warehouse locations
enum WarehouseLocation {
  kho1('kho_1', 'Kho 1'),
  kho2('kho_2', 'Kho 2'),
  kho3('kho_3', 'Kho 3');

  const WarehouseLocation(this.value, this.displayName);

  final String value;
  final String displayName;

  static WarehouseLocation fromValue(String value) {
    return WarehouseLocation.values.firstWhere(
      (e) => e.value == value,
      orElse: () => WarehouseLocation.kho1,
    );
  }
}
