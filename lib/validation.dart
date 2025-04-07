part of 'date_tools.dart';

bool isValidDayRange(List<int>? days) {
  return days?.every((day) => day == -1 || (day >= 1 && day <= 31)) ?? true;
}

bool isValidWeekdayRange(List<int>? weekdays) {
  return weekdays?.every((weekday) => (weekday >= 1 && weekday <= 7)) ?? true;
}

bool isValidNthWeekdayRange(List<int>? nthWeekdays) {
  return nthWeekdays?.every((nthWeekday) =>
          (nthWeekday == -1 || nthWeekday >= 1 && nthWeekday <= 5)) ??
      true;
}

bool isValidMonthRange(List<int>? months) {
  return months?.every((month) => (month >= 1 && month <= 12)) ?? true;
}
