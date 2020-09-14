import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tingting/utils/aligner.dart';
import 'package:tingting/utils/globalAlignment.dart';
import 'package:tingting/utils/saveState.dart';
import 'package:tingting/values/strings.dart';

class TingTingViewModel extends ChangeNotifier {
  TingTingViewModel(this._saveState) {
    _original = _saveState.original;
    _selfWritten = _saveState.selfWritten;
    if (_saveState.audioPath != '') {
      setAudioFile(_saveState.audioPath);
    }
  }

  final SaveState _saveState;

  String _audioFilePath;
  get audioFilePath => _audioFilePath;

  Duration _playerPosition;
  Duration get playerPosition => _playerPosition;

  Duration _playerDuration;
  Duration get playerDuration => _playerDuration;

  AudioPlayer player;

  String _selfWritten = '';
  String get selfWritten => _selfWritten;
  String _original = '';
  String get original => _original;

  String lastCheckedSelfWrittenText;
  String lastCheckedOriginalText;

  Future<GlobalAlignment> alignment;
  Future<bool> gettingAudio;

  Future<bool> setAudioFile(String path) async {
    try {
      player = AudioPlayer();
      await player.setUrl(path);

      _audioFilePath = path;
      _saveState.setAudioPath(path);

      notifyListeners();
      return true;
    } catch (e) {
      player = null;
      throw Exception(
          "Could not load $path.\n\nDid you try loading a file with '?' or '#' in its name? Does the file still exist?");
    }
  }

  getDiff() async {
    if (lastCheckedOriginalText != original ||
        lastCheckedSelfWrittenText != selfWritten) {
      lastCheckedOriginalText = original;
      lastCheckedSelfWrittenText = selfWritten;

      alignment = compute(
          align, [original.replaceAll(RegExp(r"\n+"), '\n'), selfWritten]);
    }
  }

  void setOriginal(String value) {
    _original = value;
    _saveState.setOriginal(value);
  }

  void setSelfWritten(String value) {
    _selfWritten = value;
    _saveState.setSelfWritten(value);
  }
}

Future<GlobalAlignment> align(List<String> input) {
  return Future.value(Aligner(
    original: input[0],
    query: input[1],
    placeholder: Strings.alignmentPlaceholder,
  ).alignment);
}
