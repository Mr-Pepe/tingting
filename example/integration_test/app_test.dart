import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../lib/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Test UI', () {
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
      final Finder cancelButton =
          find.byKey(Key('loadAudioFromWebCancelButton'));
      final Finder audioControls = find.byKey(Key('audioControls'));

      expect(urlField, findsOneWidget);
      expect(okButton, findsOneWidget);
      expect(cancelButton, findsOneWidget);
      expect(audioControls, findsNothing);

      await tester.enterText(urlField,
          'https://s3.amazonaws.com/scifri-episodes/scifri20201120-episode.mp3');

      await tester.tap(okButton);
      await tester.pumpAndSettle();

      expect(audioControls, findsOneWidget);
    });
  });
}
