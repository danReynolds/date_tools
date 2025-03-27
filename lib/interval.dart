part of date_tools;

typedef DateIntervalBuilder = DateInterval Function([DateTime? date]);

final _moment = 1.microseconds;

enum _DateIntervals {
  hour,
  day,
  week,
  biweek,
  month,
  year,
}

class DateInterval {
  final DateTime _date;
  final _DateIntervals _interval;
  late final DateTime start;
  late final DateTime end;

  static DateTime Function() currentDate = () {
    return DateTime.now();
  };

  DateInterval._fromDate(this._interval, [DateTime? date])
      : _date = date ?? currentDate() {
    switch (_interval) {
      case _DateIntervals.hour:
        start = DateTime(_date.year, _date.month, _date.day, _date.hour);
        // End dates are calculated using UTC adjustments so that they are unaffected
        // by regional differences like DST and then shifted back to local time.
        end = start
            .copyWith(hour: start.hour + 1, isUtc: true)
            .subtractUnshifted(_moment);
      case _DateIntervals.day:
        start = DateTime(_date.year, _date.month, _date.day);
        end = start
            .copyWith(day: start.day + 1, isUtc: true)
            .subtractUnshifted(_moment);
      case _DateIntervals.week:
        start = DateTime(
          _date.year,
          _date.month,
          _date.day - (_date.weekday - 1),
        );
        end = start.copyWith(day: start.day + 7).subtractUnshifted(_moment);
      case _DateIntervals.biweek:
        start = DateTime(
          _date.year,
          _date.month,
          _date.day - (_date.weekday - 1),
        );
        end = start.copyWith(day: start.day + 14).subtractUnshifted(_moment);
      // Since months and years do not have universal durations,
      // they are adjusted using relative offsets.
      case _DateIntervals.month:
        start = DateTime(_date.year, _date.month);
        end = DateTime.utc(start.year, start.month + 1)
            .subtractUnshifted(_moment);
      case _DateIntervals.year:
        start = DateTime(_date.year);
        end = DateTime.utc(start.year + 1).subtractUnshifted(_moment);
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

  factory DateInterval.biweek([DateTime? relativeDate]) {
    return DateInterval._fromDate(_DateIntervals.biweek, relativeDate);
  }

  factory DateInterval.month([DateTime? relativeDate]) {
    return DateInterval._fromDate(_DateIntervals.month, relativeDate);
  }

  factory DateInterval.year([DateTime? relativeDate]) {
    return DateInterval._fromDate(_DateIntervals.year, relativeDate);
  }

  DateIntervalBuilder get builder {
    switch (_interval) {
      case _DateIntervals.hour:
        return DateInterval.hour;
      case _DateIntervals.day:
        return DateInterval.day;
      case _DateIntervals.week:
        return DateInterval.week;
      case _DateIntervals.biweek:
        return DateInterval.biweek;
      case _DateIntervals.month:
        return DateInterval.month;
      case _DateIntervals.year:
        return DateInterval.year;
    }
  }

  DateInterval previous() {
    return DateInterval._fromDate(_interval, start.subtract(1.microseconds));
  }

  DateInterval next() {
    return DateInterval._fromDate(_interval, end.add(1.microseconds));
  }

  DateInterval subtract(int count) {
    if (count < 0) {
      return add(count * -1);
    }

    if (count > 0) {
      return previous().subtract(count - 1);
    }

    return this;
  }

  DateInterval add(int count) {
    if (count < 0) {
      return subtract(count * -1);
    }

    if (count > 0) {
      return next().add(count - 1);
    }

    return this;
  }

  @override
  toString() {
    return "DateInterval(interval: ${_interval.name}, start: $start, end: $end)";
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

  /// Generates an [Iterable] of [count] [DateInterval] beginning at the current iterable and moving forwards
  /// in time if [count] is positive, or backwards if negative.
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

  /// Returns an [Iterable] of intervals in the range from this interval until the interval that spans [endDate].
  Iterable<DateInterval> range(DateTime endDate) {
    List<DateInterval> intervals = [this];
    DateInterval currentInterval = this;
    DateInterval endInterval = DateInterval._fromDate(_interval, endDate);

    while (currentInterval != endInterval) {
      if (currentInterval.start.isBefore(endInterval.start)) {
        currentInterval = currentInterval.next();
      } else {
        currentInterval = currentInterval.previous();
      }

      intervals.add(currentInterval);
    }

    return intervals;
  }
}
