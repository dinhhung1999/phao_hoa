/// Represents a paginated result from Firestore cursor-based pagination.
/// [T] is the type of items in the result.
class PaginatedResult<T> {
  final List<T> items;
  
  /// Opaque cursor for the last document - used by Firestore to fetch next page.
  /// Typed as dynamic to keep domain layer independent of Firestore SDK.
  final dynamic lastDocument;
  
  /// Whether there are more items to load
  final bool hasMore;

  const PaginatedResult({
    required this.items,
    this.lastDocument,
    required this.hasMore,
  });
}
