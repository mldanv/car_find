import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.grey.shade400,
  appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey.shade600,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.grey.shade800),
      titleTextStyle: TextStyle(color: Colors.grey.shade800, fontSize: 32.0)),
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade400,
    primary: Colors.grey.shade800,
    secondary: Colors.grey.shade500,
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color.fromARGB(255, 48, 85, 77),
  appBarTheme: AppBarTheme(
      foregroundColor: Colors.grey.shade800,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.grey.shade600),
      titleTextStyle: TextStyle(color: Colors.grey.shade300, fontSize: 32.0)),
  colorScheme: ColorScheme.dark(
    background: Colors.grey.shade800,
    primary: Colors.grey.shade400,
    onPrimary: Colors.grey.shade300,
    secondary: Colors.black,
  ),
);

class ThemeNotifier extends ChangeNotifier {
  final String key = "theme";
  SharedPreferences? _preferences;
  bool? _darkMode;

  bool? get darkMode => _darkMode;

  ThemeNotifier() {
    _darkMode = false;
    _loadFromPreferences();
  }

  _initialPreferences() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  _savePreferences() async {
    await _initialPreferences();
    _preferences!.setBool(key, _darkMode!);
  }

  _loadFromPreferences() async {
    await _initialPreferences();
    _darkMode = _preferences!.getBool(key) ?? true;
    notifyListeners();
  }

  toggleChangeTheme(bool isOn) {
    darkMode == isOn ? _darkMode! : _darkMode = !_darkMode!;
    _savePreferences();
    notifyListeners();
  }
}
