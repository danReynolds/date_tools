import 'package:date_tools/date_tools.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateScheduler', () {
    late DateTime now;

    setUp(() {
      now = DateTime(2025, 03, 25);
      DateInterval.currentDate = () {
        return now;
      };
    });

    test(
      'Yearly schedule',
      () {
        // Basic test
        expect(
          DateSchedule.yearly(months: [4, 5], days: [5, 10]).generate(3),
          [
            DateTime(2025, 4, 5),
            DateTime(2025, 4, 10),
            DateTime(2025, 5, 5),
          ],
        );
        expect(
          DateSchedule.yearly(months: [4, 5], days: [5, 10]).generate(-3),
          [
            DateTime(2024, 5, 10),
            DateTime(2024, 5, 5),
            DateTime(2024, 4, 10),
          ],
        );

        // Includes current date
        expect(
          DateSchedule.yearly(months: [3, 10], days: [25, 26]).generate(3),
          [
            DateTime(2025, 3, 25),
            DateTime(2025, 3, 26),
            DateTime(2025, 10, 25),
          ],
        );
        expect(
          DateSchedule.yearly(months: [3, 10], days: [25, 26]).generate(-3),
          [
            DateTime(2025, 3, 25),
            DateTime(2024, 10, 26),
            DateTime(2024, 10, 25),
          ],
        );

        // Skips dates before anchor date
        expect(
          DateSchedule.yearly(months: [3, 10], days: [24, 26]).generate(3),
          [
            DateTime(2025, 3, 26),
            DateTime(2025, 10, 24),
            DateTime(2025, 10, 26),
          ],
        );
        // Skips dates after anchor date
        expect(
          DateSchedule.yearly(months: [3, 10], days: [24, 26]).generate(-3),
          [
            DateTime(2025, 3, 24),
            DateTime(2024, 10, 26),
            DateTime(2024, 10, 24),
          ],
        );

        // Interval test.
        expect(
          DateSchedule.yearly(
            months: [3, 10],
            days: [24, 26],
            interval: 2,
          ).generate(6),
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
      () {},
    );
  });
}
