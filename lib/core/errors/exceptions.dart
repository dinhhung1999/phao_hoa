/// Base exception for data layer
class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Server error occurred']);
}

/// Firestore operation exception
class FirestoreException implements Exception {
  final String message;
  const FirestoreException([this.message = 'Firestore error occurred']);
}

/// Data not found exception
class NotFoundException implements Exception {
  final String message;
  const NotFoundException([this.message = 'Requested data not found']);
}
