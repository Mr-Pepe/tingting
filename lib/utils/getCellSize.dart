import 'dart:math';

import 'package:flutter/material.dart';

double getCellSize(
  BuildContext context,
  BoxConstraints constraints,
  TextStyle textStyle,
  String character,
) {
  final richTextWidget = Text.rich(TextSpan(text: character, style: textStyle))
      .build(context) as RichText;
  final renderObject = richTextWidget.createRenderObject(context);

  renderObject.layout(constraints);

  final lastBox = renderObject
      .getBoxesForSelection(TextSelection(baseOffset: 0, extentOffset: 1))
      .last;

  return max(lastBox.bottom - lastBox.top, lastBox.right - lastBox.left);
}
