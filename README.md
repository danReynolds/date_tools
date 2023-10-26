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

print(DateInterval.month(now).generate(4).map((interval) => interval.start).toList());
// DateTime:<2023-10-01 00:00:00.000000Z>
// DateTime:<2023-11-01 00:00:00.000000Z>
// DateTime:<2023-12-01 00:00:00.000000Z>
// DateTime:<2024-01-01 00:00:00.000000Z>
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
