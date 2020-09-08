import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tingting/ui/tingting.dart';
import 'package:tingting/utils/saveState.dart';
import 'package:tingting/viewModels/tingtingViewModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final saveState = SaveState();
  await saveState.init();

  runApp(TingTingApp(saveState));
}

class TingTingApp extends StatelessWidget {
  final SaveState saveState;

  TingTingApp(this.saveState);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TingTing',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChangeNotifierProvider<TingTingViewModel>(
        create: (_) => TingTingViewModel(saveState),
        child: Consumer<TingTingViewModel>(
          builder: (context, model, child) {
            return Scaffold(
                body: TingTing(
              title: "TingTing",
            ));
          },
        ),
      ),
    );
  }
}
