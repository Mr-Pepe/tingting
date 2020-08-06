import 'package:characters/characters.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tingting/utils/alignment.dart';

void main() {
  group('Test algorithm', () {
    final original = "CCATGAAU";
    final query = "GATTACA";
    final aligner = Aligner(
      original: original.characters,
      query: query.characters,
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

    test('Number of optimal alignments is correct', () {
      expect(aligner.alignments.length, 2);
    });

    test('Alignments are correct', () {
      expect(
          aligner.alignments.contains(GlobalAlignment(
              original: 'CCATGA-AU'.characters, query: '-GATTACA-'.characters)),
          true);
      expect(
          aligner.alignments.contains(GlobalAlignment(
              original: 'CCCATGA-AU'.characters,
              query: 'G-GATTACA-'.characters)),
          true);
    });
  });

  test('Aligner returns empty alignment if one of the strings is empty', () {
    final original = ['abc', ''];
    final query = ['', 'abc'];

    for (var i = 0; i < original.length; i++) {
      final aligner =
          Aligner(original: original[i].characters, query: query[i].characters);

      expect(aligner.alignments.length, 1);
      expect(
        aligner.alignments[0],
        GlobalAlignment(original: ''.characters, query: ''.characters),
      );
    }
  });
}
