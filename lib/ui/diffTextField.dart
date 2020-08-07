import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tingting/utils/alignment.dart';
import 'package:tingting/values/dimensions.dart';
import 'package:tingting/viewModels/tingtingViewModel.dart';

class DiffTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TingTingViewModel>(context);

    final alignment = model.getDiff();

    final coloredOriginal = <Container>[];
    final coloredQuery = <Container>[];

    colorOriginalAndQuery(alignment, coloredOriginal, coloredQuery);

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

                final cellSize = _getCellSize(context, constraints);

                final nCharsPerLine = (boxWidth / cellSize).floor().toInt();

                List<Container> interleavedLines = _interleaveOriginalAndQuery(
                    coloredOriginal, coloredQuery, nCharsPerLine);

                return GridView.count(
                  crossAxisCount: nCharsPerLine,
                  scrollDirection: Axis.vertical,
                  children: interleavedLines,
                );
              },
            )),
      ),
    );
  }

  void colorOriginalAndQuery(GlobalAlignment alignment,
      List<Container> original, List<Container> query) {
    for (var iCharacter = 0;
        iCharacter < alignment.original.length;
        iCharacter++) {
      final originalChar = alignment.original.elementAt(iCharacter);
      final queryChar = alignment.query.elementAt(iCharacter);

      final backGroundColor =
          (originalChar == queryChar) ? Colors.transparent : Colors.red[200];

      original.add(
        Container(
            color: backGroundColor, child: Center(child: Text(originalChar))),
      );
      query.add(
        Container(
            color: backGroundColor, child: Center(child: Text(queryChar))),
      );
    }
  }

  List<Container> _interleaveOriginalAndQuery(List<Container> originalTextSpans,
      List<Container> queryTextSpans, int nCharsPerLine) {
    final nLines = (originalTextSpans.length / nCharsPerLine).ceil().toInt();

    final out = <Container>[];

    for (var iLine = 0; iLine < nLines; iLine++) {
      for (var iChar = 0; iChar < nCharsPerLine; iChar++) {
        final index = iLine * nCharsPerLine + iChar;
        if (index < originalTextSpans.length) {
          out.add(originalTextSpans[index]);
        } else {
          out.add(Container());
        }
      }
      for (var iChar = 0; iChar < nCharsPerLine; iChar++) {
        final index = iLine * nCharsPerLine + iChar;
        if (index < queryTextSpans.length) {
          out.add(queryTextSpans[index]);
        } else {
          out.add(Container());
        }
      }
      for (var iChar = 0; iChar < nCharsPerLine; iChar++) {
        out.add(Container());
      }
    }

    return out;
  }

  double _getCellSize(BuildContext context, BoxConstraints constraints) {
    final richTextWidget =
        Text.rich(TextSpan(text: '你')).build(context) as RichText;
    final renderObject = richTextWidget.createRenderObject(context);

    renderObject.layout(constraints);

    final lastBox = renderObject
        .getBoxesForSelection(TextSelection(baseOffset: 0, extentOffset: 1))
        .last;

    return max(lastBox.bottom - lastBox.top, lastBox.right - lastBox.left);
  }
}
