import 'package:flutter_test/flutter_test.dart';
import 'package:tingting/utils/diffGrid.dart';
import 'package:tingting/utils/globalAlignment.dart';

void main() {
  test('Line mismatch indices show where lines include highlighted mistakes',
      () {
    final alignment = GlobalAlignment(
      original: 'ababab'.split(''),
      query: 'abacab'.split(''),
    );

    expect(DiffGrid(alignment, 2).lineMismatchIndices,
        equals([false, true, false]));
    expect(DiffGrid(alignment, 4).lineMismatchIndices, equals([true, false]));
  });

  test('Line count is the number of original/query/spacing line triplets', () {
    final alignment = GlobalAlignment(
      original: 'ababab'.split(''),
      query: 'abacab'.split(''),
    );

    expect(DiffGrid(alignment, 2).nLines, equals(3));
    expect(DiffGrid(alignment, 4).nLines, equals(2));
  });
}
