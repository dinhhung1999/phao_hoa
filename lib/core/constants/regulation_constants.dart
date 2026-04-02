/// Regulation classification according to Nghị định 137/2020/NĐ-CP
class RegulationConstants {
  RegulationConstants._();

  /// Class A: Pháo hoa nổ - CẤM xuất cho cá nhân
  static const String classA = 'A';

  /// Class B: Pháo hoa không nổ - Được phép kinh doanh có điều kiện
  static const String classB = 'B';

  /// Class C: Sản phẩm phụ trợ - Tự do giao dịch
  static const String classC = 'C';

  static const Map<String, String> classDescriptions = {
    classA: 'Pháo hoa nổ - CẤM xuất cho cá nhân',
    classB: 'Pháo hoa không nổ - Kinh doanh có điều kiện',
    classC: 'Sản phẩm phụ trợ - Tự do giao dịch',
  };

  /// Check if a product class is allowed for individual export
  static bool isAllowedForIndividualExport(String regulationClass) {
    return regulationClass != classA;
  }
}
