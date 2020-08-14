import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:tingting/ui/audioControls.dart';
import 'package:tingting/viewModels/tingtingViewModel.dart';

class MockTingTingViewModel extends Mock implements TingTingViewModel {}

class MockAudioPlayer extends Mock implements AudioPlayer {}

void main() {
  group('Test audio controls', () {
    Stream<Duration> durationStream = Stream.empty();
    Stream<double> volumeStream = Stream.empty();
    final player = MockAudioPlayer();
    final playerStateNotPlaying = PlayerState(false, null);

    when(player.durationStream).thenAnswer((_) => durationStream);
    when(player.volumeStream).thenAnswer((_) => volumeStream);

    testWidgets(
        'There are five buttons and a progress bar if the player is initialized',
        (WidgetTester tester) async {
      when(player.playerStateStream)
          .thenAnswer((_) => Stream<PlayerState>.value(playerStateNotPlaying));

      await _pumpWidget(tester, player);

      expect(find.byType(IconButton), findsNWidgets(5));
      expect(find.byType(ProgressBar), findsOneWidget);
    });

    testWidgets(
        'There are no buttons and no progressbar if the player is not initialized',
        (WidgetTester tester) async {
      when(player.playerStateStream)
          .thenAnswer((_) => Stream<PlayerState>.empty());

      await _pumpWidget(tester, player);

      expect(find.byType(IconButton), findsNothing);
      expect(find.byType(ProgressBar), findsNothing);
    });
  });
}

Future<void> _pumpWidget(WidgetTester tester, AudioPlayer player) async {
  await tester.pumpWidget(
    Provider<AudioPlayer>.value(
      value: player,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MaterialApp(
          home: Scaffold(
            body: AudioControls(),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
