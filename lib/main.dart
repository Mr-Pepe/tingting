import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:tingting/ui/loadingIndicator.dart';
import 'package:tingting/ui/notify.dart';
import 'package:tingting/ui/tingting.dart';
import 'package:tingting/values/enumsAndConstants.dart';
import 'package:tingting/values/strings.dart';
import 'package:tingting/viewModels/tingtingViewModel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int mode = -1;

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
                        setState(() {
                          this.mode = mode;
                          getAudio(context, model, mode);
                        });
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
                body: FutureBuilder(
                  future: model.gettingAudio,
                  builder: (context, snapshot) {
                    Widget widget;
                    if (snapshot.connectionState == ConnectionState.done ||
                        snapshot.connectionState == ConnectionState.none) {
                      widget = TingTing();
                    } else {
                      String text = '';
                      switch (mode) {
                        case AudioGenerationMode.fromFile:
                          text = Strings.loadingAudioFromFile;
                          break;
                        case AudioGenerationMode.fromText:
                          text = Strings.generatingAudio;
                          break;
                        default:
                      }
                      widget = loadingIndicator(text: text);
                    }

                    return widget;
                  },
                ));
          },
        ),
      ),
    );
  }
}

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
  final audioFile = await FilePicker.getFile();

  if (audioFile != null) {
    return Future.value(model.setAudioFile(audioFile.path).catchError((e) {
      notify(context, Strings.error, e.message);
    }));
  }

  return true;
}

Future<bool> getAudioFromText(
  BuildContext context,
  TingTingViewModel model,
) async {
  if (model.originalText.isEmpty) {
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

  if (!await flutterTts.isLanguageAvailable("zh-CN")) {
    notify(context, Strings.error, Strings.chineseTtsNotAvailable);
  } else {
    await flutterTts.setLanguage("zh-CN");

    await flutterTts.synthesizeToFile(model.originalText, filePath);
  }

  return true;
}
