import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tingting/ui/diffTab.dart';
import 'package:tingting/ui/inputTab.dart';
import 'package:tingting/ui/originalTab.dart';
import 'package:tingting/ui/audioControls/audioControls.dart';
import 'package:tingting/values/dimensions.dart';
import 'package:tingting/values/strings.dart';
import 'package:tingting/viewModels/tingtingViewModel.dart';

class TingTing extends StatefulWidget {
  TingTing({Key key}) : super(key: key);

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

    return Container(
      child: Center(
          child: Column(
        children: <Widget>[
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
          if (model.player != null) _audioControls()
        ],
      )),
    );
  }

  _audioControls() {
    return Provider.value(
      value: model.player,
      child: AudioControls(),
    );
  }
}
