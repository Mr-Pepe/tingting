import 'package:flutter_test/flutter_test.dart';
import 'package:tingting/utils/getMismatchIndices.dart';
import 'package:tingting/values/enumsAndConstants.dart';

void main() {
  test('Returns a list of booleans being true where the two lists mismatch',
      () {
    expect(getMismatchIndices(['a', 'b', 'c'], ['a', 'c', 'c']),
        equals([false, true, false]));
  });

  test('Punctuation does not count as mismatch if it should be ignored', () {
    for (var char in punctuation) {
      expect(
          getMismatchIndices(['a', char], ['a', 'a'],
              countPunctuationErrors: true),
          equals([false, true]));
      expect(
          getMismatchIndices(['a', char], ['a', 'a'],
              countPunctuationErrors: false),
          equals([false, false]));
    }
  });
}
