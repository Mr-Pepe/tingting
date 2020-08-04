import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tingting/ui/inputTextField.dart';
import 'package:tingting/ui/originalTextField.dart';
import 'package:tingting/ui/playerControls.dart';
import 'package:tingting/viewModels/tingtingViewModel.dart';

class TingTing extends StatefulWidget {
  TingTing({Key key}) : super(key: key);

  @override
  _TingTingState createState() => _TingTingState();
}

class _TingTingState extends State<TingTing>
    with SingleTickerProviderStateMixin {
  final List<Tab> tabs = <Tab>[
    Tab(text: 'Yours'),
    Tab(text: 'Diff'),
    Tab(text: 'Original'),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TingTingViewModel>(context);

    return Container(
      child: Center(
          child: Column(
        children: <Widget>[
          TabBar(
            controller: _tabController,
            tabs: tabs,
            unselectedLabelColor: Colors.black,
            labelColor: Colors.black,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                InputTextField(),
                Text("2"),
                OriginalTextField(),
              ],
            ),
          ),
          PlayerControls(),
        ],
      )),
    );
  }
}
