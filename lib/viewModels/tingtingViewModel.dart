import 'dart:io';

import 'package:characters/characters.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tingting/utils/alignment.dart';

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

  Future<void> setAudioFile(String path) async {
    _audioFilePath = path;
    player = AudioPlayer();
    await player.setUrl(path);

    notifyListeners();
  }

  GlobalAlignment getDiff() {
    final aligner = Aligner(
        original: originalText.characters,
        query: selfWrittenText.characters,
        placeholder: '～');

    return aligner.alignments[0];
  }
}
