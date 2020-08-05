import 'package:flutter_test/flutter_test.dart';
import 'package:tingting/utils/alignment.dart';

void main() {
  final original = "CCATGAAU";
  final query = "GATTACA";

  final aligner = Aligner(
    original: original,
    query: query,
    matchScore: 1,
    mismatchScore: -1,
    gapScore: -1,
  );

  test('Alignment object saves the strings', () {
    expect(aligner.original, original);
    expect(aligner.query, query);
  });

  test('Score matrix has the correct size', () {
    expect(aligner.scoreMatrix.length, query.length + 1);

    for (var line in aligner.scoreMatrix) {
      expect(line.length, original.length + 1);
    }
  });

  test('Score matrix is correct', () {
    final scoreMatrix = [
      [0, -1, -2, -3, -4, -5, -6, -7, -8],
      [-1, -1, -2, -3, -4, -3, -4, -5, -6],
      [-2, -2, -2, -1, -2, -3, -2, -3, -4],
      [-3, -3, -3, -2, 0, -1, -2, -3, -4],
      [-4, -4, -4, -3, -1, -1, -2, -3, -4],
      [-5, -5, -5, -3, -2, -2, 0, -1, -2],
      [-6, -4, -4, -4, -3, -3, -1, -1, -2],
      [-7, -5, -5, -3, -4, -4, -2, 0, -1],
    ];

    for (var iLine = 0; iLine < aligner.scoreMatrix.length; iLine++) {
      for (var iValue = 0; iValue < original.length + 1; iValue++) {
        expect(aligner.scoreMatrix[iLine][iValue], scoreMatrix[iLine][iValue]);
      }
    }
  });
}
