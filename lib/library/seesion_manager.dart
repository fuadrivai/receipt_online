import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static Future set(String key, String value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(key, value);
  }

  static Future setList(String key, List<String> value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setStringList(key, value);
  }

  static Future<List<String>?> getList(String value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getStringList(value);
  }

  static Future clear() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  static Future<String?> get(String value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(value);
  }

  static Future<bool> checkValue(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool checkValue = prefs.containsKey(value);
    return checkValue;
  }
}
