import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tingting/utils/aligner.dart';
import 'package:tingting/utils/globalAlignment.dart';

class TingTingViewModel extends ChangeNotifier {
  String _audioFilePath;
  get audioFilePath => _audioFilePath;

  Duration _playerPosition;
  Duration get playerPosition => _playerPosition;

  Duration _playerDuration;
  Duration get playerDuration => _playerDuration;

  AudioPlayer player;

  String selfWrittenText = '';
  String originalText = '';

  String lastCheckedSelfWrittenText;
  String lastCheckedOriginalText;

  Future<GlobalAlignment> alignment;
  Future<bool> gettingAudio;

  Future<bool> setAudioFile(String path) async {
    try {
      player = AudioPlayer();
      await player.setUrl(path);

      _audioFilePath = path;
      notifyListeners();
      return true;
    } catch (e) {
      player = null;
      throw Exception(
          "Could not load $path.\n\nDid you try loading a file with '?' or '#' in its name?");
    }
  }

  getDiff() async {
    if (lastCheckedOriginalText != originalText ||
        lastCheckedSelfWrittenText != selfWrittenText) {
      lastCheckedOriginalText = originalText;
      lastCheckedSelfWrittenText = selfWrittenText;

      alignment = compute(align, [originalText, selfWrittenText]);
    }
  }
}

Future<GlobalAlignment> align(List<String> input) {
  return Future.value(Aligner(
    original: input[0],
    query: input[1],
    placeholder: ' ',
  ).alignment);
}
