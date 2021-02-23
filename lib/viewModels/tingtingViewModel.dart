import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tingting/utils/aligner.dart';
import 'package:tingting/utils/audioSource.dart';
import 'package:tingting/utils/globalAlignment.dart';
import 'package:tingting/utils/saveState.dart';
import 'package:tingting/values/enumsAndConstants.dart';
import 'package:tingting/values/strings.dart';

class TingTingViewModel extends ChangeNotifier {
  TingTingViewModel(this._saveState) {
    _original = _saveState.original;
    _selfWritten = _saveState.selfWritten;
    if (_saveState.audioPath != '' && _saveState.audioMode != -1) {
      setAudio(_saveState.audioPath, null, _saveState.audioMode);
    }
  }

  final SaveState _saveState;

  String _audioPath;
  get audioFilePath => _audioPath;

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

  Future<bool> setAudio(String path, Uint8List buffer, int mode) async {
    try {
      if (player == null) {
        player = AudioPlayer();
      }
      player.stop();
      if (mode == AudioGenerationMode.fromWeb) {
        await player.setUrl(path);
      } else {
        if (mode == AudioGenerationMode.fromFile) {
          await player.setFilePath(path);
        } else if (mode == AudioGenerationMode.fromBuffer) {
          await player.setAudioSource(BufferAudioSource(buffer));
        }
      }

      _audioPath = path;
      _saveState.setAudioPath(path, mode);

      notifyListeners();
      return true;
    } catch (e) {
      player = null;
      throw Exception("Could not load $path.");
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
    ignoreCase: true,
  ).alignment);
}
