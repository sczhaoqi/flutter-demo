import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String SAVED_TOKEN_KEY = "ft_token";

  static saveString(String key, String value) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString(key, value);
  }

  static saveInt(String key, int value) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setInt(key, value);
  }

  static saveDouble(String key, double value) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setDouble(key, value);
  }

  static saveBoolean(String key, bool value) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setBool(key, value);
  }

  static saveStringList(String key, List<String> value) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setStringList(key, value);
  }

  static Future<String> getString(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(key);
  }
}
