import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tingting/utils/globalAlignment.dart';
import 'package:tingting/utils/interleaveOriginalAndQuery.dart';
import 'package:tingting/values/colors.dart';
import 'package:tingting/values/dimensions.dart';

class DiffBox extends StatelessWidget {
  DiffBox(this.alignment);

  final GlobalAlignment alignment;

  final coloredOriginal = <Container>[];
  final coloredQuery = <Container>[];
  final textStyle =
      TextStyle(fontSize: textFieldFontSize, color: generalTextColor);

  @override
  Widget build(BuildContext context) {
    _colorOriginalAndQuery();

    return Container(
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor, width: 2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: textFieldPadding),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final boxWidth = constraints.maxWidth;

                final cellSize = _getCellSize(context, constraints, textStyle);

                final nCharsPerLine = (boxWidth / cellSize).floor().toInt();

                List<int> lineBreaks = [];
                alignment.original.asMap().forEach((key, value) {
                  if (value == '\n') lineBreaks.add(key);
                });

                List<Container> interleavedLines = interleaveOriginalAndQuery(
                  coloredOriginal,
                  coloredQuery,
                  nCharsPerLine,
                  addSpacing: true,
                  lineBreaks: lineBreaks,
                );

                return StaggeredGridView.countBuilder(
                  itemCount: interleavedLines.length,
                  crossAxisCount: nCharsPerLine,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) => interleavedLines[index],
                  staggeredTileBuilder: (index) => StaggeredTile.count(
                      1, ((index / nCharsPerLine).floor() % 3) == 2 ? 0.5 : 1),
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                );
              },
            )),
      ),
    );
  }

  void _colorOriginalAndQuery() {
    for (var iCharacter = 0;
        iCharacter < alignment.original.length;
        iCharacter++) {
      final originalChar = alignment.original[iCharacter];
      final queryChar = alignment.query[iCharacter];

      var backGroundColor = Colors.transparent;

      final punctuation = ['.', '，', '。', '\n', '、'];

      if (!punctuation.contains(originalChar) &&
          !punctuation.contains(queryChar) &&
          (originalChar != queryChar)) {
        backGroundColor = wrongCharacterBackgroundcolor;
      }

      coloredOriginal.add(
        Container(
            color: backGroundColor,
            child: Center(
                child: Text(
              originalChar,
              style: textStyle,
            ))),
      );

      coloredQuery.add(
        Container(
            color: backGroundColor,
            child: Center(child: Text(queryChar, style: textStyle))),
      );
    }
  }
}

double _getCellSize(
    BuildContext context, BoxConstraints constraints, TextStyle textStyle) {
  final richTextWidget = Text.rich(TextSpan(text: '你', style: textStyle))
      .build(context) as RichText;
  final renderObject = richTextWidget.createRenderObject(context);

  renderObject.layout(constraints);

  final lastBox = renderObject
      .getBoxesForSelection(TextSelection(baseOffset: 0, extentOffset: 1))
      .last;

  return max(lastBox.bottom - lastBox.top, lastBox.right - lastBox.left);
}
