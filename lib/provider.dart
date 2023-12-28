import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_app/mySharedPrefrences.dart';

final themeModeProvider =
    StateProvider<bool>((ref) => MySharedPrefrences.light);

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(),
  name: 'themeProvider',
);

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode =
        (_themeMode == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();
  }
}

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light);

  void toggleTheme() {
    state = MySharedPrefrences.light ? ThemeMode.light : ThemeMode.dark;
    // _saveThemePreference();
  }

  // Future<void> _saveThemePreference() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setString('theme', state.toString());
  // }
}
