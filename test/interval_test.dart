import 'package:date_tools/date_tools.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateInterval', () {
    late DateTime now;

    setUp(() {
      now = DateTime(2023, 10, 26);
      DateInterval.currentDate = () {
        return now;
      };
    });

    test("toString", () {
      final interval = DateInterval.day();

      expect(
        DateInterval.day().toString(),
        "DateInterval(interval: day, start: ${interval.start}, end: ${interval.end})",
      );
    });

    test('start/end', () {
      expect(DateInterval.hour().start, DateTime(2023, 10, 26));
      expect(
        DateInterval.hour().end,
        DateTime(2023, 10, 26, 1).subtract(1.microseconds),
      );

      expect(DateInterval.day().start, DateTime(2023, 10, 26));
      expect(
        DateInterval.day().end,
        DateTime(2023, 10, 27).subtract(1.microseconds),
      );

      expect(DateInterval.week().start, DateTime(2023, 10, 23));
      expect(
        DateInterval.week().end,
        DateTime(2023, 10, 30).subtract(1.microseconds),
      );

      expect(DateInterval.biweek().start, DateTime(2023, 10, 23));
      expect(
        DateInterval.biweek().end,
        DateTime(2023, 11, 6).subtract(1.microseconds),
      );

      expect(DateInterval.month().start, DateTime(2023, 10));
      expect(
        DateInterval.month().end,
        DateTime(2023, 11).subtract(1.microseconds),
      );

      expect(DateInterval.year().start, DateTime(2023));
      expect(
        DateInterval.year().end,
        DateTime(2024).subtract(1.microseconds),
      );
    });

    test("previous/next", () {
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

    test('generate', () {
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

    test('add/subtract', () {
      expect(
        DateInterval.hour().subtract(2),
        DateInterval.hour(DateTime(2023, 10, 25, 22)),
      );
      expect(
        DateInterval.hour().add(2),
        DateInterval.hour(DateTime(2023, 10, 26, 2)),
      );

      expect(
        DateInterval.day().subtract(2),
        DateInterval.day(DateTime(2023, 10, 24)),
      );
      expect(
        DateInterval.day().add(2),
        DateInterval.day(DateTime(2023, 10, 28)),
      );

      expect(
        DateInterval.week().subtract(2),
        DateInterval.week(DateTime(2023, 10, 12)),
      );
      expect(
        DateInterval.week().add(2),
        DateInterval.week(DateTime(2023, 11, 9)),
      );

      expect(
        DateInterval.month().subtract(2),
        DateInterval.month(DateTime(2023, 8, 26)),
      );
      expect(
        DateInterval.month().add(2),
        DateInterval.month(DateTime(2023, 12, 26)),
      );

      expect(
        DateInterval.year().subtract(2),
        DateInterval.year(DateTime(2021, 10, 26)),
      );
      expect(
        DateInterval.year().add(2),
        DateInterval.year(DateTime(2025, 10, 26)),
      );
    });

    test('spans', () {
      final interval = DateInterval.month();

      expect(interval.spans(interval.start), true);
      expect(interval.spans(interval.end), true);
      expect(interval.spans(interval.end.add(1.microseconds)), false);
    });

    test('range', () {
      final interval = DateInterval.day();
      final future = now.add(2.days);
      final past = now.subtract(2.days);

      expect(interval.range(future).toList(), [
        DateInterval.day(),
        DateInterval.day(now.add(1.days)),
        DateInterval.day(now.add(2.days)),
      ]);
      expect(interval.range(past), [
        DateInterval.day(),
        DateInterval.day(now.subtract(1.days)),
        DateInterval.day(now.subtract(2.days)),
      ]);
    });
  });
}
