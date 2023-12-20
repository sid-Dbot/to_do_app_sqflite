import 'package:shared_preferences/shared_preferences.dart';

class MySharedPrefrences {
  static late SharedPreferences _sharedPreferences;

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static bool get light => _sharedPreferences.getBool('light') ?? true;

  static setTheme(bool value) {
    _sharedPreferences.setBool('light', value);
  }
}
