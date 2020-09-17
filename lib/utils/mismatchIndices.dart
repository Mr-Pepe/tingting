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
