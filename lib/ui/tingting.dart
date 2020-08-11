import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tingting/ui/diffTextField.dart';
import 'package:tingting/ui/inputTextField.dart';
import 'package:tingting/ui/originalTextField.dart';
import 'package:tingting/ui/playerControls.dart';
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
    Tab(text: 'Yours'),
    Tab(text: 'Diff'),
    Tab(text: 'Original'),
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
              padding: const EdgeInsets.all(textFieldPadding),
              child: TabBarView(
                controller: _tabController,
                children: [
                  InputTextField(
                    key: Key('inputTextField'),
                    focusNode: inputFocusNode,
                  ),
                  DiffTextField(),
                  OriginalTextField(
                      key: Key('originalTextField'),
                      focusNode: originalFocusNode),
                ],
              ),
            ),
          ),
          if (model.player != null) PlayerControls()
        ],
      )),
    );
  }
}
