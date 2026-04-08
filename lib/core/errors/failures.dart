import 'package:equatable/equatable.dart';

/// Base failure class for domain layer error handling
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Server/network related failures
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Lỗi máy chủ. Vui lòng thử lại.']);
}

/// Firestore operation failures
class FirestoreFailure extends Failure {
  const FirestoreFailure([
    super.message = 'Lỗi cơ sở dữ liệu. Vui lòng thử lại.',
  ]);
}

/// Validation failures (business logic violations)
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Insufficient stock failure
class InsufficientStockFailure extends Failure {
  final int availableQuantity;

  const InsufficientStockFailure({
    required this.availableQuantity,
    String message = 'Không đủ hàng trong kho.',
  }) : super(message);

  @override
  List<Object> get props => [message, availableQuantity];
}


