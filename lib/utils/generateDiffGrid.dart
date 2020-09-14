import 'package:flutter/material.dart';
import 'package:tingting/utils/globalAlignment.dart';
import 'package:tingting/utils/interleaveOriginalAndQuery.dart';
import 'package:tingting/values/colors.dart';
import 'package:tingting/values/dimensions.dart';

List<Container> generateDiffGrid(GlobalAlignment alignment, int nCharsPerLine) {
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

  return interleaveOriginalAndQuery(
    coloredOriginal,
    coloredQuery,
    nCharsPerLine,
    addSpacing: true,
    lineBreakIndices: alignment.lineBreakIndices,
  );
}
