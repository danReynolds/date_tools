part of date_tools;

extension DateTimeExtensions on DateTime {
  /// Copies the Date to UTC while preserving the original time-of-day and avoiding DST shifts. 1pm PST becomes
  /// 1pm UTC etc. This differs from [toUtc] which does shift the time-of-day to account for DST.
  DateTime asUtc() {
    return DateTime.utc(
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

  /// Copies the Date to the local timezone while preserving the original time-of-day and avoiding DST shifts. 1pm UTC becomes
  /// 1pm PST etc.
  DateTime asLocal() {
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

  /// Adds the given duration in UTC time to prevent DST shifts affecting the result and then shifts the result back to the local timezone.
  DateTime addUnshifted(Duration duration) {
    return asUtc().add(duration).asLocal();
  }

  /// Adds the given duration in UTC time to prevent DST shifts affecting the result and then shifts the result back to the local timezone.
  DateTime subtractUnshifted(Duration duration) {
    return asUtc().subtract(duration).asLocal();
  }

  bool isSameDayAs(DateTime other) {
    return day == other.day && month == other.month && year == other.year;
  }

  bool isSameDayOrBefore(DateTime other) {
    return isBefore(other) || isSameDayAs(other);
  }

  bool isSameDayOrAfter(DateTime other) {
    return isAfter(other) || isSameDayAs(other);
  }
}
