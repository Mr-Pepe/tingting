import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:tingting/ui/audioControls/audioControls.dart';
import 'package:tingting/viewModels/tingtingViewModel.dart';

class MockTingTingViewModel extends Mock implements TingTingViewModel {}

class MockAudioPlayer extends Mock implements AudioPlayer {}

void main() {
  group('Test audio controls', () {
    Stream<Duration> durationStream = Stream.empty();
    Stream<double> volumeStream = Stream.empty();
    final player = MockAudioPlayer();
    final playerStateNotPlaying = PlayerState(false, null);
    final playerStatePlaying = PlayerState(true, null);
    final playerStateCompleted = PlayerState(true, ProcessingState.completed);

    when(player.durationStream).thenAnswer((_) => durationStream);
    when(player.volumeStream).thenAnswer((_) => volumeStream);

    testWidgets(
        'There are volume, replay 5s, play, forward 5s, and speed buttons',
        (WidgetTester tester) async {
      when(player.playerStateStream)
          .thenAnswer((_) => Stream<PlayerState>.value(playerStateNotPlaying));

      await _pumpWidget(tester, player);

      expect(find.byIcon(Icons.volume_up), findsOneWidget);
      expect(find.byIcon(Icons.replay_5), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      expect(find.byIcon(Icons.forward_5), findsOneWidget);
      expect(find.byKey(Key('adjust speed button')), findsOneWidget);
    });

    testWidgets('There is a progress bar if the player is initialized',
        (WidgetTester tester) async {
      when(player.playerStateStream)
          .thenAnswer((_) => Stream<PlayerState>.value(playerStateNotPlaying));

      await _pumpWidget(tester, player);

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

    testWidgets(
        'Center button shows play, pause, replay according to player state',
        (WidgetTester tester) async {
      final playerStateStreamController = StreamController<PlayerState>();
      // Stream<PlayerState>.value(playerStateNotPlaying);

      playerStateStreamController.add(playerStateNotPlaying);

      when(player.playerStateStream)
          .thenAnswer((_) => playerStateStreamController.stream);

      await _pumpWidget(tester, player);

      expect(find.byIcon(Icons.play_arrow), findsOneWidget);

      playerStateStreamController.add(playerStatePlaying);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.pause), findsOneWidget);

      playerStateStreamController.add(playerStateCompleted);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.replay), findsOneWidget);

      playerStateStreamController.close();
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
