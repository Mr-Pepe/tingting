import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mockito/mockito.dart';
import 'package:tingting/utils/audio.dart';

class MockAudioPlayer extends Mock implements AudioPlayer {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Test play pause toggle', () {
    test('Does not crash if player is null', () {
      togglePlayPause(null);
    });
  });
}
