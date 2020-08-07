import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tingting/viewModels/tingtingViewModel.dart';

class OriginalTextField extends StatefulWidget {
  final FocusNode focusNode;

  OriginalTextField({Key key, this.focusNode}) : super(key: key);

  @override
  _OriginalTextFieldState createState() => _OriginalTextFieldState();
}

class _OriginalTextFieldState extends State<OriginalTextField> {
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
    _textController.text = model.originalText;

    return Center(
      child: TextField(
        decoration: InputDecoration(border: OutlineInputBorder()),
        controller: _textController,
        onChanged: (value) {
          model.originalText = value;
        },
        maxLines: null,
        minLines: 1000,
        focusNode: widget.focusNode,
      ),
    );
  }
}