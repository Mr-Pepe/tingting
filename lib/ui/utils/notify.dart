import 'package:flutter/material.dart';
import 'package:tingting/values/strings.dart';

notify(BuildContext context, String heading, String body) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(heading),
        content: Text(body),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(Strings.close))
        ],
      );
    },
  );
}
