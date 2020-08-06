import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tingting/values/dimensions.dart';
import 'package:tingting/viewModels/tingtingViewModel.dart';

class OriginalTextField extends StatefulWidget {
  @override
  _OriginalTextFieldState createState() => _OriginalTextFieldState();
}

class _OriginalTextFieldState extends State<OriginalTextField>
    with AutomaticKeepAliveClientMixin<OriginalTextField> {
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
    super.build(context);

    final model = Provider.of<TingTingViewModel>(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(textFieldPadding),
        child: TextField(
          decoration: InputDecoration(border: OutlineInputBorder()),
          controller: _textController,
          onChanged: (value) {
            // _textController.text = value;
            model.originalText = value;
          },
          maxLines: null,
          minLines: 1000,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
