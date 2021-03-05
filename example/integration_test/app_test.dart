import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tingting/ui/audioControls/seekBar.dart';

import '../lib/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Load audio button is present and shows submenu",
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    final Finder loadAudioButton = find.byKey(Key('loadAudioButton'));

    expect(loadAudioButton, findsOneWidget);

    await tester.tap(loadAudioButton);

    await tester.pumpAndSettle();

    final Finder fromWeb = find.byKey(Key('loadAudioFromWebItem'));
    final Finder fromFile = find.byKey(Key('loadAudioFromFileItem'));

    expect(fromWeb, findsOneWidget);
    expect(fromFile, findsOneWidget);
  });
  testWidgets("Test audio controls and shortcuts", (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    final Finder loadAudioButton = find.byKey(Key('loadAudioButton'));

    expect(loadAudioButton, findsOneWidget);

    await tester.tap(loadAudioButton);
    await tester.pumpAndSettle();

    final Finder fromWeb = find.byKey(Key('loadAudioFromWebItem'));
    final Finder fromFile = find.byKey(Key('loadAudioFromFileItem'));

    expect(fromWeb, findsOneWidget);
    expect(fromFile, findsOneWidget);

    await tester.tap(fromWeb);
    await tester.pump(Duration(milliseconds: 50));

    final Finder urlField = find.byKey(Key('loadAudioFromWebUrlField'));
    final Finder okButton = find.byKey(Key('loadAudioFromWebOkButton'));
    final Finder cancelButton = find.byKey(Key('loadAudioFromWebCancelButton'));
    final Finder audioControls = find.byKey(Key('audioControls'));

    expect(urlField, findsOneWidget);
    expect(okButton, findsOneWidget);
    expect(cancelButton, findsOneWidget);
    expect(audioControls, findsNothing);

    await tester.enterText(urlField,
        'https://s3.amazonaws.com/scifri-episodes/scifri20201120-episode.mp3');

    await tester.tap(okButton);
    await tester.pumpAndSettle(Duration(milliseconds: 500));

    expect(audioControls, findsOneWidget);

    final Finder playButton = find.byKey(Key('playPauseButton'));
    final Finder backwardButton = find.byKey(Key('audioBackwardButton'));
    final Finder forwardButton = find.byKey(Key('audioForwardButton'));
    final Finder seekBar = find.byType(SeekBar);

    expect(playButton, findsOneWidget);
    expect(forwardButton, findsOneWidget);
    expect(backwardButton, findsOneWidget);
    expect(seekBar, findsOneWidget);

    double sliderPosition = _getSliderPosition(tester);
    expect(sliderPosition, equals(0));

    await tester.tap(playButton);
    await tester.pump(Duration(milliseconds: 1000));

    // Check play/pause button
    sliderPosition = _getSliderPosition(tester);
    expect(sliderPosition, greaterThan(0));
    await tester.tap(playButton);
    await tester.pump(Duration(milliseconds: 500));
    expect(_getSliderPosition(tester) - sliderPosition, lessThan(300));
    sliderPosition = _getSliderPosition(tester);

    // Test play/pause shortcut
    await tester.tap(find.byKey(Key('inputTab')));
    await tester.pumpAndSettle();
    await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    await tester.pump(Duration(milliseconds: 1000));
    expect(_getSliderPosition(tester) - sliderPosition, greaterThan(100));
    sliderPosition = _getSliderPosition(tester);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    await tester.pump(Duration(milliseconds: 500));
    expect(_getSliderPosition(tester) - sliderPosition, lessThan(300));
    sliderPosition = _getSliderPosition(tester);

    // Check skip forward button
    await tester.tap(forwardButton);
    await tester.pump(Duration(milliseconds: 500));
    expect(_getSliderPosition(tester) - sliderPosition, greaterThan(4000));
    sliderPosition = _getSliderPosition(tester);

    // Check skip backward button
    await tester.tap(backwardButton);
    await tester.pump(Duration(milliseconds: 500));
    expect(sliderPosition - _getSliderPosition(tester), greaterThan(4000));
    sliderPosition = _getSliderPosition(tester);

    // Check skip forward shortcut
    await tester.tap(find.byKey(Key('inputTab')));
    await tester.pumpAndSettle();
    await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyL);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    await tester.pump(Duration(milliseconds: 500));
    expect(_getSliderPosition(tester) - sliderPosition, greaterThan(4000));
    sliderPosition = _getSliderPosition(tester);

    // Check skip backward shortcut
    await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyJ);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    await tester.pump(Duration(milliseconds: 500));
    expect(sliderPosition - _getSliderPosition(tester), greaterThan(4000));
    sliderPosition = _getSliderPosition(tester);
  });
}

double _getSliderPosition(WidgetTester tester) {
  return (tester.widget(find.byType(SeekBar)) as SeekBar)
      .position
      .inMilliseconds
      .toDouble();
}
