import 'package:flutter/material.dart';

List<Container> interleaveOriginalAndQuery(
  List<Container> originalContainers,
  List<Container> queryContainers,
  int nCharsPerLine, {
  List<int> lineBreaks: const [],
  bool addSpacing: false,
}) {
  var iCharOriginal = 0;
  var iCharLine = 0;

  final rowOriginal = <Container>[];
  final rowQuery = <Container>[];
  final out = <Container>[];

  var fillUp = false;

  while (iCharOriginal < originalContainers.length) {
    if (iCharLine == nCharsPerLine) {
      out.addAll(rowOriginal);
      out.addAll(rowQuery);
      rowOriginal.clear();
      rowQuery.clear();
      iCharLine = 0;
      fillUp = false;

      if (addSpacing) {
        out.addAll(List.generate(nCharsPerLine, (index) => Container()));
      }
    }

    if (lineBreaks.contains(iCharOriginal)) {
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
    }

    iCharLine++;
  }

  return out + rowOriginal + rowQuery;
}
