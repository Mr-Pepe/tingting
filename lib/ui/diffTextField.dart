import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tingting/values/dimensions.dart';
import 'package:tingting/viewModels/tingtingViewModel.dart';

class DiffTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TingTingViewModel>(context);

    final alignment = model.getDiff();

    final originalTextSpans = <TextSpan>[];
    final queryTextSpans = <TextSpan>[];

    for (var iCharacter = 0;
        iCharacter < alignment.original.length;
        iCharacter++) {
      final originalChar = alignment.original.elementAt(iCharacter);
      final queryChar = alignment.query.elementAt(iCharacter);

      final backGroundColor =
          (originalChar == queryChar) ? Colors.green[200] : Colors.red[200];

      originalTextSpans.add(TextSpan(
          text: originalChar,
          style: TextStyle(
            backgroundColor: backGroundColor,
          )));
      queryTextSpans.add(TextSpan(
          text: queryChar,
          style: TextStyle(
            backgroundColor: backGroundColor,
          )));
    }
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(textFieldPadding),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor, width: 2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: textFieldPadding),
            child: Text.rich(
              TextSpan(children: [
                ...originalTextSpans,
                TextSpan(text: '\n'),
                ...queryTextSpans
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
