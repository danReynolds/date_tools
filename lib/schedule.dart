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

enum _Direction {
  forward,
  backward,
}

class DateSchedule {
  final DateSchedulePeriods period;
  final int interval;
  final DateTime _date;

  DateSchedule(
    this._date, {
    required this.period,
    final int? interval,
  }) : interval = interval ?? 1;

  static YearlyDateSchedule yearly({
    DateTime? date,
    required List<int> months,
    required List<int> days,
    int? interval,
  }) {
    return YearlyDateSchedule(
      date ?? DateTime.now(),
      interval: interval,
      months: months,
      days: days,
    );
  }

  static MonthlyDateSchedule monthly({
    DateTime? date,
    List<int>? days,
    List<int>? weekdays,
    List<int>? nthWeekdays,
    int? interval,
  }) {
    return MonthlyDateSchedule(
      date ?? DateTime.now(),
      interval: interval,
      days: days,
      weekdays: weekdays,
      nthWeekdays: nthWeekdays,
    );
  }

  static WeeklyDateSchedule weekly({
    DateTime? date,
    required List<int> weekdays,
    int? interval,
  }) {
    return WeeklyDateSchedule(
      date ?? DateTime.now(),
      interval: interval,
      weekdays: weekdays,
    );
  }

  static DailyDateSchedule daily({
    DateTime? date,
    int? interval,
  }) {
    return DailyDateSchedule(date ?? DateTime.now(), interval: interval);
  }

  Iterable<DateTime> _shift(_Direction direction) sync* {
    final isBackward = direction == _Direction.backward;
    final directionModifier = isBackward ? -1 : 1;
    final interval = this.interval * directionModifier;

    switch (this) {
      case YearlyDateSchedule schedule:
        final YearlyDateSchedule(:months, :days) = schedule;

        var currentYear = DateInterval.year(_date);
        while (true) {
          final startOfYear = currentYear.start;

          for (final month in months.reversedIf(isBackward)) {
            for (final day in days.reversedIf(isBackward)) {
              yield DateTime(startOfYear.year, month, day);
            }
          }

          currentYear = currentYear.add(interval);
        }
      case MonthlyDateSchedule schedule:
        final MonthlyDateSchedule(:days, :weekdays, :nthWeekdays) = schedule;

        while (true) {
          var currentMonth = DateInterval.month(_date);
          final startOfMonth = currentMonth.start;
          final endOfMonth = currentMonth.end;

          if (days != null) {
            for (final day in days.reversedIf(isBackward)) {
              yield DateTime(startOfMonth.year, startOfMonth.month, day);
            }
          } else if (nthWeekdays != null) {
            final firstWeekOfMonth = DateInterval.week(startOfMonth);

            while (true) {
              for (final nthWeekday in nthWeekdays.reversedIf(isBackward)) {
                for (final weekday in weekdays!.reversedIf(isBackward)) {
                  int firstOccurenceDay =
                      firstWeekOfMonth.start.day + weekday - 1;

                  if (firstOccurenceDay < 1) {
                    firstOccurenceDay += 7;
                  }

                  final nthOcurrencyDay =
                      firstOccurenceDay + (nthWeekday - 1) * 7;

                  if (nthOcurrencyDay >= 1 &&
                      nthOcurrencyDay < endOfMonth.day) {
                    yield DateTime(
                      startOfMonth.year,
                      startOfMonth.month,
                      nthOcurrencyDay,
                    );
                  }
                }
              }
            }
          } else if (weekdays != null) {
            var currentWeek = DateInterval.week(
              isBackward ? currentMonth.end : currentMonth.start,
            );

            while (true) {
              for (final weekday in weekdays.reversedIf(isBackward)) {
                final date = currentWeek.start.add((weekday - 1).days);

                if (currentMonth.spans(date)) {
                  yield date;
                }
              }

              currentWeek = currentWeek.add(directionModifier);

              if (!currentMonth.spans(currentWeek.start) &&
                  !currentMonth.spans(currentWeek.end)) {
                break;
              }
            }
          }

          currentMonth = currentMonth.add(interval);
        }
      case WeeklyDateSchedule schedule:
        final WeeklyDateSchedule(:weekdays) = schedule;
        var currentWeek = DateInterval.week(_date);

        while (true) {
          for (final weekday in weekdays.reversedIf(isBackward)) {
            final date = currentWeek.start.add((weekday - 1).days);
            yield date;
          }

          currentWeek = currentWeek.add(interval);
        }
      case DailyDateSchedule _:
        var currentDay = DateInterval.day(_date);

        while (true) {
          yield currentDay.start;
          currentDay = currentDay.add(interval);
        }
    }
  }

  Iterable<DateTime> get prev => _shift(_Direction.backward)
      .where((date) => date.isSameDayAs(_date) || date.isBefore(_date));
  Iterable<DateTime> get next => _shift(_Direction.forward)
      .where((date) => date.isSameDayAs(_date) || date.isAfter(_date));

  List<DateTime> generate(int count) {
    return switch (count) {
      < 0 => prev.take(-count).toList(),
      > 0 => next.take(count).toList(),
      _ => [],
    };
  }
}

class YearlyDateSchedule extends DateSchedule {
  final List<int> months;
  final List<int> days;

  YearlyDateSchedule(
    super._date, {
    super.interval,
    required this.months,
    required this.days,
  }) : super(period: DateSchedulePeriods.yearly);
}

class MonthlyDateSchedule extends DateSchedule {
  final List<int>? days;
  final List<int>? weekdays;
  final List<int>? nthWeekdays;

  MonthlyDateSchedule(
    super._date, {
    super.interval,
    this.days,
    this.weekdays,
    this.nthWeekdays,
  }) : super(period: DateSchedulePeriods.monthly);
}

class WeeklyDateSchedule extends DateSchedule {
  final List<int> weekdays;

  WeeklyDateSchedule(
    super._date, {
    super.interval,
    required this.weekdays,
  }) : super(period: DateSchedulePeriods.weekly);
}

class DailyDateSchedule extends DateSchedule {
  DailyDateSchedule(
    super._date, {
    super.interval,
  }) : super(period: DateSchedulePeriods.daily);
}
