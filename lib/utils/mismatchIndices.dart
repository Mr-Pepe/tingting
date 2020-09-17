import 'package:tingting/values/enumsAndConstants.dart';

List<bool> getCharacterMismatchIndices(
  List<String> original,
  List<String> query, {
  bool countPunctuationErrors = true,
}) {
  return List.generate(original.length, (index) {
    final originalChar = original[index];
    final queryChar = query[index];

    if (countPunctuationErrors) {
      return originalChar != queryChar;
    } else {
      return !punctuation.contains(originalChar) &&
          !punctuation.contains(queryChar) &&
          (originalChar != queryChar);
    }
  });
}

/// Receives character mismatch indices and the number of characters per line
/// and returns a boolean list with lines having mismatched characters being
/// true
List<bool> getLineMismatchIndices(
  List<bool> characterMismatchIndices,
  int nCharsPerLine,
) {
  final nLines = (characterMismatchIndices.length / nCharsPerLine).ceil();
  return List.generate(
      nLines,
      (iLine) => characterMismatchIndices
          .skip(iLine * nCharsPerLine)
          .take(nCharsPerLine)
          .any((e) => e));
}
