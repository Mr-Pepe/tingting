import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tingting/tingting.dart';
import 'package:tingting/tingtingViewModel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("Ting Ting the Ting Li Trainer")),
        body: ChangeNotifierProvider<TingTingViewModel>(
          create: (_) => TingTingViewModel(),
          child: Consumer<TingTingViewModel>(
            builder: (context, model, child) {
              return TingTing();
            },
          ),
        ),
      ),
    );
  }
}
