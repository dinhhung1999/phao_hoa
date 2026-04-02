/// Input validation utilities
class Validators {
  Validators._();

  /// Validate product name is not empty
  static String? validateProductName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập tên sản phẩm';
    }
    return null;
  }

  /// Validate price is positive number
  static String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập giá';
    }
    final price = num.tryParse(value.replaceAll(RegExp(r'[^\d]'), ''));
    if (price == null || price <= 0) {
      return 'Giá phải là số dương';
    }
    return null;
  }

  /// Validate quantity is positive integer
  static String? validateQuantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập số lượng';
    }
    final qty = int.tryParse(value);
    if (qty == null || qty <= 0) {
      return 'Số lượng phải là số nguyên dương';
    }
    return null;
  }

  /// Validate customer name
  static String? validateCustomerName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập tên khách hàng';
    }
    return null;
  }

  /// Validate phone number (Vietnamese format)
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Phone is optional
    }
    final phone = value.replaceAll(RegExp(r'[\s\-]'), '');
    if (!RegExp(r'^(0|\+84)\d{9,10}$').hasMatch(phone)) {
      return 'Số điện thoại không hợp lệ';
    }
    return null;
  }

  /// Validate email
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập email';
    }
    if (!RegExp(r'^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  /// Validate password (minimum 6 characters)
  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }
    return null;
  }
}
