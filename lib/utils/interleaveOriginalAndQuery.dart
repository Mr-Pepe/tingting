import 'package:flutter/material.dart';

/// Takes two lists and merges them into one list. The resulting list alternates
/// between [ncharsPerLine] elements of [originalContainers] followed by
/// [nCharsPerLine] elements of [queryContainers].
/// They are followed by [nCharsPerline] empty containers if [addSpacing] is set
/// to true.
/// If [lineBreakIndices] is provided, the lines are wrapped according to those
/// indices.
/// An [ArgumentError] gets thrown if [originalContainer], [queryContainers] and
/// [lineBreakIndices] are not the same length.
List<Container> interleaveOriginalAndQuery(
  List<Container> originalContainers,
  List<Container> queryContainers,
  int nCharsPerLine, {
  List<bool> lineBreakIndices: const [],
  bool addSpacing: false,
}) {
  if (originalContainers.length != queryContainers.length) {
    throw ArgumentError('Original and query must be of same size.');
  }
  if (lineBreakIndices.isNotEmpty &&
      originalContainers.length != lineBreakIndices.length) {
    throw ArgumentError(
        'Original and line break indices must be of the same size.');
  }
  var iCharOriginal = 0;
  var iCharLine = 0;

  final rowOriginal = <Container>[];
  final rowQuery = <Container>[];
  final out = <Container>[];

  var fillUp = false;
  var lastLineWasSpacing = false;

  while (
      iCharOriginal < originalContainers.length || iCharLine < nCharsPerLine) {
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

    if (iCharOriginal >= originalContainers.length ||
        lineBreakIndices.isNotEmpty && lineBreakIndices[iCharOriginal]) {
      fillUp = true;
      iCharOriginal++;
    }

    if (fillUp) {
      if (rowOriginal.isNotEmpty) {
        rowOriginal.add(Container());
        rowQuery.add(Container());
      }
    } else {
      rowOriginal.add(originalContainers[iCharOriginal]);
      rowQuery.add(queryContainers[iCharOriginal]);
      iCharOriginal++;
      lastLineWasSpacing = false;
    }

    iCharLine++;
  }

  return out + rowOriginal + rowQuery;
}
