import 'package:flutter/material.dart';
import 'package:tingting/utils/globalAlignment.dart';
import 'package:tingting/utils/interleaveOriginalAndQuery.dart';
import 'package:tingting/values/colors.dart';
import 'package:tingting/values/dimensions.dart';

class DiffGrid {
  List<Container> _gridAsList;
  List<bool> _lineMismatchIndices;
  get lineMismatchIndices => _lineMismatchIndices;

  DiffGrid(GlobalAlignment alignment, int nCharsPerLine) {
    final textStyle = TextStyle(
      fontSize: textFieldFontSize,
      color: generalTextColor,
    );

    final coloredOriginal = List.generate(
      alignment.original.length,
      (index) => Container(
          color: alignment.mismatchIndices[index]
              ? wrongCharacterBackgroundcolor
              : Colors.transparent,
          child: Center(
              child: Text(
            alignment.original[index],
            style: textStyle,
          ))),
    );

    final coloredQuery = List.generate(
      alignment.original.length,
      (index) => Container(
          color: alignment.mismatchIndices[index]
              ? wrongCharacterBackgroundcolor
              : Colors.transparent,
          child: Center(
              child: Text(
            alignment.query[index],
            style: textStyle,
          ))),
    );

    _gridAsList = interleaveOriginalAndQuery(
      coloredOriginal,
      coloredQuery,
      nCharsPerLine,
      addSpacing: true,
      lineBreakIndices: alignment.lineBreakIndices,
    );

    _lineMismatchIndices = List.generate(
        (_gridAsList.length / 3 / nCharsPerLine).ceil(),
        (iLine) => _gridAsList
            .skip(iLine * nCharsPerLine * 3)
            .take(nCharsPerLine)
            .any((container) =>
                container.color == wrongCharacterBackgroundcolor));
  }

  List<Container> asList() {
    return _gridAsList;
  }
}
