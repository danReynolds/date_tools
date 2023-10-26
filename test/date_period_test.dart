import 'package:flutter_test/flutter_test.dart';
import 'package:date_period/period.dart';

void main() {
  group('DateInterval', () {
    group('offset', () {
      // test('offsets week interval', () {
      //   final now = DateTime.utc(2023, 10, 25);

      //   expect(DateInterval.week.offset(now, 14), DateTime.utc(2023, 11, 8));
      //   expect(DateInterval.week.offset(now, -14), DateTime.utc(2023, 10, 11));
      //   expect(DateInterval.week.offset(now, 7), DateTime.utc(2023, 11, 1));
      //   expect(DateInterval.week.offset(now, -7), DateTime.utc(2023, 10, 18));
      //   expect(DateInterval.week.offset(now, 2), DateTime.utc(2023, 10, 27));
      //   expect(DateInterval.week.offset(now, -2), DateTime.utc(2023, 10, 23));
      // });

      // test('offsets month interval', () {
      //   final now = DateTime.utc(2023, 10, 25);

      //   expect(DateInterval.month.offset(now, 14), DateTime.utc(2023, 11, 8));
      //   expect(DateInterval.month.offset(now, -14), DateTime.utc(2023, 10, 11));
      //   expect(DateInterval.month.offset(now, 7), DateTime.utc(2023, 11, 1));
      //   expect(DateInterval.month.offset(now, -7), DateTime.utc(2023, 10, 18));
      //   expect(DateInterval.month.offset(now, 2), DateTime.utc(2023, 10, 27));
      //   expect(DateInterval.month.offset(now, -2), DateTime.utc(2023, 10, 23));
      // });

      test('offsets year interval', () {
        final now = DateTime.utc(2023, 10, 25);

        // expect(DateInterval.year.offset(now, 12), DateTime.utc(2024, 10, 1));
        // expect(DateInterval.year.offset(now, -12), DateTime.utc(2022, 10, 1));
        // expect(DateInterval.year.offset(now, 6), DateTime.utc(2024, 04, 1));
        // expect(DateInterval.year.offset(now, -6), DateTime.utc(2023, 4, 1));
        // expect(DateInterval.year.offset(now, 2), DateTime.utc(2023, 12, 1));
        // expect(DateInterval.year.offset(now, -2), DateTime.utc(2023, 8, 1));
      });
    });
  });
}
