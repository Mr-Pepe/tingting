import 'dart:typed_data';

import 'package:just_audio/just_audio.dart';

class MyAudioSource extends StreamAudioSource {
  Uint8List _buffer;

  MyAudioSource(this._buffer) : super("Bla");

  @override
  Stream<List<int>> read([int start, int end]) {
    return Stream.value(_buffer.skip(start).take(end - start));
  }

  @override
  int get lengthInBytes {
    return _buffer.length;
  }
}
