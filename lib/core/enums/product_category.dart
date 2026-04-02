/// Product categories for fireworks inventory
enum ProductCategory {
  vien('viên', 'Viên'),
  nhay('nháy', 'Nháy'),
  vien36('viên 36', 'Viên 36'),
  gian25('giàn 25', 'Giàn 25'),
  gian50('giàn 50', 'Giàn 50'),
  gian75('giàn 75', 'Giàn 75'),
  gian100('giàn 100', 'Giàn 100'),
  gian150('giàn 150', 'Giàn 150'),
  gian225('giàn 225', 'Giàn 225'),
  khac('khác', 'Khác');

  const ProductCategory(this.value, this.displayName);

  final String value;
  final String displayName;

  static ProductCategory fromValue(String value) {
    return ProductCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ProductCategory.khac,
    );
  }
}
