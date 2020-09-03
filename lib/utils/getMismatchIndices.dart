import 'package:tingting/utils/globalAlignment.dart';
import 'package:tingting/values/enumsAndConstants.dart';

List<bool> getMismatchIndices(GlobalAlignment alignment) {
  return List.generate(alignment.original.length, (index) {
    final originalChar = alignment.original[index];
    final queryChar = alignment.query[index];

    if (!punctuation.contains(originalChar) &&
        !punctuation.contains(queryChar) &&
        (originalChar != queryChar)) {
      return true;
    } else {
      return false;
    }
  });
}
