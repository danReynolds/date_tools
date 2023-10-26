import 'package:date_period/date_period.dart';
import 'package:date_period/extensions/num.dart';

class DateRange {
  final DateTime startDate;
  final DateTime endDate;

  DateRange(this.startDate, this.endDate);

  DateTime _increment(DateTime date, DateInterval interval) {
    switch (interval) {
      case DateInterval.hour:
        return date.add(1.minutes);
      case DateInterval.day:
        return date.add(1.hours);
      case DateInterval.week:
      case DateInterval.month:
        return DateTime.utc(
          date.year,
          date.month,
          date.day + 1,
        );
      case DateInterval.year:
        return DateTime.utc(date.year, date.month + 1);
    }
  }

  List<DateTime> expand(DateInterval interval) {
    final List<DateTime> dates = [];

    DateTime date = startDate;

    while (date.isBefore(endDate)) {
      dates.add(date);
      date = _increment(date, interval);
    }

    return dates;
  }
}
