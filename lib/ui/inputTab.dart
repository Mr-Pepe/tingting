import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tingting/values/colors.dart';
import 'package:tingting/values/dimensions.dart';
import 'package:tingting/viewModels/tingtingViewModel.dart';

class InputTab extends StatefulWidget {
  final FocusNode focusNode;

  InputTab({Key key, this.focusNode}) : super(key: key);

  @override
  _InputTabState createState() => _InputTabState();
}

class _InputTabState extends State<InputTab> {
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

    _textController.text = model.selfWritten;

    return Center(
      child: Scrollbar(
        child: TextField(
          decoration: InputDecoration(border: OutlineInputBorder()),
          controller: _textController,
          onChanged: (value) {
            model.setSelfWritten(value);
          },
          maxLines: null,
          minLines: 1000,
          focusNode: widget.focusNode,
          style: TextStyle(
              fontSize: textFieldFontSize,
              letterSpacing: 3,
              color: generalTextColor),
        ),
      ),
    );
  }
}
