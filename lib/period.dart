library date_period;

import 'package:date_period/extensions/iterable.dart';
import 'package:date_period/extensions/num.dart';

enum DateInterval {
  hour,
  day,
  week,
  month,
  year;

  DateTime startOf([DateTime? date]) {
    date ??= DateTime.timestamp();

    switch (this) {
      case hour:
        return DateTime.utc(date.year, date.month, date.day, date.hour);
      case day:
        return DateTime.utc(date.year, date.month, date.day);
      case week:
        return DateTime.utc(
            date.year, date.month, date.day - (date.weekday - 1));
      case month:
        return DateTime.utc(date.year, date.month);
      case year:
        return DateTime.utc(date.year);
    }
  }

  DateTime endOf([DateTime? date]) {
    date ??= DateTime.timestamp();
    final startDate = startOf(date);

    switch (this) {
      case hour:
        return startDate.add(1.hours).subtract(1.milliseconds);
      case day:
        return startDate.add(1.days).subtract(1.milliseconds);
      case week:
        return startDate.add(7.days).subtract(1.milliseconds);
      // Since months and years do not have universal durations,
      // they are adjusted using relative offsets.
      case month:
        return DateTime.utc(date.year, date.month + 1).subtract(1.milliseconds);
      case year:
        return DateTime.utc(date.year + 1).subtract(1.milliseconds);
    }
  }

  DateTime startOfPrevious([DateTime? date]) {
    date ??= DateTime.timestamp();
    return startOf(endOfPrevious(date));
  }

  DateTime endOfPrevious([DateTime? date]) {
    date ??= DateTime.timestamp();
    return startOf(date).subtract(1.milliseconds);
  }

  DateTime startOfNext([DateTime? date]) {
    date ??= DateTime.timestamp();
    return endOf(date).add(1.milliseconds);
  }

  DateTime endOfNext([DateTime? date]) {
    date ??= DateTime.timestamp();
    return endOf(startOfNext(date));
  }

  /// The step of the date in the given interval. For example, the date [2022-04-20]
  /// would be step 4 of a yearly interval, step 20 of a monthly interval and step 3 of a weekly
  /// interval, since it falls on a Wednesday.
  int getStep(DateTime date) {
    switch (this) {
      case hour:
        return date.minute;
      case day:
        return date.hour;
      case week:
        return date.weekday;
      case month:
        return date.day;
      case year:
        return date.month;
    }
  }

  /// The total number of steps in the interval.
  /// For example, a [DateInterval.year] has 12 steps, a [DateInterval.week] 7.
  int stepCount() {
    return getStep(endOf());
  }

  /// Offsets the step for the given date by [steps] steps. As an example,
  /// for a date of Wednesday in a [DateInterval.week] interval, adding 2 steps would resolve to Friday.
  DateTime addSteps(DateTime date, int steps) {
    switch (this) {
      case hour:
        return date.add(steps.minutes);
      case day:
        return date.add(steps.hours);
      case week:
      case month:
        return DateTime.utc(
          date.year,
          date.month,
          date.day + steps,
        );
      case year:
        return DateTime.utc(date.year, date.month + steps);
    }
  }

  DateTime subtractSteps(DateTime date, int steps) {
    return addSteps(date, -steps);
  }

  /// Calculates the number of steps between two dates for the interval.
  int stepDifference(DateTime date1, DateTime date2) {
    if (startOf(date1) == startOf(date2)) {
      return getStep(date2) - getStep(date1);
    }

    final count = stepCount();

    int total = 0;
    DateTime date = date1;

    if (date.isBefore(date2)) {
      total = count - getStep(date);
      date = startOfNext(date);

      while (startOf(date) != startOf(date2)) {
        total += count;
        date = startOfNext(date);
      }

      total += getStep(date2) - getStep(date);
    } else if (date.isAfter(date2)) {
      total = -getStep(date);
      date = endOfPrevious(date);

      while (startOf(date) != startOf(date2)) {
        total -= count;
        date = endOfPrevious(date);
      }
    }

    return total;
  }

  String get displayName {
    switch (this) {
      case hour:
        return 'hourly';
      case day:
        return 'daily';
      case week:
        return 'weekly';
      case month:
        return 'monthly';
      case year:
        return 'yearly';
    }
  }
}

enum DatePeriod {
  today,
  thisWeek,
  thisMonth,
  thisYear,
  yesterday,
  lastWeek,
  lastMonth,
  lastYear;

  static DatePeriod fromString(String? name) {
    return values.firstWhere((period) => period.name == name);
  }

  static DatePeriod? fromDateRange({
    required DateTime? startDate,
    required DateTime? endDate,
  }) {
    return values.firstWhereOrNull(
      (period) => period.startOf == startDate && period.endOf == endDate,
    );
  }

  String get displayName {
    switch (this) {
      case DatePeriod.today:
        return 'today';
      case DatePeriod.thisWeek:
        return 'this week';
      case DatePeriod.thisMonth:
        return 'this month';
      case DatePeriod.thisYear:
        return 'this year';
      case DatePeriod.yesterday:
        return 'yesterday';
      case DatePeriod.lastWeek:
        return 'last week';
      case DatePeriod.lastMonth:
        return 'last month';
      case DatePeriod.lastYear:
        return 'last year';
    }
  }

  DateInterval get interval {
    switch (this) {
      case DatePeriod.today:
      case DatePeriod.yesterday:
        return DateInterval.day;
      case DatePeriod.thisWeek:
      case DatePeriod.lastWeek:
        return DateInterval.week;
      case DatePeriod.thisMonth:
      case DatePeriod.lastMonth:
        return DateInterval.month;
      case DatePeriod.thisYear:
      case DatePeriod.lastYear:
        return DateInterval.year;
    }
  }

  DateTime get startOf {
    switch (this) {
      case DatePeriod.yesterday:
        return DatePeriod.today.startOfPrevious;
      case DatePeriod.lastWeek:
        return DatePeriod.thisWeek.startOfPrevious;
      case DatePeriod.lastMonth:
        return DatePeriod.thisMonth.startOfPrevious;
      case DatePeriod.lastYear:
        return DatePeriod.thisYear.startOfPrevious;
      default:
        return interval.startOf();
    }
  }

  DateTime get endOf {
    switch (this) {
      case DatePeriod.yesterday:
        return DatePeriod.today.endOfPrevious;
      case DatePeriod.lastWeek:
        return DatePeriod.thisWeek.endOfPrevious;
      case DatePeriod.lastMonth:
        return DatePeriod.thisMonth.endOfPrevious;
      case DatePeriod.lastYear:
        return DatePeriod.thisYear.endOfPrevious;
      default:
        return interval.endOf(startOf);
    }
  }

  DateTime get startOfPrevious {
    return interval.startOfPrevious(startOf);
  }

  DateTime get endOfPrevious {
    return interval.endOf(startOfPrevious);
  }
}
