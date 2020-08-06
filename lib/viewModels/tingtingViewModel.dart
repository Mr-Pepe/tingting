import 'dart:io';

import 'package:characters/characters.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tingting/utils/alignment.dart';

class TingTingViewModel extends ChangeNotifier {
  File _audioFile;
  get audioFilePath => _audioFile?.path ?? '';

  Duration _playerPosition;
  Duration get playerPosition => _playerPosition;

  Duration _playerDuration;
  Duration get playerDuration => _playerDuration;

  AudioPlayer player = AudioPlayer();

  String selfWrittenText = '';
  String originalText = '';

  Future<void> setAudioFile(File audioFile) async {
    _audioFile = audioFile;
    await player.setUrl(audioFilePath);
  }

  GlobalAlignment getDiff() {
    final aligner = Aligner(
        original: originalText.characters,
        query: selfWrittenText.characters,
        placeholder: '～');

    return aligner.alignments[0];
  }
}
