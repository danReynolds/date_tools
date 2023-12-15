# Date Tools

Tools for working with dates including a [DateInterval] and [DatePeriod] implementation.

### Date Intervals

The [DateInterval] API makes it easier to work with common date intervals like days, months and years. You can check the start/end of intervals,
move to previous and next intervals, and generate sequences of intervals.

```dart
/// The interval defaults to the [DateTime.now()], but we'll provide a date to make it clear.
final now = DateTime(2023, 10, 26);

print(DateInterval.day(now).start()); // DateTime:<2023-10-26 00:00:00.000000Z>
print(DateInterval.day(now).end()); // DateTime:<2023-10-26 23:59:59.999999Z>

print(DateInterval.year(now).next().start); // DateTime:<2024-01-01 00:00:00.000000Z>

print(DateInterval.month(now).generate(4).toList());
// DateInterval(interval: month, start: 2023-10-01 00:00:00.000, end: 2023-10-31 23:59:59.999999)
// DateInterval(interval: month, start: 2023-11-01 00:00:00.000, end: 2023-11-30 23:59:59.999999)
// DateInterval(interval: month, start: 2023-12-01 00:00:00.000, end: 2023-12-31 23:59:59.999999)
// DateInterval(interval: month, start: 2024-01-01 00:00:00.000, end: 2023-01-31 23:59:59.999999)

print(DateInterval.day(now).range(now.add(2.days)).toList());
// DateInterval(interval: day, start: 2023-10-26 00:00:00.000, end: 2023-10-26 23:59:59.999999)
// DateInterval(interval: day, start: 2023-10-27 00:00:00.000, end: 2023-10-27 23:59:59.999999)
// DateInterval(interval: day, start: 2023-10-28 00:00:00.000, end: 2023-10-28 23:59:59.999999)

print(DateInterval.month(now).spans(now)); // true
print(DateInterval.month(now).subtract(1).spans(now)); // false
```

### Date Periods

The [DatePeriod] enum exposes common date periods like the current week, month and year.

```dart
print(DatePeriod.today.start) // DateTime:<2023-10-26 00:00:00.000000Z>
print(DatePeriod.today.end) // DateTime:<2023-10-26 23:59:59.999999Z>

print(DatePeriod.thisWeek.contains(DateTime(2023, 10, 26))) // true
print(DatePeriod.lastWeek.contains(DateTime(2023, 10, 26))) // false
```

More tools will be added in the future. Happy coding!
