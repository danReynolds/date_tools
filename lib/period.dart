library date_tools;

part 'extensions/iterable.dart';
part 'extensions/num.dart';
part 'date_tools.dart';

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
      (period) => period.start == startDate && period.end == endDate,
    );
  }

  DateInterval get interval {
    switch (this) {
      case DatePeriod.today:
        return DateInterval.day();
      case DatePeriod.yesterday:
        return DatePeriod.today.interval.previous();
      case DatePeriod.thisWeek:
        return DateInterval.week();
      case DatePeriod.lastWeek:
        return DatePeriod.thisWeek.interval.previous();
      case DatePeriod.thisMonth:
        return DateInterval.month();
      case DatePeriod.lastMonth:
        return DatePeriod.thisMonth.interval.previous();
      case DatePeriod.thisYear:
        return DateInterval.year();
      case DatePeriod.lastYear:
        return DatePeriod.thisYear.interval.previous();
    }
  }

  DateTime get start {
    return interval.start;
  }

  DateTime get end {
    return interval.end;
  }
}
