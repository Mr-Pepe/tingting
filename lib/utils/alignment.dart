import 'dart:math';

import 'package:characters/characters.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class Aligner {
  final Characters original;
  final Characters query;
  final String placeholder;
  final int matchScore;
  final int mismatchScore;
  final int gapScore;
  final List<GlobalAlignment> alignments = [];
  List<List<int>> _scoreMatrix;
  List<List<int>> get scoreMatrix => _scoreMatrix;

  List<List<List<List<int>>>> _backtraceMatrix;

  int _maxScore;
  int get maxScore => _maxScore;

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
    initializeBacktraceMatrix();

    calculateScores();

    backtrace(
      [query.length, original.length],
      _backtraceMatrix[query.length][original.length],
      GlobalAlignment(original: ''.characters, query: ''.characters),
    );
  }

  backtrace(
    List<int> index,
    List<List<int>> parents,
    GlobalAlignment alignmentSoFar,
  ) {
    // Recursively backtrace through the score matrix
    if (parents.isEmpty) {
      alignments.add(GlobalAlignment(
          original: alignmentSoFar.original.toList().reversed.join().characters,
          query: alignmentSoFar.query.toList().reversed.join().characters));
    } else {
      for (var parent in parents) {
        if (parent[0] == index[0] - 1 && parent[1] == index[1] - 1) {
          alignmentSoFar = GlobalAlignment(
              original: alignmentSoFar.original +
                  original.elementAt(index[1] - 1).characters,
              query: alignmentSoFar.query +
                  query.elementAt(index[0] - 1).characters);
        } else if (parent[0] == index[0] - 1) {
          alignmentSoFar = GlobalAlignment(
              original: alignmentSoFar.original + placeholder.characters,
              query: alignmentSoFar.query +
                  query.elementAt(index[0] - 1).characters);
        } else if (parent[1] == index[1] - 1) {
          alignmentSoFar = GlobalAlignment(
              original: alignmentSoFar.original +
                  original.elementAt(index[1] - 1).characters,
              query: alignmentSoFar.query + placeholder.characters);
        }

        backtrace(
          parent,
          _backtraceMatrix[parent[0]][parent[1]],
          alignmentSoFar,
        );
      }
    }
  }

  initializeBacktraceMatrix() {
    _backtraceMatrix = List.generate(
      query.length + 1,
      (iRow) => List.generate(
        original.length + 1,
        (iColumn) {
          if (iRow == 0 && iColumn != 0) {
            return [
              [iColumn - 1, 0]
            ];
          } else if (iColumn == 0 && iRow != 0) {
            return [
              [iRow - 1, 0]
            ];
          } else {
            return [];
          }
        },
      ),
    );
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
        final possibleParents = [
          [i - 1, j - 1],
          [i - 1, j],
          [i, j - 1],
        ];

        int match = (query.elementAt(i - 1) == original.elementAt(j - 1))
            ? matchScore
            : mismatchScore;

        final possibleScores = [
          _scoreMatrix[i - 1][j - 1] + match,
          _scoreMatrix[i - 1][j] + gapScore,
          _scoreMatrix[i][j - 1] + gapScore
        ];

        final maxScore =
            max(max(possibleScores[0], possibleScores[1]), possibleScores[2]);

        _scoreMatrix[i][j] = maxScore;

        // Save where the maximum score came from to allow easier backtracing
        for (var iScore = 0; iScore < possibleScores.length; iScore++) {
          if (possibleScores[iScore] == maxScore) {
            _backtraceMatrix[i][j].add(possibleParents[iScore]);
          }
        }
      }
    }

    _maxScore = _scoreMatrix[query.length][original.length];
  }
}

class GlobalAlignment extends Equatable {
  final Characters original;
  final Characters query;

  GlobalAlignment({@required this.original, @required this.query});

  @override
  List<Object> get props => [original, query];
}
