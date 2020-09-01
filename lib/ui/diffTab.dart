import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tingting/ui/diffBox.dart';
import 'package:tingting/ui/utils/loadingIndicator.dart';
import 'package:tingting/utils/globalAlignment.dart';
import 'package:tingting/values/strings.dart';
import 'package:tingting/viewModels/tingtingViewModel.dart';

class DiffTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TingTingViewModel>(context);

    return FutureBuilder<GlobalAlignment>(
        future: model.alignment,
        builder: (context, alignment) {
          Widget widget;
          if (alignment.connectionState == ConnectionState.done) {
            if (!alignment.hasData || alignment.data.isEmpty()) {
              widget = _noComparisonAvailable();
            } else {
              widget = DiffBox(alignment.data);
            }
          } else if (alignment.hasError) {
            widget = _somethingWentWrong();
          } else if (alignment.connectionState == ConnectionState.none) {
            widget = _noComparisonAvailable();
          } else {
            widget = loadingIndicator(text: Strings.generatingDiff);
          }

          return widget;
        });
  }
}

Widget _somethingWentWrong() {
  return Center(
    child: Text(Strings.oops),
  );
}

Widget _noComparisonAvailable() {
  return Center(
    child: Text(
      Strings.noComparisonAvailable,
      textAlign: TextAlign.center,
    ),
  );
}
