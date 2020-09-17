import 'package:flutter_test/flutter_test.dart';
import 'package:tingting/utils/diffGrid.dart';
import 'package:tingting/utils/globalAlignment.dart';

void main() {
  group('Line mismatch indices', () {
    test('', () {
      final alignment = GlobalAlignment(
        original: 'ababab'.split(''),
        query: 'abacab'.split(''),
      );

      expect(DiffGrid(alignment, 2).lineMismatchIndices,
          equals([false, true, false]));
      expect(DiffGrid(alignment, 4).lineMismatchIndices, equals([true, false]));
    });
  });
}
