import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tingting/ui/diffTab.dart';
import 'package:tingting/ui/inputTab.dart';
import 'package:tingting/ui/originalTab.dart';
import 'package:tingting/ui/audioControls/audioControls.dart';
import 'package:tingting/ui/utils/loadingIndicator.dart';
import 'package:tingting/utils/audio.dart';
import 'package:tingting/utils/intents.dart';
import 'package:tingting/values/dimensions.dart';
import 'package:tingting/values/enumsAndConstants.dart';
import 'package:tingting/values/strings.dart';
import 'package:tingting/viewModels/tingtingViewModel.dart';

class TingTing extends StatefulWidget {
  final String title;

  TingTing({Key key, this.title: ''}) : super(key: key);

  @override
  _TingTingState createState() => _TingTingState();
}

class _TingTingState extends State<TingTing>
    with SingleTickerProviderStateMixin {
  final List<Tab> tabLabels = <Tab>[
    Tab(text: Strings.tabYours),
    Tab(text: Strings.tabDiff),
    Tab(text: Strings.tabOriginal),
  ];

  FocusNode inputFocusNode;
  FocusNode originalFocusNode;

  TabController _tabController;

  TingTingViewModel model;

  int audioMode = -1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabLabels.length);
    _tabController.addListener(() {
      switch (_tabController.index) {
        case 0:
          inputFocusNode.requestFocus();
          break;
        case 1:
          inputFocusNode.unfocus();
          originalFocusNode.unfocus();
          model?.getDiff();
          break;
        case 2:
          originalFocusNode.requestFocus();
          break;
        default:
      }
    });

    inputFocusNode = FocusNode();
    originalFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _tabController.dispose();
    inputFocusNode.dispose();
    originalFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    model = Provider.of<TingTingViewModel>(context);

    return FocusableActionDetector(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.keyK):
            const PlayPauseIntent(),
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.keyJ):
            const SkipBackwardIntent(),
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.keyL):
            const SkipForwardIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          PlayPauseIntent: CallbackAction<PlayPauseIntent>(
              onInvoke: (PlayPauseIntent intent) {
            return togglePlayPause(model.player);
          }),
          SkipBackwardIntent: CallbackAction<SkipBackwardIntent>(
              onInvoke: (SkipBackwardIntent intent) {
            return seekRelative(model.player, -5);
          }),
          SkipForwardIntent: CallbackAction<SkipForwardIntent>(
              onInvoke: (SkipForwardIntent intent) {
            return seekRelative(model.player, 5);
          }),
        },
        child: Column(
          children: <Widget>[
            AppBar(
              title: Text(widget.title),
              actions: [_popupMenu()],
            ),
            Expanded(
              child: FutureBuilder(
                future: model.gettingAudio,
                builder: (context, snapshot) {
                  Widget widget;
                  if (snapshot.connectionState == ConnectionState.done ||
                      snapshot.connectionState == ConnectionState.none) {
                    widget = _tingtingContent();
                  } else {
                    widget = _loadingIndicator();
                  }

                  return widget;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _audioControls() {
    return Provider.value(
      value: model.player,
      child: AudioControls(),
    );
  }

  PopupMenuButton _popupMenu() {
    return PopupMenuButton(
      key: Key('loadAudioButton'),
      icon: Icon(Icons.music_note),
      onSelected: (mode) {
        setState(() {
          this.audioMode = mode;
          getAudio(context, model, mode);
        });
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            key: Key('loadAudioFromWebItem'),
            value: AudioGenerationMode.fromWeb,
            child: Text(Strings.fromWeb),
          ),
          PopupMenuItem(
            key: Key('loadAudioFromFileItem'),
            value: AudioGenerationMode.fromFile,
            child: Text(Strings.fromFile),
          ),
          if (!kIsWeb)
            PopupMenuItem(
              key: Key('loadAudioFromTextItem'),
              value: AudioGenerationMode.fromText,
              child: Text(Strings.fromText),
            ),
        ];
      },
    );
  }

  Widget _tingtingContent() {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: tabLabels,
          unselectedLabelColor: Colors.black,
          labelColor: Colors.black,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              textFieldPadding,
              textFieldPadding,
              textFieldPadding,
              0,
            ),
            child: TabBarView(
              controller: _tabController,
              children: [
                InputTab(
                  key: Key('inputTab'),
                  focusNode: inputFocusNode,
                ),
                DiffTab(),
                OriginalTab(
                  key: Key('originalTab'),
                  focusNode: originalFocusNode,
                ),
              ],
            ),
          ),
        ),
        if (model.player != null) _audioControls(),
      ],
    );
  }

  Widget _loadingIndicator() {
    String text = '';
    switch (audioMode) {
      case AudioGenerationMode.fromFile:
        text = Strings.loadingAudioFromFile;
        break;
      case AudioGenerationMode.fromText:
        text = Strings.generatingAudio;
        break;
      default:
    }
    return loadingIndicator(text: text);
  }
}
