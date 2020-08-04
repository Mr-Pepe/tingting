import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tingting/tingtingViewModel.dart';

class OriginalTextField extends StatefulWidget {
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

    return Container(
      child: TextField(
        controller: _textController,
        onChanged: (value) {
          model.originalText = value;
        },
      ),
    );
  }
}
