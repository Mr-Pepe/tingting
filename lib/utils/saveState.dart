import 'package:shared_preferences/shared_preferences.dart';

// Workflow for introducing a new preference
// 1: Add preference key
// 2: Initialize the preference if not yet existing
// 3: Create setter. Don't forget to notify listeners!
// 4: Create getter

// Preference keys
const String ORIGINAL = 'tingting:original';

class SaveState {
  SharedPreferences _save;

  Future<void> init() async {
    _save = await SharedPreferences.getInstance();

    // Check that all keys exist
    _save.getString(ORIGINAL) ?? _save.setString(ORIGINAL, '');
  }

  void setOriginal(String value) {
    _save.setString(ORIGINAL, value);
  }

  String get original => _save.getString(ORIGINAL) ?? '';
}
