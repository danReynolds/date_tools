extension IterableExtensions<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T item) predicate) {
    try {
      return firstWhere(predicate);
    } on StateError catch (e) {
      if (e.message == 'No element') {
        return null;
      }
      rethrow;
    }
  }
}
