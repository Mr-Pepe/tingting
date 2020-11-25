import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tingting/ui/diffTab.dart';
import 'package:tingting/ui/inputTab.dart';
import 'package:tingting/ui/originalTab.dart';
import 'package:tingting/ui/audioControls/audioControls.dart';
import 'package:tingting/ui/utils/loadingIndicator.dart';
import 'package:tingting/utils/getAudio.dart';
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

    return Column(
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
            value: AudioGenerationMode.fromWeb,
            child: Text(Strings.fromWeb),
          ),
          if (!kIsWeb)
            PopupMenuItem(
              value: AudioGenerationMode.fromFile,
              child: Text(Strings.fromFile),
            ),
          if (!kIsWeb)
            PopupMenuItem(
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
