import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:tingting/utils/audioSource.dart';

void main() {
  group('Test buffer audio source on synthetic data', () {
    final buffer = Uint8List.fromList(List.generate(1000, (index) => index));
    final audioSource = BufferAudioSource(buffer);

    test('Test stream request with start and end provided', () async {
      final response = await audioSource.request(10, 20);
      expect(response.sourceLength, equals(1000));
      expect(response.contentLength, equals(10));
      expect(response.offset, equals(10));
    });

    test('Test stream request without start and end provided', () async {
      final response = await audioSource.request();
      expect(response.sourceLength, equals(1000));
      expect(response.contentLength, equals(1000));
      expect(response.offset, equals(0));
    });
  });

  group('Test buffer audio source on real data', () {
    final file = File('test_resources/test.mp3');
    final buffer = file.readAsBytesSync();
    final audioSource = BufferAudioSource(buffer);

    test('Test stream request with start and end provided', () async {
      final response = await audioSource.request(10, 20);
      expect(response.sourceLength, equals(buffer.length));
      expect(response.contentLength, equals(10));
      expect(response.offset, equals(10));
    });

    test('Test stream request without start and end provided', () async {
      final response = await audioSource.request();
      expect(response.sourceLength, equals(buffer.length));
      expect(response.contentLength, equals(buffer.length));
      expect(response.offset, equals(0));
    });
  });
}
