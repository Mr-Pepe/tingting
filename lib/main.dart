import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
        final audioFile = await FilePicker.getFile();
        if (audioFile != null) {
          model.setAudioFile(audioFile.path).catchError((e) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Error"),
                  content: Text(e.message),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Close"))
                  ],
                );
              },
            );
          });
        }
        break;
      default:
    }
  }
}
