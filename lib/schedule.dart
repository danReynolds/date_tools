part of date_tools;

enum DateSchedulePeriods {
  yearly,
  monthly,
  weekly,
  daily;

  static DateSchedulePeriods fromString(String periodStr) {
    return values.firstWhere((period) => period.name == periodStr);
  }
}

abstract class DateSchedule {
  final DateSchedulePeriods period;
  final int interval;

  DateSchedule({
    required this.period,
    int? interval,
  }) : interval = interval ?? 1;

  static YearlyDateSchedule yearly({
    DateTime? startDate,
    required List<int> months,
    required List<int> days,
    int? interval,
  }) {
    return YearlyDateSchedule(interval: interval, months: months, days: days);
  }

  static MonthlyDateSchedule monthly({
    List<int>? days,
    List<int>? weekdays,
    List<int>? nthWeekdays,
    int? interval,
  }) {
    return MonthlyDateSchedule(
      interval: interval,
      days: days,
      weekdays: weekdays,
      nthWeekdays: nthWeekdays,
    );
  }

  static WeeklyDateSchedule weekly({
    required List<int> weekdays,
    int? interval,
  }) {
    return WeeklyDateSchedule(interval: interval, weekdays: weekdays);
  }

  static DailyDateSchedule daily({
    int? interval,
  }) {
    return DailyDateSchedule(interval: interval);
  }

  Iterable<DateTime> _prev(DateTime relativeDate);
  Iterable<DateTime> _next(DateTime relativeDate);

  Iterable<DateTime> range({
    required DateTime start,
    required DateTime end,
    bool ascending = true,
  }) {
    if (ascending) {
      return _next(start).takeWhile((date) => date.isSameDayOrBefore(end));
    }
    return _prev(end).takeWhile((date) => date.isSameDayOrAfter(start));
  }

  Iterable<DateTime> start(
    DateTime startDate, {
    bool ascending = true,
  }) {
    if (ascending) {
      return _next(startDate);
    }
    return _prev(startDate);
  }
}

class YearlyDateSchedule extends DateSchedule {
  final List<int> months;
  final List<int> days;

  YearlyDateSchedule({
    super.interval,
    required this.months,
    required this.days,
  }) : super(period: DateSchedulePeriods.yearly);

  @override
  _prev(relativeDate) sync* {
    var currentYear = DateInterval.year(relativeDate);

    while (true) {
      final startOfYear = currentYear.start;

      for (var month in months.reversed) {
        for (var day in days.reversed) {
          final date = day == -1
              ? DateTime(startOfYear.year, month + 1, 0)
              : DateTime(startOfYear.year, month, day);

          if (date.isSameDayOrBefore(relativeDate)) {
            yield date;
          }
        }
      }

      currentYear = currentYear.subtract(interval);
    }
  }

  @override
  _next(relativeDate) sync* {
    var currentYear = DateInterval.year(relativeDate);

    while (true) {
      final startOfYear = currentYear.start;

      for (var month in months) {
        for (var day in days) {
          final date = day == -1
              ? DateTime(startOfYear.year, month + 1, 0)
              : DateTime(startOfYear.year, month, day);

          if (date.isSameDayOrAfter(relativeDate)) {
            yield date;
          }
        }
      }

      currentYear = currentYear.add(interval);
    }
  }
}

class MonthlyDateSchedule extends DateSchedule {
  final List<int>? days;
  final List<int>? weekdays;
  final List<int>? nthWeekdays;

  MonthlyDateSchedule({
    super.interval,
    this.days,
    this.weekdays,
    this.nthWeekdays,
  }) : super(period: DateSchedulePeriods.monthly);

  @override
  _prev(relativeDate) sync* {
    final MonthlyDateSchedule(:days, :weekdays, :nthWeekdays) = this;
    var currentMonth = DateInterval.month(relativeDate);

    while (true) {
      final DateInterval(start: startOfMonth, end: endOfMonth) = currentMonth;

      if (nthWeekdays != null) {
        for (var nthWeekday in nthWeekdays.reversed) {
          for (final weekday in weekdays!.reversed) {
            if (nthWeekday == -1) {
              final lastWeekOfMonth = DateInterval.week(endOfMonth);
              var date = lastWeekOfMonth.start.addUnshifted((weekday - 1).days);

              if (!currentMonth.spans(date)) {
                date = date.subtractUnshifted(7.days);
              }

              if (date.isSameDayOrBefore(relativeDate)) {
                yield date;
              }
            } else {
              final firstWeekOfMonth = DateInterval.week(startOfMonth);
              var firstOccurrenceDate =
                  firstWeekOfMonth.start.addUnshifted((weekday - 1).days);
              if (!currentMonth.spans(firstOccurrenceDate)) {
                firstOccurrenceDate = firstOccurrenceDate.addUnshifted(7.days);
              }

              final nthOcurrencyDay =
                  firstOccurrenceDate.day + (nthWeekday - 1) * 7;
              if (nthOcurrencyDay <= endOfMonth.day) {
                final date = DateTime(
                  startOfMonth.year,
                  startOfMonth.month,
                  nthOcurrencyDay,
                );
                if (date.isSameDayOrBefore(relativeDate)) {
                  yield date;
                }
              }
            }
          }
        }
      } else if (weekdays != null) {
        var currentWeek = DateInterval.week(relativeDate);

        while (true) {
          for (var weekday in weekdays.reversed) {
            final date = currentWeek.start.addUnshifted((weekday - 1).days);
            if (currentMonth.spans(date) &&
                date.isSameDayOrBefore(relativeDate)) {
              yield date;
            }
          }

          currentWeek = currentWeek.previous();
          if (currentWeek.end.isBefore(currentMonth.start)) {
            break;
          }
        }
      } else if (days != null) {
        for (var day in days.reversed) {
          final date = day == -1
              ? DateTime(startOfMonth.year, startOfMonth.month + 1, 0)
              : DateTime(startOfMonth.year, startOfMonth.month, day);

          if (date.isSameDayOrBefore(relativeDate)) {
            yield date;
          }
        }
      }

      currentMonth = currentMonth.subtract(interval);
    }
  }

  @override
  _next(relativeDate) sync* {
    final MonthlyDateSchedule(:days, :weekdays, :nthWeekdays) = this;
    var currentMonth = DateInterval.month(relativeDate);

    while (true) {
      final DateInterval(start: startOfMonth, end: endOfMonth) = currentMonth;

      if (nthWeekdays != null) {
        for (var nthWeekday in nthWeekdays) {
          for (final weekday in weekdays!) {
            if (nthWeekday == -1) {
              final lastWeekOfMonth = DateInterval.week(endOfMonth);
              var date = lastWeekOfMonth.start.addUnshifted((weekday - 1).days);

              if (!currentMonth.spans(date)) {
                date = date.subtractUnshifted(7.days);
              }

              if (date.isSameDayOrAfter(relativeDate)) {
                yield date;
              }
            } else {
              final firstWeekOfMonth = DateInterval.week(startOfMonth);
              var firstOccurrenceDate =
                  firstWeekOfMonth.start.addUnshifted((weekday - 1).days);
              if (!currentMonth.spans(firstOccurrenceDate)) {
                firstOccurrenceDate = firstOccurrenceDate.addUnshifted(7.days);
              }

              final nthOcurrencyDay =
                  firstOccurrenceDate.day + (nthWeekday - 1) * 7;
              if (nthOcurrencyDay <= endOfMonth.day) {
                final date = DateTime(
                  startOfMonth.year,
                  startOfMonth.month,
                  nthOcurrencyDay,
                );
                if (date.isSameDayOrAfter(relativeDate)) {
                  yield date;
                }
              }
            }
          }
        }
      } else if (weekdays != null) {
        var currentWeek = DateInterval.week(relativeDate);

        while (true) {
          for (var weekday in weekdays) {
            final date = currentWeek.start.addUnshifted((weekday - 1).days);
            if (date.isSameDayOrAfter(relativeDate) &&
                currentMonth.spans(date)) {
              yield date;
            }
          }

          currentWeek = currentWeek.next();
          if (currentWeek.start.isAfter(currentMonth.end)) {
            break;
          }
        }
      } else if (days != null) {
        for (final day in days) {
          final date = day == -1
              ? DateTime(startOfMonth.year, startOfMonth.month + 1, 0)
              : DateTime(startOfMonth.year, startOfMonth.month, day);

          if (date.isSameDayOrAfter(relativeDate)) {
            yield date;
          }
        }
      }

      currentMonth = currentMonth.add(interval);
    }
  }
}

class WeeklyDateSchedule extends DateSchedule {
  final List<int> weekdays;

  WeeklyDateSchedule({
    super.interval,
    required this.weekdays,
  }) : super(period: DateSchedulePeriods.weekly);

  @override
  _prev(relativeDate) sync* {
    var currentWeek = DateInterval.week(relativeDate);

    while (true) {
      for (final weekday in weekdays.reversed) {
        final date = currentWeek.start.add((weekday - 1).days);
        if (date.isSameDayOrBefore(relativeDate)) {
          yield date;
        }
      }
      currentWeek = currentWeek.subtract(interval);
    }
  }

  @override
  _next(relativeDate) sync* {
    var currentWeek = DateInterval.week(relativeDate);

    while (true) {
      for (final weekday in weekdays) {
        final date = currentWeek.start.add((weekday - 1).days);
        if (date.isSameDayOrAfter(relativeDate)) {
          yield date;
        }
      }
      currentWeek = currentWeek.add(interval);
    }
  }
}

class DailyDateSchedule extends DateSchedule {
  DailyDateSchedule({
    super.interval,
  }) : super(period: DateSchedulePeriods.daily);

  @override
  _prev(relativeDate) sync* {
    var currentDay = DateInterval.day(relativeDate);

    while (true) {
      yield currentDay.start;
      currentDay = currentDay.subtract(interval);
    }
  }

  @override
  _next(relativeDate) sync* {
    var currentDay = DateInterval.day(relativeDate);

    while (true) {
      yield currentDay.start;
      currentDay = currentDay.add(interval);
    }
  }
}
