part of date_tools;

extension DateTimeExtensions on DateTime {
  /// Copies the Date to local time without shifting the source Date to account for its timezone. 1pm PST becomes
  /// 1pm EST etc.
  DateTime toLocalUnshifted() {
    return DateTime(
      year,
      month,
      day,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }
}
