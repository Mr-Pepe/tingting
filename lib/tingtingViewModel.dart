import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';

class TingTingViewModel extends ChangeNotifier {
  File _audioFile;
  get audioFilePath => _audioFile?.path ?? '';

  Duration _playerPosition;
  Duration get playerPosition => _playerPosition;

  Duration _playerDuration;
  Duration get playerDuration => _playerDuration;

  AudioPlayer player = AudioPlayer();

  Future<void> setAudioFile(File audioFile) async {
    _audioFile = audioFile;
    await player.setUrl(audioFilePath);
  }
}
