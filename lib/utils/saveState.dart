import 'package:shared_preferences/shared_preferences.dart';

// Workflow for introducing a new preference
// 1: Add preference key
// 2: Initialize the preference if not yet existing
// 3: Create setter. Don't forget to notify listeners!
// 4: Create getter

// Preference keys
const String ORIGINAL = 'tingting:original';
const String SELF_WRITTEN = 'tingting:self_written';

class SaveState {
  SharedPreferences _save;

  Future<void> init() async {
    _save = await SharedPreferences.getInstance();

    // Check that all keys exist
    _save.getString(ORIGINAL) ?? _save.setString(ORIGINAL, '');
    _save.getString(SELF_WRITTEN) ?? _save.setString(SELF_WRITTEN, '');
  }

  void setOriginal(String value) {
    _save.setString(ORIGINAL, value);
  }

  void setSelfWritten(String value) {
    _save.setString(SELF_WRITTEN, value);
  }

  String get original => _save.getString(ORIGINAL) ?? '';
  String get selfWritten => _save.getString(SELF_WRITTEN) ?? '';
}
