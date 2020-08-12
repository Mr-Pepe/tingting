import 'package:flutter/material.dart';

Widget loadingIndicator({String text = ''}) {
  return Center(
    child: SizedBox(
      width: 200,
      height: 200,
      child: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          ),
          if (text.isNotEmpty) Text(text),
        ],
      ),
    ),
  );
}
