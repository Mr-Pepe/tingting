import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:tingting/ui/tingting.dart';
import 'package:tingting/values/enumsAndConstants.dart';
import 'package:tingting/values/strings.dart';
import 'package:tingting/viewModels/tingtingViewModel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChangeNotifierProvider<TingTingViewModel>(
        create: (_) => TingTingViewModel(),
        child: Consumer<TingTingViewModel>(
          builder: (context, model, child) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Ting Ting the Ting Li Trainer"),
                actions: [
                  PopupMenuButton(
                    icon: Icon(Icons.music_note),
                    onSelected: (mode) {
                      _getAudio(context, model, mode);
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          value: AudioGenerationMode.fromFile,
                          child: Text(Strings.fromFile),
                        ),
                        PopupMenuItem(
                          value: AudioGenerationMode.fromText,
                          child: Text(Strings.fromText),
                        ),
                      ];
                    },
                  )
                ],
              ),
              body: TingTing(),
            );
          },
        ),
      ),
    );
  }

  _getAudio(BuildContext context, TingTingViewModel model, int mode) async {
    switch (mode) {
      case AudioGenerationMode.fromFile:
        _getAudioFromFile(context, model);
        break;
      case AudioGenerationMode.fromText:
        _getAudioFromText(context, model);
        break;
      default:
    }
  }

  _getAudioFromFile(BuildContext context, TingTingViewModel model) async {
    final audioFile = await FilePicker.getFile();
    if (audioFile != null) {
      model.setAudioFile(audioFile.path).catchError((e) {
        _notify(context, Strings.error, e.message);
      });
    }
  }

  _getAudioFromText(BuildContext context, TingTingViewModel model) async {
    if (model.originalText.isEmpty) {
      _notify(context, Strings.error, Strings.cantTtsBecauseOriginalEmpty);
    } else {
      final dirPath = (await getExternalStorageDirectory()).path;
      final filePath = Platform.isAndroid ? "tts.wav" : "tts.caf";

      await _generateSpeechFromText(context, model, filePath);

      Stopwatch timer = Stopwatch();
      bool success = false;

      while (timer.elapsedMilliseconds < 10000 && !success) {
        await model.setAudioFile(dirPath + '/' + filePath).then((_) {
          success = true;
        }).catchError((e) {
          success = false;
        });
      }
    }
  }

  Future<bool> _generateSpeechFromText(
    BuildContext context,
    TingTingViewModel model,
    String filePath,
  ) async {
    FlutterTts flutterTts = FlutterTts();

    if (!await flutterTts.isLanguageAvailable("zh-CN")) {
      _notify(context, Strings.error, Strings.chineseTtsNotAvailable);
    } else {
      await flutterTts.setLanguage("zh-CN");

      await flutterTts.synthesizeToFile(model.originalText, filePath);
    }

    return true;
  }

  _notify(BuildContext context, String heading, String body) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(heading),
          content: Text(body),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(Strings.close))
          ],
        );
      },
    );
  }
}
