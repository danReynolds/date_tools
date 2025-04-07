import 'package:date_tools/extensions/list.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Utils', () {
    test('skipWhileLessThan', () {
      expect(<int>[].skipWhileLessThan(3), []);
      expect([1, 2].skipWhileLessThan(3), []);
      expect([1, 2, 3].skipWhileLessThan(3), [3]);
      expect([1, 2, 3, 4, 5].skipWhileLessThan(3), [3, 4, 5]);
    });

    test('skipWhileGreaterThan', () {
      expect(<int>[].skipWhileGreaterThan(3), []);
      expect([2, 1].skipWhileGreaterThan(3), [2, 1]);
      expect([3, 2, 1].skipWhileGreaterThan(3), [3, 2, 1]);
      expect([5, 4, 3, 2, 1].skipWhileGreaterThan(3), [3, 2, 1]);
    });
  });
}
