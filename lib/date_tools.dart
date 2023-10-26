part of date_tools;

final _moment = 1.microseconds;

enum _DateIntervals {
  hour,
  day,
  week,
  month,
  year,
}

class DateInterval {
  final DateTime _date;
  final _DateIntervals _interval;
  late final DateTime start;
  late final DateTime end;

  static DateTime Function() now = () {
    return DateTime.timestamp();
  };

  DateInterval._fromDate(this._interval, [DateTime? date])
      : _date = date ?? now() {
    switch (_interval) {
      case _DateIntervals.hour:
        start = DateTime.utc(_date.year, _date.month, _date.day, _date.hour);
        end = start.add(1.hours).subtract(_moment);
      case _DateIntervals.day:
        start = DateTime.utc(_date.year, _date.month, _date.day);
        end = start.add(1.days).subtract(_moment);
      case _DateIntervals.week:
        start = DateTime.utc(
          _date.year,
          _date.month,
          _date.day - (_date.weekday - 1),
        );
        end = start.add(7.days).subtract(_moment);
      // Since months and years do not have universal durations,
      // they are adjusted using relative offsets.
      case _DateIntervals.month:
        start = DateTime.utc(_date.year, _date.month);
        end = DateTime.utc(_date.year, _date.month + 1).subtract(_moment);
      case _DateIntervals.year:
        start = DateTime.utc(_date.year);
        end = DateTime.utc(_date.year + 1).subtract(_moment);
    }
  }

  factory DateInterval.hour([DateTime? relativeDate]) {
    return DateInterval._fromDate(_DateIntervals.hour, relativeDate);
  }

  factory DateInterval.day([DateTime? relativeDate]) {
    return DateInterval._fromDate(_DateIntervals.day, relativeDate);
  }

  factory DateInterval.week([DateTime? relativeDate]) {
    return DateInterval._fromDate(_DateIntervals.week, relativeDate);
  }

  factory DateInterval.month([DateTime? relativeDate]) {
    return DateInterval._fromDate(_DateIntervals.month, relativeDate);
  }

  factory DateInterval.year([DateTime? relativeDate]) {
    return DateInterval._fromDate(_DateIntervals.year, relativeDate);
  }

  DateInterval previous() {
    return DateInterval._fromDate(_interval, start.subtract(1.microseconds));
  }

  DateInterval next() {
    return DateInterval._fromDate(_interval, end.add(1.microseconds));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is DateInterval && start == other.start && end == other.end;
  }

  @override
  int get hashCode => Object.hash(_interval.name, start, end);

  bool spans(DateTime date) {
    return date == start ||
        date == end ||
        (date.isAfter(start) && date.isBefore(end));
  }

  Iterable<DateInterval> generate(int count) sync* {
    DateInterval current = this;

    if (count > 0) {
      for (int i = 0; i < count; i++) {
        yield current;
        current = current.next();
      }
    }

    if (count < 0) {
      for (int i = 0; i > count; i--) {
        yield current;
        current = current.previous();
      }
    }
  }
}
