import 'package:date_tools/date_tools.dart';
import 'package:date_tools/extensions/list.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'DateScheduler',
    () {
      final now = DateTime(2025, 03, 25);

      test(
        'Yearly schedule',
        () {
          DateSchedule.weekly(interval: 3, weekdays: [1]);
          // Basic test
          expect(
            DateSchedule.yearly(months: [4, 5], days: [5, 10])
                .start(now)
                .take(3),
            [
              DateTime(2025, 4, 5),
              DateTime(2025, 4, 10),
              DateTime(2025, 5, 5),
            ],
          );
          expect(
            DateSchedule.yearly(months: [4, 5], days: [5, 10])
                .start(now, ascending: false)
                .take(3),
            [
              DateTime(2024, 5, 10),
              DateTime(2024, 5, 5),
              DateTime(2024, 4, 10),
            ],
          );

          // Includes current date
          expect(
            DateSchedule.yearly(months: [3, 10], days: [25, 26])
                .start(now)
                .take(3),
            [
              DateTime(2025, 3, 25),
              DateTime(2025, 3, 26),
              DateTime(2025, 10, 25),
            ],
          );
          expect(
            DateSchedule.yearly(months: [3, 10], days: [25, 26])
                .start(now, ascending: false)
                .take(3),
            [
              DateTime(2025, 3, 25),
              DateTime(2024, 10, 26),
              DateTime(2024, 10, 25),
            ],
          );

          // Skips dates before start date
          expect(
            DateSchedule.yearly(months: [3, 10], days: [24, 26])
                .start(now)
                .take(3),
            [
              DateTime(2025, 3, 26),
              DateTime(2025, 10, 24),
              DateTime(2025, 10, 26),
            ],
          );
          // Skips dates after start date
          expect(
            DateSchedule.yearly(months: [3, 10], days: [24, 26])
                .start(now, ascending: false)
                .take(3),
            [
              DateTime(2025, 3, 24),
              DateTime(2024, 10, 26),
              DateTime(2024, 10, 24),
            ],
          );

          // Last day test
          expect(
            DateSchedule.yearly(months: [3, 10], days: [24, -1])
                .start(now)
                .take(3),
            [
              DateTime(2025, 3, 31),
              DateTime(2025, 10, 24),
              DateTime(2025, 10, 31),
            ],
          );
          expect(
            DateSchedule.yearly(months: [3, 10], days: [24, -1])
                .start(now, ascending: false)
                .take(3),
            [
              DateTime(2025, 3, 24),
              DateTime(2024, 10, 31),
              DateTime(2024, 10, 24),
            ],
          );

          // Interval test
          expect(
            DateSchedule.yearly(months: [3, 10], days: [24, 26], interval: 2)
                .start(now)
                .take(6),
            [
              DateTime(2025, 3, 26),
              DateTime(2025, 10, 24),
              DateTime(2025, 10, 26),
              DateTime(2027, 3, 24),
              DateTime(2027, 3, 26),
              DateTime(2027, 10, 24),
            ],
          );
        },
      );

      group(
        'Monthly schedule',
        () {
          test(
            'Days',
            () {
              // Basic test
              expect(DateSchedule.monthly(days: [5, 10]).start(now).take(3), [
                DateTime(2025, 4, 5),
                DateTime(2025, 4, 10),
                DateTime(2025, 5, 5),
              ]);
              expect(
                DateSchedule.monthly(days: [5, 10])
                    .start(now, ascending: false)
                    .take(3),
                [
                  DateTime(2025, 3, 10),
                  DateTime(2025, 3, 5),
                  DateTime(2025, 2, 10),
                ],
              );

              // Includes current date
              expect(
                DateSchedule.monthly(days: [5, 25]).start(now).take(3),
                [
                  DateTime(2025, 3, 25),
                  DateTime(2025, 4, 5),
                  DateTime(2025, 4, 25),
                ],
              );
              expect(
                DateSchedule.monthly(days: [5, 25])
                    .start(now, ascending: false)
                    .take(3),
                [
                  DateTime(2025, 3, 25),
                  DateTime(2025, 3, 5),
                  DateTime(2025, 2, 25),
                ],
              );

              // Last day test
              expect(DateSchedule.monthly(days: [5, -1]).start(now).take(3), [
                DateTime(2025, 3, 31),
                DateTime(2025, 4, 5),
                DateTime(2025, 4, 30),
              ]);
              expect(
                DateSchedule.monthly(days: [5, -1])
                    .start(now, ascending: false)
                    .take(3),
                [
                  DateTime(2025, 3, 5),
                  DateTime(2025, 2, 28),
                  DateTime(2025, 2, 5),
                ],
              );

              // Interval test
              expect(
                DateSchedule.monthly(days: [3, 10], interval: 2)
                    .start(now)
                    .take(6),
                [
                  DateTime(2025, 5, 3),
                  DateTime(2025, 5, 10),
                  DateTime(2025, 7, 3),
                  DateTime(2025, 7, 10),
                  DateTime(2025, 9, 3),
                  DateTime(2025, 9, 10),
                ],
              );
              expect(
                DateSchedule.monthly(days: [3, 10], interval: 2)
                    .start(now, ascending: false)
                    .take(6),
                [
                  DateTime(2025, 3, 10),
                  DateTime(2025, 3, 3),
                  DateTime(2025, 1, 10),
                  DateTime(2025, 1, 3),
                  DateTime(2024, 11, 10),
                  DateTime(2024, 11, 3),
                ],
              );
            },
          );

          test(
            // Now is 2025-03-25, which is a Tuesday.
            'weekdays',
            () {
              // Basic test
              expect(
                  DateSchedule.monthly(weekdays: [2, 5]).start(now).take(3), [
                DateTime(2025, 3, 25),
                DateTime(2025, 3, 28),
                DateTime(2025, 4, 1),
              ]);
              expect(
                DateSchedule.monthly(weekdays: [2, 5])
                    .start(now, ascending: false)
                    .take(3),
                [
                  DateTime(2025, 3, 25),
                  DateTime(2025, 3, 21),
                  DateTime(2025, 3, 18),
                ],
              );

              // Interval test
              expect(
                // Every 6 months on every Monday and Sunday of the month.
                DateSchedule.monthly(
                  weekdays: [1, 7],
                  interval: 6,
                ).start(now).take(4),
                [
                  DateTime(2025, 3, 30),
                  DateTime(2025, 3, 31),
                  DateTime(2025, 9, 1),
                  DateTime(2025, 9, 7),
                ],
              );
              expect(
                DateSchedule.monthly(
                  weekdays: [1, 7],
                  interval: 6,
                ).start(now, ascending: false).take(10),
                [
                  DateTime(2025, 3, 24),
                  DateTime(2025, 3, 23),
                  DateTime(2025, 3, 17),
                  DateTime(2025, 3, 16),
                  DateTime(2025, 3, 10),
                  DateTime(2025, 3, 9),
                  DateTime(2025, 3, 3),
                  DateTime(2025, 3, 2),
                  DateTime(2024, 9, 30),
                  DateTime(2024, 9, 29),
                ],
              );
            },
          );

          test(
            "nthWeekdays",
            () {
              // Basic test
              expect(
                // The first and third Tuesday of every month.
                DateSchedule.monthly(nthWeekdays: [1, 4], weekdays: [2])
                    .start(now)
                    .take(3),
                [
                  DateTime(2025, 3, 25),
                  DateTime(2025, 4, 1),
                  DateTime(2025, 4, 22),
                ],
              );
              expect(
                DateSchedule.monthly(nthWeekdays: [1, 4], weekdays: [2])
                    .start(now, ascending: false)
                    .take(3),
                [
                  DateTime(2025, 3, 25),
                  DateTime(2025, 3, 4),
                  DateTime(2025, 2, 25),
                ],
              );

              // Last nth weekday test
              expect(
                // The first and last Tuesday of every month.
                DateSchedule.monthly(nthWeekdays: [1, -1], weekdays: [2])
                    .start(now)
                    .take(3),
                [
                  DateTime(2025, 3, 25),
                  DateTime(2025, 4, 1),
                  DateTime(2025, 4, 29),
                ],
              );
              expect(
                DateSchedule.monthly(nthWeekdays: [1, -1], weekdays: [2])
                    .start(now, ascending: false)
                    .take(3),
                [
                  DateTime(2025, 3, 25),
                  DateTime(2025, 3, 4),
                  DateTime(2025, 2, 25),
                ],
              );

              // Interval test
              expect(
                // The first and third Tuesday of every other month.
                DateSchedule.monthly(
                  nthWeekdays: [1, 4],
                  weekdays: [2],
                  interval: 2,
                ).start(now).take(6),
                [
                  DateTime(2025, 3, 25),
                  DateTime(2025, 5, 6),
                  DateTime(2025, 5, 27),
                  DateTime(2025, 7, 1),
                  DateTime(2025, 7, 22),
                  DateTime(2025, 9, 2),
                ],
              );
              expect(
                DateSchedule.monthly(
                  nthWeekdays: [1, 4],
                  weekdays: [2],
                  interval: 2,
                ).start(now, ascending: false).take(6),
                [
                  DateTime(2025, 3, 25),
                  DateTime(2025, 3, 4),
                  DateTime(2025, 1, 28),
                  DateTime(2025, 1, 7),
                  // DST occurs in this month on November 3rd, 2024. When durations are added
                  // to the start of the month, this would break if done unshifted, since the default
                  // date math adjusts for DST. The fact that this works confirms that unshifted math is used
                  // to adjust the date without being affected by local shifts.
                  DateTime(2024, 11, 26),
                  DateTime(2024, 11, 5),
                ],
              );
            },
          );
        },
      );

      test(
        'Weekly schedule',
        () {
          // Basic test
          expect(
            DateSchedule.weekly(weekdays: [1, 7]).start(now).take(3),
            [
              DateTime(2025, 3, 30),
              DateTime(2025, 3, 31),
              DateTime(2025, 4, 6),
            ],
          );
          expect(
            DateSchedule.weekly(weekdays: [1, 7])
                .start(now, ascending: false)
                .take(3),
            [
              DateTime(2025, 3, 24),
              DateTime(2025, 3, 23),
              DateTime(2025, 3, 17),
            ],
          );

          // Interval test
          expect(
            // Every two weeks on Thurday
            DateSchedule.weekly(weekdays: [4], interval: 2).start(now).take(3),
            [
              DateTime(2025, 3, 27),
              DateTime(2025, 4, 10),
              DateTime(2025, 4, 24),
            ],
          );
          expect(
            DateSchedule.weekly(weekdays: [4], interval: 2)
                .start(now, ascending: false)
                .take(3),
            [
              DateTime(2025, 3, 13),
              DateTime(2025, 2, 27),
              DateTime(2025, 2, 13),
            ],
          );
        },
      );

      test(
        'Daily schedule',
        () {
          // Basic test
          expect(
            DateSchedule.daily().start(now).take(3),
            [
              DateTime(2025, 3, 25),
              DateTime(2025, 3, 26),
              DateTime(2025, 3, 27),
            ],
          );
          expect(
            DateSchedule.daily().start(now, ascending: false).take(3),
            [
              DateTime(2025, 3, 25),
              DateTime(2025, 3, 24),
              DateTime(2025, 3, 23),
            ],
          );

          // Interval test
          expect(
            DateSchedule.daily(interval: 3).start(now).take(6),
            [
              DateTime(2025, 3, 25),
              DateTime(2025, 3, 28),
              DateTime(2025, 3, 31),
              DateTime(2025, 4, 3),
              DateTime(2025, 4, 6),
              DateTime(2025, 4, 9),
            ],
          );
          expect(
            DateSchedule.daily(interval: 3)
                .start(now, ascending: false)
                .take(6),
            [
              DateTime(2025, 3, 25),
              DateTime(2025, 3, 22),
              DateTime(2025, 3, 19),
              DateTime(2025, 3, 16),
              DateTime(2025, 3, 13),
              DateTime(2025, 3, 10),
            ],
          );
        },
      );

      test(
        'Fixed schedule',
        () {
          // Basic test
          expect(
            DateSchedule.fixed([
              DateTime(2025, 3, 25),
              DateTime(2025, 3, 26),
              DateTime(2025, 3, 27),
              DateTime(2025, 3, 29),
              DateTime(2025, 5, 31),
            ]).start(now).take(5),
            [
              DateTime(2025, 3, 25),
              DateTime(2025, 3, 26),
              DateTime(2025, 3, 27),
              DateTime(2025, 3, 29),
              DateTime(2025, 5, 31),
            ],
          );

          // Descending test
          expect(
            DateSchedule.fixed([
              DateTime(2025, 3, 25),
              DateTime(2025, 3, 26),
              DateTime(2025, 3, 27),
              DateTime(2025, 3, 29),
              DateTime(2025, 5, 31),
            ]).start(DateTime(2025, 6, 01), ascending: false).take(5),
            [
              DateTime(2025, 5, 31),
              DateTime(2025, 3, 29),
              DateTime(2025, 3, 27),
              DateTime(2025, 3, 26),
              DateTime(2025, 3, 25),
            ],
          );
        },
      );

      test(
        'Combined schedule',
        () {
          expect(
            DateSchedule.merge([
              DateSchedule.yearly(months: [4], days: [2, 5]),
              DateSchedule.monthly(days: [2, 9, 10]),
              DateSchedule.weekly(weekdays: [4]),
            ]).start(now).take(7),
            [
              // Yearly dates
              DateTime(2025, 4, 2),
              DateTime(2025, 4, 5),
              // Monthly dates
              DateTime(2025, 4, 2), // De-duped with the yearly date
              DateTime(2025, 4, 9),
              DateTime(2025, 4, 10),
              // Weekly dates
              DateTime(2025, 3, 27),
              DateTime(2025, 4, 3),
              DateTime(2025, 4, 10), // De-duped with the monthly date
              DateTime(2025, 4, 17),
            ].distinct
              ..sort(),
          );

          expect(
            DateSchedule.merge([
              DateSchedule.yearly(months: [2], days: [20, 25]),
              DateSchedule.monthly(days: [13, 20, 24]),
              DateSchedule.weekly(weekdays: [4]),
            ]).start(now, ascending: false).take(9),
            [
              // Yearly dates
              DateTime(2025, 2, 25),
              DateTime(2025, 2, 20),
              // Monthly dates
              DateTime(2025, 3, 24),
              DateTime(2025, 2, 24),
              DateTime(2025, 2, 20), // De-duped with the yearly date
              DateTime(2025, 2, 13),
              // Weekly dates
              DateTime(2025, 3, 20),
              DateTime(2025, 3, 13),
              DateTime(2025, 3, 6),
              DateTime(2025, 2, 27),
            ].distinct
              ..sort((a, b) => b.compareTo(a)),
          );
        },
      );
    },
  );

  test(
    'Range',
    () {
      final now = DateTime(2025, 03, 25);

      expect(
        DateSchedule.yearly(months: [1, 6, 10], days: [1, 2])
            .range(now, DateTime(2025, 12, 31)),
        [
          DateTime(2025, 6, 1),
          DateTime(2025, 6, 2),
          DateTime(2025, 10, 1),
          DateTime(2025, 10, 2),
        ],
      );

      expect(
        DateSchedule.monthly(weekdays: [1, 5])
            .range(now, DateTime(2025, 04, 30)),
        [
          DateTime(2025, 3, 28),
          DateTime(2025, 3, 31),
          DateTime(2025, 4, 4),
          DateTime(2025, 4, 7),
          DateTime(2025, 4, 11),
          DateTime(2025, 4, 14),
          DateTime(2025, 4, 18),
          DateTime(2025, 4, 21),
          DateTime(2025, 4, 25),
          DateTime(2025, 4, 28),
        ],
      );

      expect(
        DateSchedule.weekly(weekdays: [2]).range(now, DateTime(2025, 04, 30)),
        [
          DateTime(2025, 3, 25),
          DateTime(2025, 4, 1),
          DateTime(2025, 4, 8),
          DateTime(2025, 4, 15),
          DateTime(2025, 4, 22),
          DateTime(2025, 4, 29),
        ],
      );

      expect(
        DateSchedule.daily().range(now, now.add(7.days)),
        [
          DateTime(2025, 3, 25),
          DateTime(2025, 3, 26),
          DateTime(2025, 3, 27),
          DateTime(2025, 3, 28),
          DateTime(2025, 3, 29),
          DateTime(2025, 3, 30),
          DateTime(2025, 3, 31),
          DateTime(2025, 4, 1),
        ],
      );
    },
  );

  group(
    'README examples',
    () {
      final now = DateTime(2025, 1, 1); // Wednesday January 1st, 2025.

      test(
        'Weekly schedule on Monday and Friday',
        () {
          expect(DateSchedule.weekly(weekdays: [1, 5]).start(now).take(3), [
            DateTime.parse("2025-01-03 00:00:00.000000"),
            DateTime.parse("2025-01-06 00:00:00.000000"),
            DateTime.parse("2025-01-10 00:00:00.000000"),
          ]);
        },
      );

      test(
        'Monthly schedule on the 15th and 30th',
        () {
          expect(DateSchedule.monthly(days: [15, 30]).start(now).take(3), [
            DateTime.parse("2025-01-15 00:00:00.000000"),
            DateTime.parse("2025-01-30 00:00:00.000000"),
            DateTime.parse("2025-02-15 00:00:00.000000"),
          ]);
        },
      );

      test(
        'Every other month on the 15th and 30th',
        () {
          expect(
            DateSchedule.monthly(days: [15, 30], interval: 2)
                .start(now)
                .take(3),
            [
              DateTime.parse("2025-01-15 00:00:00.000000"),
              DateTime.parse("2025-01-30 00:00:00.000000"),
              DateTime.parse("2025-03-15 00:00:00.000000"),
            ],
          );
        },
      );

      test(
        'Weekly schedule on Monday and Friday',
        () {
          expect(DateSchedule.weekly(weekdays: [1, 5]).start(now).take(3), [
            DateTime.parse("2025-01-03 00:00:00.000000"),
            DateTime.parse("2025-01-06 00:00:00.000000"),
            DateTime.parse("2025-01-10 00:00:00.000000"),
          ]);
        },
      );

      test(
        'First and third Friday of every week',
        () {
          expect(
            DateSchedule.monthly(nthWeekdays: [1, 3], weekdays: [5])
                .start(now)
                .take(3),
            [
              DateTime.parse("2025-01-03 00:00:00.000000"),
              DateTime.parse("2025-01-17 00:00:00.000000"),
              DateTime.parse("2025-02-07 00:00:00.000000"),
            ],
          );
        },
      );

      test(
        'First and last day of every other month',
        () {
          expect(
            DateSchedule.monthly(days: [1, -1], interval: 2).start(now).take(3),
            [
              DateTime.parse("2025-01-01 00:00:00.000000"),
              DateTime.parse("2025-01-31 00:00:00.000000"),
              DateTime.parse("2025-03-01 00:00:00.000000"),
            ],
          );
        },
      );

      test(
        'Last Friday of the month going back in time',
        () {
          expect(
            DateSchedule.monthly(nthWeekdays: [-1], weekdays: [5])
                .start(now, ascending: false)
                .take(3),
            [
              DateTime.parse("2024-12-27 00:00:00.000000"),
              DateTime.parse("2024-11-29 00:00:00.000000"),
              DateTime.parse("2024-10-25 00:00:00.000000"),
            ],
          );
        },
      );

      test('Merged schedule', () {
        expect(
          DateSchedule.merge([
            DateSchedule.yearly(months: [1], days: [10, 15]),
            DateSchedule.monthly(days: [2, 9, 10]),
            DateSchedule.fixed([DateTime(2025, 1, 15), DateTime(2025, 1, 16)]),
          ]).start(now).take(5),
          [
            DateTime(2025, 1, 2),
            DateTime(2025, 1, 9),
            DateTime(2025, 1, 10),
            DateTime(2025, 1, 15),
            DateTime(2025, 1, 16),
          ],
        );
      });
    },
  );
}
