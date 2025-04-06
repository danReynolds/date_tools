extension ListExtensions<T extends Comparable> on List<T> {
  List<T> skipWhileLessThan(T value) {
    int low = 0;
    int high = length - 1;

    while (low <= high) {
      int mid = low + (high - low) ~/ 2;

      if (this[mid].compareTo(value) < 0) {
        low = mid + 1;
      } else {
        high = mid - 1;
      }
    }

    return sublist(low);
  }

  List<T> skipWhileGreaterThan(T value) {
    int low = 0;
    int high = length - 1;

    while (low <= high) {
      int mid = low + (high - low) ~/ 2;

      if (this[mid].compareTo(value) > 0) {
        low = mid + 1;
      } else {
        high = mid - 1;
      }
    }

    return sublist(low);
  }

  List<T> get distinct {
    final Set<T> items = {};
    return where(items.add).toList();
  }
}
