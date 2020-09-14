import 'package:flutter/material.dart';
import 'package:tingting/values/strings.dart';

/// Takes two lists of containers and interleaves them into one list.
///
/// The resulting list alternates between [ncharsPerLine] elements of [original]
/// followed by [nCharsPerLine] elements of [query]. They are followed by
/// [nCharsPerline] empty containers if [addSpacing] is set to true.
/// If [lineBreakIndices] is provided, the lines are wrapped according to those
/// indices. An [ArgumentError] gets thrown if [original], [query] and
/// [lineBreakIndices] are not the same length.
List<Container> interleaveOriginalAndQuery(
  List original,
  List query,
  int nCharsPerLine, {
  List<bool> lineBreakIndices: const [],
  bool addSpacing: false,
}) {
  if (original.length != query.length) {
    throw ArgumentError('Original and query must be of same size.');
  }
  if (lineBreakIndices.isNotEmpty &&
      original.length != lineBreakIndices.length) {
    throw ArgumentError(
        'Original and line break indices must be of the same size.');
  }
  var iCharOriginal = 0;
  var iCharLine = 0;

  final rowOriginal = <Container>[];
  final rowQuery = <Container>[];
  final out = <Container>[];

  var fillUp = false;
  var fillUpNextTime = false;
  var lastLineWasSpacing = false;

  while (iCharOriginal < original.length || iCharLine < nCharsPerLine) {
    if (iCharLine == nCharsPerLine) {
      out.addAll(rowOriginal);
      out.addAll(rowQuery);
      rowOriginal.clear();
      rowQuery.clear();
      iCharLine = 0;
      fillUp = false;

      if (addSpacing && !lastLineWasSpacing) {
        out.addAll(List.generate(nCharsPerLine, (index) => Container()));
        lastLineWasSpacing = true;
      }
    }

    if (iCharOriginal >= original.length || fillUpNextTime) {
      fillUp = true;
      fillUpNextTime = false;
    } else if (lineBreakIndices.isNotEmpty && lineBreakIndices[iCharOriginal]) {
      if (query[iCharOriginal].child?.child?.data ==
          Strings.alignmentPlaceholder) {
        fillUp = true;
        iCharOriginal++;
      } else {
        fillUpNextTime = true;
      }
    }

    if (fillUp) {
      if (rowOriginal.isNotEmpty) {
        rowOriginal.add(Container());
        rowQuery.add(Container());
      }
    } else {
      rowOriginal.add(original[iCharOriginal]);
      rowQuery.add(query[iCharOriginal]);
      iCharOriginal++;
      lastLineWasSpacing = false;
    }

    iCharLine++;
  }

  return out + rowOriginal + rowQuery;
}
