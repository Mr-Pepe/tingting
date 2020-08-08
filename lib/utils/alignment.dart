import 'dart:math';

import 'package:characters/characters.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class Aligner {
  List<String> _original;
  String get original => _original.join();
  List<String> _query;
  String get query => _query.join();
  final String placeholder;
  final int matchScore;
  final int mismatchScore;
  final int gapScore;
  GlobalAlignment _alignment;
  GlobalAlignment get alignment => _alignment;
  List<List<int>> _scoreMatrix;
  List<List<int>> get scoreMatrix => _scoreMatrix;

  List<List<List<List<int>>>> _backtraceMatrix;
  get backtraceMatrix => _backtraceMatrix;

  int _maxScore;
  int get maxScore => _maxScore;

  Aligner({
    @required String original,
    @required String query,
    this.placeholder = '-',
    this.matchScore = 1,
    this.mismatchScore = -1,
    this.gapScore = -1,
    debug = false,
  }) {
    _original = original.characters.toList(growable: false);
    _query = query.characters.toList(growable: false);

    if (_original.isNotEmpty && _query.isNotEmpty) {
      //Align original and query using Needleman-Wunsch algorithm
      Stopwatch stopwatch = Stopwatch()..start();
      initializeScoreMatrix();

      if (debug) {
        print(
            "Score matrix initialization took ${stopwatch.elapsedMilliseconds}ms");
      }

      stopwatch.reset();
      initializeBacktraceMatrix();

      if (debug) {
        print(
            "Backtrace matrix initialization took ${stopwatch.elapsedMilliseconds}ms");
      }

      stopwatch.reset();
      calculateScores();

      if (debug) {
        print("Calculating scores took ${stopwatch.elapsedMilliseconds}ms");
      }

      stopwatch.reset();
      backtrace();

      if (debug) {
        print("Backtracing took ${stopwatch.elapsedMilliseconds}ms");
      }
    }
  }

  backtrace() {
    List<int> index = [_query.length, _original.length];
    List<List<int>> parents = _backtraceMatrix[_query.length][_original.length];

    final List<String> alignedOriginal = [];
    final List<String> alignedQuery = [];

    while (parents.isNotEmpty) {
      final parent = parents[0];
      final up = parent[0] == index[0] - 1;
      final left = parent[1] == index[1] - 1;

      if (up && left) {
        alignedOriginal.add(_original[index[1] - 1]);
        alignedQuery.add(_query[index[0] - 1]);
      } else if (up) {
        alignedOriginal.add(placeholder);
        alignedQuery.add(_query[index[0] - 1]);
      } else if (left) {
        alignedOriginal.add(_original[index[1] - 1]);
        alignedQuery.add(placeholder);
      }
      index = parent;
      parents = _backtraceMatrix[parent[0]][parent[1]];
    }
    _alignment = GlobalAlignment(
        original: alignedOriginal.reversed.toList(),
        query: alignedQuery.reversed.toList());
  }

  initializeBacktraceMatrix() {
    _backtraceMatrix = List.generate(
      _query.length + 1,
      (iRow) => List.generate(
        _original.length + 1,
        (iColumn) {
          if (iRow == 0 && iColumn != 0) {
            return [
              [0, iColumn - 1]
            ];
          } else if (iColumn == 0 && iRow != 0) {
            return [
              [0, iRow - 1]
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
      _query.length + 1,
      (iRow) => List.generate(
        _original.length + 1,
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
        // The order of entries is important, because only the first candidate
        // gets used during backtracing.
        // Putting the diagonal entry to the end, pushes gaps to the end
        // of the alignment
        final possibleParents = [
          [i - 1, j],
          [i, j - 1],
          [i - 1, j - 1],
        ];

        int match =
            (_query[i - 1] == _original[j - 1]) ? matchScore : mismatchScore;

        final possibleScores = [
          _scoreMatrix[i - 1][j] + gapScore,
          _scoreMatrix[i][j - 1] + gapScore,
          _scoreMatrix[i - 1][j - 1] + match,
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

    _maxScore = _scoreMatrix[_query.length][_original.length];
  }
}

class GlobalAlignment extends Equatable {
  final List<String> original;
  final List<String> query;

  GlobalAlignment({@required this.original, @required this.query});

  @override
  List<Object> get props => [original, query];
}
