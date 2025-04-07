# Date Tools

Tools for working with dates including implementations of [DateInterval], [DateSchedule] and additional extensions on [DateTime].

### Date Intervals

The [DateInterval] API makes it easier to work with common date intervals like days, months and years. You can check the start/end of intervals,
move to previous and next intervals, and generate sequences of intervals.

```dart
/// The interval defaults to the [DateTime.now()], but we'll provide a date to make it clear.
final now = DateTime(2023, 10, 26);

print(DateInterval.day(now).start()); // DateTime:<2023-10-26 00:00:00.000000>
print(DateInterval.day(now).end()); // DateTime:<2023-10-26 23:59:59.999999>

print(DateInterval.year(now).next().start); // DateTime:<2024-01-01 00:00:00.000000>

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

### Date Schedules

The [DateSchedule] API supports the generation of dates in the past/future based on a given schedule.

```dart
final now = DateTime(2025, 1, 1); // Wednesday January 1st, 2025.

/// A schedule that repeats every week on Monday and Friday.
print(DateSchedule.weekly(weekdays: [1, 5]).start(now).take(3));
// DateTime:<2025-01-03 00:00:00.000000>
// DateTime:<2025-01-06 00:00:00.000000>
// DateTime:<2025-01-10 00:00:00.000000>

/// A schedule that repeats every month on the 15th and 30th of the month beginning [now].
print(DateSchedule.monthly(days: [15, 30]).start(now).take(3));
// DateTime:<2025-01-15 00:00:00.000000>
// DateTime:<2025-01-30 00:00:00.000000>
// DateTime:<2025-02-15 00:00:00.000000>

/// A schedule that repeats every *other* month on the 15th and 30th of the month beginning [now].
print(DateSchedule.monthly(days: [15, 30], interval: 2).start(now).take(3));
// DateTime:<2025-01-15 00:00:00.000000>
// DateTime:<2025-01-30 00:00:00.000000>
// DateTime:<2025-03-15 00:00:00.000000>

/// A schedule that repeats on Monday and Friday of every week beginning [now].
print(DateSchedule.monthly(weekdays: [1, 5]).start(now).take(3));
// DateTime:<2025-01-03 00:00:00.000000>
// DateTime:<2025-01-06 00:00:00.000000>
// DateTime:<2025-01-10 00:00:00.000000>

/// A schedule that repeats on the 1st and 3rd Friday of every week beginning [now].
print(DateSchedule.monthly(nthWeekdays: [1, 3], weekdays: [5]).start(now).take(3));
// DateTime:<2025-01-03 00:00:00.000000>
// DateTime:<2025-01-17 00:00:00.000000>
// DateTime:<2025-02-07 00:00:00.000000>

/// A schedule that repeats on the first and last day of every other month beginning [now].
print(DateSchedule.monthly(days: [1, -1], interval: 2).start(now).take(3));
// DateTime:<2025-01-01 00:00:00.000000>
// DateTime:<2025-01-31 00:00:00.000000>
// DateTime:<2025-03-01 00:00:00.000000>

/// A schedule that repeats on the last friday of the month beginning [now] and *going back in time*.
print(DateSchedule.monthly(nthWeekdays: [-1], weekdays: [5]).start(now, ascending: false).take(3));
// DateTime:<2024-12-27 00:00:00.000000>
// DateTime:<2024-11-29 00:00:00.000000>
// DateTime:<2024-10-25 00:00:00.000000>

/// A schedule can also be created with a fixed list of dates.
print(DateSchedule.fixed([DateTime(2025, 03, 25), DateTime(2025, 04, 27)]));
// DateTime:<2025-03-25 00:00:00.000000>
// DateTime:<2025-04-27 00:00:00.000000>

// Date schedules can be merged together to support more complex scheduling scenarios. By default,
// overlapping dates are deduped across merged schedules.
print(
   DateSchedule.merge([
    DateSchedule.yearly(months: [1], days: [10, 15]),
    DateSchedule.monthly(days: [2, 9, 10]),
    DateSchedule.fixed([DateTime(2025, 1, 15), DateTime(2025, 1, 16)]),
  ]).start(now).take(7)
);
// DateTime:<2025-01-02 00:00:00.000000>
// DateTime:<2025-01-09 00:00:00.000000>
// DateTime:<2025-01-10 00:00:00.000000>
// DateTime:<2025-01-15 00:00:00.000000>
// DateTime:<2025-01-16 00:00:00.000000>
```

More tools will be added in the future. Happy coding!
