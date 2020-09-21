import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tingting/ui/utils/notify.dart';
import 'package:tingting/values/enumsAndConstants.dart';
import 'package:tingting/values/strings.dart';
import 'package:tingting/viewModels/tingtingViewModel.dart';

getAudio(BuildContext context, TingTingViewModel model, int mode) async {
  switch (mode) {
    case AudioGenerationMode.fromFile:
      model.gettingAudio = getAudioFromFile(context, model);
      break;
    case AudioGenerationMode.fromText:
      model.gettingAudio = getAudioFromText(context, model);
      break;
    default:
      return true;
  }
}

Future<bool> getAudioFromFile(
    BuildContext context, TingTingViewModel model) async {
  final audioFile = await FilePicker.platform.pickFiles();

  if (audioFile != null) {
    return Future.value(
        model.setAudioFile(audioFile.paths.first).catchError((e) {
      notify(context, Strings.error, e.message);
    }));
  }

  return true;
}

Future<bool> getAudioFromText(
  BuildContext context,
  TingTingViewModel model,
) async {
  if (model.original.isEmpty) {
    notify(context, Strings.error, Strings.cantTtsBecauseOriginalEmpty);
    return Future.value(true);
  } else {
    final dirPath = (await getExternalStorageDirectory()).path;
    final filePath = Platform.isAndroid ? "tts.wav" : "tts.caf";

    await generateSpeechFromText(context, model, filePath);

    Stopwatch timer = Stopwatch();
    bool success = false;

    while (timer.elapsedMilliseconds < 10000 && !success) {
      await model.setAudioFile(dirPath + '/' + filePath).then((_) {
        success = true;
      }).catchError((e) {});

      if (success) {
        return Future.value(true);
      } else {
        await Future.delayed(const Duration(milliseconds: 300));
      }
    }

    return true;
  }
}

Future<bool> generateSpeechFromText(
  BuildContext context,
  TingTingViewModel model,
  String filePath,
) async {
  FlutterTts flutterTts = FlutterTts();

  final language = "zh-CN";

  if (!await flutterTts.isLanguageAvailable(language)) {
    notify(context, Strings.error, Strings.chineseTtsNotAvailable);
  } else {
    await flutterTts.setLanguage(language);

    await flutterTts.synthesizeToFile(model.original, filePath);
  }

  return true;
}
