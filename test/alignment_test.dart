import 'package:flutter_test/flutter_test.dart';
import 'package:tingting/utils/alignment.dart';

void main() {
  group('Test algorithm', () {
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
      expect(aligner.original.toString(), original);
      expect(aligner.query.toString(), query);
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
          expect(
              aligner.scoreMatrix[iLine][iValue], scoreMatrix[iLine][iValue]);
        }
      }
    });

    test('Best score is correct', () {
      expect(aligner.maxScore, -1);
    });

    test('Alignment is non-null', () {
      expect(aligner.alignment == null, false);
    });

    test('Alignment is correct', () {
      expect(aligner.alignment.original.join(), 'CCATGA-AU');
      expect(aligner.alignment.query.join(), 'G-ATTACA-');
    });
  });

  test('Aligner returns null if one of the strings is empty', () {
    final original = ['abc', ''];
    final query = ['', 'abc'];

    for (var i = 0; i < original.length; i++) {
      final aligner = Aligner(original: original[i], query: query[i]);

      expect(aligner.alignment.original.join(), '');
      expect(aligner.alignment.query.join(), '');
    }
  });

  test('Backtrace matrix gets initialized correctly', () {
    final original = "aaaa";
    final query = "b";

    final aligner = Aligner(original: original, query: query);

    expect(aligner.backtraceMatrix[0][0].isEmpty, true);
    expect(aligner.backtraceMatrix[0][1], equals([0, 0]));
    expect(aligner.backtraceMatrix[0][2], equals([0, 1]));
    expect(aligner.backtraceMatrix[1][0], equals([0, 0]));
  });
}
