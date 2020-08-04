import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tingting/viewModels/tingtingViewModel.dart';

class InputTextField extends StatefulWidget {
  @override
  _InputTextFieldState createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
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
          model.selfWrittenText = value;
        },
      ),
    );
  }
}
