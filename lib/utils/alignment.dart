import 'dart:math';

import 'package:flutter/widgets.dart';

class Aligner {
  final String original;
  final String query;
  final String placeholder;
  final int matchScore;
  final int mismatchScore;
  final int gapScore;
  final List<GlobalAlignment> alignments = [];
  List<List<int>> _scoreMatrix;
  List<List<int>> get scoreMatrix => _scoreMatrix;

  Aligner({
    @required this.original,
    @required this.query,
    this.placeholder = '-',
    this.matchScore = 1,
    this.mismatchScore = -1,
    this.gapScore = -1,
  }) {
    align();
  }

  // Align original and query using Needleman-Wunsch algorithm
  void align() {
    initializeScoreMatrix();

    calculateScores();
  }

  initializeScoreMatrix() {
    // Initialize first row and first column with gap scores, zero otherwise
    _scoreMatrix = List.generate(
      query.length + 1,
      (iRow) => List.generate(
        original.length + 1,
        (iColumn) {
          if (iRow == 0) {
            return iColumn * gapScore;
          } else if (iColumn == 0) {
            return iRow * gapScore;
          } else {
            return 0;
          }
        },
      ),
    );
  }

  calculateScores() {
    for (var i = 1; i < _scoreMatrix.length; i++) {
      for (var j = 1; j < _scoreMatrix[0].length; j++) {
        int match = _scoreMatrix[i - 1][j - 1];
        if ((query[i - 1] == original[j - 1])) {
          match += matchScore;
        } else {
          match += mismatchScore;
        }

        int delete = _scoreMatrix[i - 1][j] + gapScore;
        int insert = _scoreMatrix[i][j - 1] + gapScore;

        int score = max(delete, insert);
        score = max(score, match);

        _scoreMatrix[i][j] = score;
      }
    }
  }
}

class GlobalAlignment {
  final String original;
  final String query;

  GlobalAlignment({@required this.original, @required this.query});
}
