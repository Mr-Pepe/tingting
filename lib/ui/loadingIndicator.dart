import 'package:flutter/material.dart';

Widget loadingIndicator({String text = ''}) {
  return Center(
    child: Column(
      children: [
        SizedBox(
          child: CircularProgressIndicator(),
          width: 60,
          height: 60,
        ),
        if (text.isNotEmpty) Text(text),
      ],
    ),
  );
}
