import 'package:flutter/foundation.dart';
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

  testWidgets("Audio controls show after loading audio from web",
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

    SeekBar seekBarWidget = tester.widget(seekBar);
    expect(seekBarWidget.position.inMilliseconds.toDouble(), equals(0));

    await tester.tap(playButton);
    await tester.pump(Duration(milliseconds: 500));

    seekBarWidget = tester.widget(seekBar);
    expect(seekBarWidget.position.inMilliseconds.toDouble(), greaterThan(0));
  });
}
