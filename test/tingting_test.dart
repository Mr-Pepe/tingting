import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tingting/tingting.dart';
import 'package:tingting/values/strings.dart';

void main() {
  group('Check that UI elements are present', () {
    testWidgets(
      "There is a button to select an audio file",
      (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: TingTing()));
        final buttonFinder = find.text(Strings.chooseAudioFile);
        expect(buttonFinder, findsOneWidget);
      },
    );
  });
}
