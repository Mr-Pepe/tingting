import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tingting/values/colors.dart';
import 'package:tingting/values/dimensions.dart';
import 'package:tingting/viewModels/tingtingViewModel.dart';

class OriginalTab extends StatefulWidget {
  final FocusNode focusNode;

  OriginalTab({Key key, this.focusNode}) : super(key: key);

  @override
  _OriginalTabState createState() => _OriginalTabState();
}

class _OriginalTabState extends State<OriginalTab> {
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TingTingViewModel>(context);
    _textController.text = model.original;

    return Center(
      child: TextField(
        decoration: InputDecoration(border: OutlineInputBorder()),
        controller: _textController,
        onChanged: (value) {
          model.setOriginal(value);
        },
        maxLines: null,
        minLines: 1000,
        focusNode: widget.focusNode,
        style: TextStyle(
            fontSize: textFieldFontSize,
            letterSpacing: 3,
            color: generalTextColor),
      ),
    );
  }
}
