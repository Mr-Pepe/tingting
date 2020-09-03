import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tingting/ui/tingting.dart';
import 'package:tingting/ui/utils/loadingIndicator.dart';
import 'package:tingting/utils/getAudio.dart';
import 'package:tingting/utils/saveState.dart';
import 'package:tingting/values/enumsAndConstants.dart';
import 'package:tingting/values/strings.dart';
import 'package:tingting/viewModels/tingtingViewModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final saveState = SaveState();
  await saveState.init();

  runApp(TingTingApp(saveState));
}

class TingTingApp extends StatefulWidget {
  final SaveState saveState;

  TingTingApp(this.saveState);
  @override
  _TingTingAppState createState() => _TingTingAppState();
}

class _TingTingAppState extends State<TingTingApp> {
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
        create: (_) => TingTingViewModel(widget.saveState),
        child: Consumer<TingTingViewModel>(
          builder: (context, model, child) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Ting Ting"),
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
              ),
            );
          },
        ),
      ),
    );
  }
}
