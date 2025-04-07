part of date_tools;

enum DateSchedulePeriods {
  yearly,
  monthly,
  weekly,
  daily,
  custom;
}

abstract class DateSchedule {
  final DateSchedulePeriods period;

  DateSchedule({
    required this.period,
  });

  static YearlyDateSchedule yearly({
    DateTime? startDate,
    required List<int> months,
    required List<int> days,
    int interval = 1,
  }) {
    return YearlyDateSchedule(
      interval: interval,
      months: months,
      days: days,
    );
  }

  static MonthlyDateSchedule monthly({
    List<int>? days,
    List<int>? weekdays,
    List<int>? nthWeekdays,
    int interval = 1,
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
    int interval = 1,
  }) {
    return WeeklyDateSchedule(
      interval: interval,
      weekdays: weekdays,
    );
  }

  static DailyDateSchedule daily({
    int interval = 1,
  }) {
    return DailyDateSchedule(interval: interval);
  }

  static FixedDateSchedule fixed(List<DateTime> dates) {
    return FixedDateSchedule(dates);
  }

  static MergedDateSchedule merge(List<DateSchedule> schedules) {
    return MergedDateSchedule(schedules: schedules);
  }

  Iterable<DateTime> _prev(DateTime relativeDate);
  Iterable<DateTime> _next(DateTime relativeDate);

  Iterable<DateTime> start(
    DateTime startDate, {
    bool ascending = true,
  }) =>
      (ascending ? _next(startDate) : _prev(startDate));

  Iterable<DateTime> range(
    DateTime startDate,
    DateTime endDate, {
    bool ascending = true,
  }) {
    if (ascending) {
      return start(startDate, ascending: ascending).takeWhile(
        (date) => date.isSameDayOrBefore(endDate),
      );
    }
    return start(endDate, ascending: false)
        .takeWhile((date) => date.isSameDayOrAfter(startDate));
  }
}

class YearlyDateSchedule extends DateSchedule {
  final List<int> months;
  final List<int> days;
  final int interval;

  YearlyDateSchedule({
    required this.months,
    required this.days,
    this.interval = 1,
  }) : super(period: DateSchedulePeriods.yearly) {
    assert(isValidDayRange(days) && isValidMonthRange(months));
  }

  @override
  _prev(relativeDate) sync* {
    var currentYear = DateInterval.year(relativeDate);

    while (true) {
      final startOfYear = currentYear.start;

      for (final month in months.reversed) {
        for (final day in days.reversed) {
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

      for (final month in months) {
        for (final day in days) {
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
  final int interval;

  MonthlyDateSchedule({
    this.days,
    this.weekdays,
    this.nthWeekdays,
    this.interval = 1,
  }) : super(period: DateSchedulePeriods.monthly) {
    assert(days != null || weekdays != null || nthWeekdays != null);
    assert(
      isValidDayRange(days) &&
          isValidWeekdayRange(weekdays) &&
          isValidNthWeekdayRange(nthWeekdays),
    );
  }

  @override
  _prev(relativeDate) sync* {
    final MonthlyDateSchedule(:days, :weekdays, :nthWeekdays) = this;
    var currentMonth = DateInterval.month(relativeDate);

    while (true) {
      final DateInterval(start: startOfMonth, end: endOfMonth) = currentMonth;

      if (nthWeekdays != null && nthWeekdays.isNotEmpty) {
        for (final nthWeekday in nthWeekdays.reversed) {
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
      } else if (weekdays != null && weekdays.isNotEmpty) {
        var currentWeek = DateInterval.week(relativeDate);

        while (true) {
          for (final weekday in weekdays.reversed) {
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
      } else if (days != null && days.isNotEmpty) {
        for (final day in days.reversed) {
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

      if (nthWeekdays != null && nthWeekdays.isNotEmpty) {
        for (final nthWeekday in nthWeekdays) {
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
      } else if (weekdays != null && weekdays.isNotEmpty) {
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
      } else if (days != null && days.isNotEmpty) {
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
  final int interval;

  WeeklyDateSchedule({
    required this.weekdays,
    this.interval = 1,
  })  : assert(isValidWeekdayRange(weekdays)),
        super(period: DateSchedulePeriods.weekly);

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
  final int interval;

  DailyDateSchedule({
    this.interval = 1,
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

class FixedDateSchedule extends DateSchedule {
  final List<DateTime> dates;

  FixedDateSchedule(List<DateTime> dates)
      : dates = dates.map((date) => DateInterval.day(date).start).toList()
          ..sort(),
        super(period: DateSchedulePeriods.custom);

  @override
  _prev(relativeDate) {
    return dates.reversed
        .toList()
        .skipWhileGreaterThan(DateInterval.day(relativeDate).end);
  }

  @override
  _next(relativeDate) {
    return dates.skipWhileLessThan(DateInterval.day(relativeDate).start);
  }
}

class MergedDateSchedule extends DateSchedule {
  final List<DateSchedule> schedules;

  MergedDateSchedule({
    required this.schedules,
  }) : super(period: DateSchedulePeriods.custom);

  @override
  _prev(relativeDate) sync* {
    final Set<DateTime> yieldedDates = {};

    final iterators = schedules
        .map((schedule) => schedule._prev(relativeDate).iterator)
        .where((iterator) => iterator.moveNext())
        .toList();

    while (iterators.isNotEmpty) {
      iterators.sort((a, b) => b.current.compareTo(a.current));
      final currentIterator = iterators.first;
      final currentValue = currentIterator.current;

      if (yieldedDates.add(currentValue)) {
        yield currentValue;
      }

      if (currentIterator.moveNext()) {
        continue;
      } else {
        iterators.removeAt(0);
      }
    }
  }

  @override
  _next(relativeDate) sync* {
    final Set<DateTime> yieldedDates = {};

    final iterators = schedules
        .map((schedule) => schedule._next(relativeDate).iterator)
        .where((iterator) => iterator.moveNext())
        .toList();

    while (iterators.isNotEmpty) {
      iterators.sort((a, b) => a.current.compareTo(b.current));
      final currentIterator = iterators.first;
      final currentValue = currentIterator.current;

      if (yieldedDates.add(currentValue)) {
        yield currentValue;
      }

      if (currentIterator.moveNext()) {
        continue;
      } else {
        iterators.removeAt(0);
      }
    }
  }
}
