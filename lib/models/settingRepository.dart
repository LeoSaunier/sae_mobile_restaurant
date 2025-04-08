import 'package:shared_preferences/shared_preferences.dart';

class SettingRepository{

  static const THEME_KEY = "darkMode";

  void saveSettings(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(THEME_KEY, value);
  }

  Future<bool> getSettings() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(THEME_KEY) ?? false;
  }
}