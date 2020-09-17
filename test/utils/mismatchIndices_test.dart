import 'package:flutter_test/flutter_test.dart';
import 'package:tingting/utils/mismatchIndices.dart';
import 'package:tingting/values/enumsAndConstants.dart';

void main() {
  group('Character mismatch', () {
    test('Returns a list of booleans being true where the two lists mismatch',
        () {
      expect(getCharacterMismatchIndices(['a', 'b', 'c'], ['a', 'c', 'c']),
          equals([false, true, false]));
    });

    test('Punctuation does not count as mismatch if it should be ignored', () {
      for (var char in punctuation) {
        expect(
            getCharacterMismatchIndices(['a', char], ['a', 'a'],
                countPunctuationErrors: true),
            equals([false, true]));
        expect(
            getCharacterMismatchIndices(['a', char], ['a', 'a'],
                countPunctuationErrors: false),
            equals([false, false]));
      }
    });
  });

  group('Line mismatch', () {
    final original = 'abababababc'.split('');
    final query = 'abacabacabc'.split('');
    final nCharsPerLine = 2;

    final characterMismatchIndices =
        getCharacterMismatchIndices(original, query);

    test('Returns a list of booleans being true where a line has a mismatch',
        () {
      expect(getLineMismatchIndices(characterMismatchIndices, nCharsPerLine),
          equals([false, true, false, true, false, false]));
    });
  });
}
