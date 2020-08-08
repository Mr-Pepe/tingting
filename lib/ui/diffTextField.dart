import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:tingting/utils/alignment.dart';
import 'package:tingting/values/colors.dart';
import 'package:tingting/values/dimensions.dart';
import 'package:tingting/viewModels/tingtingViewModel.dart';

class DiffTextField extends StatelessWidget {
  final coloredOriginal = <Container>[];
  final coloredQuery = <Container>[];
  final textStyle =
      TextStyle(fontSize: textFieldFontSize, color: generalTextColor);
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TingTingViewModel>(context);

    return FutureBuilder<GlobalAlignment>(
        future: model.alignment,
        builder: (context, alignment) {
          Widget widget;
          if (alignment.connectionState == ConnectionState.done) {
            if (!alignment.hasData ||
                (alignment.data.original.join() == '' &&
                    alignment.data.query.join() == '')) {
              widget = NoComparisonAvailable();
            } else {
              colorOriginalAndQuery(
                  alignment.data, coloredOriginal, coloredQuery, textStyle);
              widget = _getDiffBox(context);
            }
          } else if (alignment.hasError) {
            widget = Center(
              child: Text("Oops, something went wrong."),
            );
          } else if (alignment.connectionState == ConnectionState.none) {
            widget = NoComparisonAvailable();
          } else {
            widget = Center(
              child: SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
            );
          }

          return widget;
        });
  }

  Widget _getDiffBox(BuildContext context) {
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

                List<Container> interleavedLines = _interleaveOriginalAndQuery(
                    coloredOriginal, coloredQuery, nCharsPerLine);

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

  void colorOriginalAndQuery(GlobalAlignment alignment,
      List<Container> original, List<Container> query, TextStyle textStyle) {
    for (var iCharacter = 0;
        iCharacter < alignment.original.length;
        iCharacter++) {
      final originalChar = alignment.original.elementAt(iCharacter);
      final queryChar = alignment.query.elementAt(iCharacter);

      final backGroundColor =
          (originalChar == queryChar) ? Colors.transparent : Colors.red[200];

      original.add(
        Container(
            color: backGroundColor,
            child: Center(
                child: Text(
              originalChar,
              style: textStyle,
            ))),
      );
      query.add(
        Container(
            color: backGroundColor,
            child: Center(child: Text(queryChar, style: textStyle))),
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
}

class NoComparisonAvailable extends StatelessWidget {
  const NoComparisonAvailable({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          "No comparison available.\nIs there an original and a self-written text?",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
