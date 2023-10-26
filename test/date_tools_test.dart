import 'package:flutter_test/flutter_test.dart';
import 'package:date_tools/period.dart';

void main() {
  group('DateInterval', () {
    late DateTime now;

    setUp(() {
      now = DateTime.utc(2023, 10, 26);
      DateInterval.now = () {
        return now;
      };
    });

    test('has expected start/end dates', () {
      expect(DateInterval.hour().start, DateTime.utc(2023, 10, 26));
      expect(
        DateInterval.hour().end,
        DateTime.utc(2023, 10, 26, 1).subtract(1.microseconds),
      );

      expect(DateInterval.day().start, DateTime.utc(2023, 10, 26));
      expect(
        DateInterval.day().end,
        DateTime.utc(2023, 10, 27).subtract(1.microseconds),
      );

      expect(DateInterval.week().start, DateTime.utc(2023, 10, 23));
      expect(
        DateInterval.week().end,
        DateTime.utc(2023, 10, 30).subtract(1.microseconds),
      );

      expect(DateInterval.month().start, DateTime.utc(2023, 10));
      expect(
        DateInterval.month().end,
        DateTime.utc(2023, 11).subtract(1.microseconds),
      );

      expect(DateInterval.year().start, DateTime.utc(2023));
      expect(
        DateInterval.year().end,
        DateTime.utc(2024).subtract(1.microseconds),
      );
    });

    test("has expected previous/next intervals", () {
      expect(
        DateInterval.hour().previous(),
        DateInterval.hour(now.subtract(1.hours)),
      );
      expect(
        DateInterval.hour().next(),
        DateInterval.hour(now.add(1.hours)),
      );

      expect(
        DateInterval.day().previous(),
        DateInterval.day(now.subtract(1.days)),
      );
      expect(
        DateInterval.day().next(),
        DateInterval.day(now.add(1.days)),
      );

      expect(
        DateInterval.week().previous(),
        DateInterval.week(now.subtract(4.days)),
      );
      expect(
        DateInterval.week().next(),
        DateInterval.week(now.add(4.days)),
      );

      expect(
        DateInterval.month().previous(),
        DateInterval.month(now.subtract(27.days)),
      );
      expect(
        DateInterval.month().next(),
        DateInterval.month(now.add(6.days)),
      );

      expect(
        DateInterval.year().previous(),
        DateInterval.year(now.subtract(365.days)),
      );
      expect(
        DateInterval.year().next(),
        DateInterval.year(now.add(365.days)),
      );
    });

    test('Generates interval sequences', () {
      final now = DateTime.utc(2023, 10, 26);

      expect(DateInterval.hour().generate(3).toList(), [
        DateInterval.hour(),
        DateInterval.hour(now.add(1.hours)),
        DateInterval.hour(now.add(2.hours)),
      ]);
      expect(DateInterval.hour().generate(-3).toList(), [
        DateInterval.hour(),
        DateInterval.hour(now.subtract(1.hours)),
        DateInterval.hour(now.subtract(2.hours)),
      ]);

      expect(DateInterval.day().generate(3).toList(), [
        DateInterval.day(),
        DateInterval.day(now.add(1.days)),
        DateInterval.day(now.add(2.days)),
      ]);
      expect(DateInterval.day().generate(-3).toList(), [
        DateInterval.day(),
        DateInterval.day(now.subtract(1.days)),
        DateInterval.day(now.subtract(2.days)),
      ]);

      expect(DateInterval.week().generate(3).toList(), [
        DateInterval.week(),
        DateInterval.week(now.add(7.days)),
        DateInterval.week(now.add(14.days)),
      ]);
      expect(DateInterval.week().generate(-3).toList(), [
        DateInterval.week(),
        DateInterval.week(now.subtract(7.days)),
        DateInterval.week(now.subtract(14.days)),
      ]);

      expect(DateInterval.month().generate(3).toList(), [
        DateInterval.month(),
        DateInterval.month(now.add(30.days)),
        DateInterval.month(now.add(60.days)),
      ]);
      expect(DateInterval.month().generate(-3).toList(), [
        DateInterval.month(),
        DateInterval.month(now.subtract(30.days)),
        DateInterval.month(now.subtract(60.days)),
      ]);

      expect(DateInterval.year().generate(3).toList(), [
        DateInterval.year(),
        DateInterval.year(now.add(365.days)),
        DateInterval.year(now.add(730.days)),
      ]);
      expect(DateInterval.year().generate(-3).toList(), [
        DateInterval.year(),
        DateInterval.year(now.subtract(365.days)),
        DateInterval.year(now.subtract(730.days)),
      ]);
    });
  });

  group('DatePeriod', () {
    late DateTime now;

    setUp(() {
      now = DateTime.utc(2023, 10, 26);
      DateInterval.now = () {
        return now;
      };
    });

    test('has expected start/end dates', () {
      expect(DatePeriod.today.start, now);
      expect(DatePeriod.today.end, now.add(1.days).subtract(1.microseconds));

      expect(DatePeriod.yesterday.start, now.subtract(1.days));
      expect(DatePeriod.yesterday.end, now.subtract(1.microseconds));

      expect(DatePeriod.thisWeek.start, DateTime.utc(2023, 10, 23));
      expect(DatePeriod.thisWeek.end,
          DateTime.utc(2023, 10, 30).subtract(1.microseconds));

      expect(DatePeriod.lastWeek.start, DateTime.utc(2023, 10, 16));
      expect(
        DatePeriod.lastWeek.end,
        DateTime.utc(2023, 10, 23).subtract(1.microseconds),
      );

      expect(DatePeriod.thisMonth.start, DateTime.utc(2023, 10));
      expect(
        DatePeriod.thisMonth.end,
        DateTime.utc(2023, 11).subtract(1.microseconds),
      );

      expect(DatePeriod.lastMonth.start, DateTime.utc(2023, 9));
      expect(
        DatePeriod.lastMonth.end,
        DateTime.utc(2023, 10).subtract(1.microseconds),
      );

      expect(DatePeriod.thisYear.start, DateTime.utc(2023));
      expect(
        DatePeriod.thisYear.end,
        DateTime.utc(2024).subtract(1.microseconds),
      );

      expect(DatePeriod.lastYear.start, DateTime.utc(2022));
      expect(
        DatePeriod.lastYear.end,
        DateTime.utc(2023).subtract(1.microseconds),
      );
    });
  });
}
