import 'dart:typed_data';

import 'package:just_audio/just_audio.dart';

class MyAudioSource extends StreamAudioSource {
  Uint8List _buffer;

  MyAudioSource(this._buffer) : super("Bla");

  @override
  Future<StreamAudioResponse> request([int start, int end]) {
    return Future.value(
      StreamAudioResponse(
        sourceLength: _buffer.length,
        contentLength: end - start,
        offset: 0,
        stream: Stream.value(_buffer.skip(start).take(end-start)),
      ),
    );
  }
}
