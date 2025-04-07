part of date_tools;

extension IterableExtensions<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T item) predicate) {
    final result = where(predicate).take(1);
    if (result.isEmpty) {
      return null;
    }
    return result.first;
  }
}
