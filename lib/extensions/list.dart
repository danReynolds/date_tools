part of date_tools;

extension ListExtensions<T> on List<T> {
  Iterable<T> reversedIf(bool condition) => condition ? reversed : this;
}
