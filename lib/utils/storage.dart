import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> setToken(String token) async {
    await _prefs?.setString('token', token);
  }

  static String? getTokenSync() {
    return _prefs?.getString('token');
  }

  static Future<String?> getToken() async {
    return _prefs?.getString('token');
  }

  static Future<void> removeToken() async {
    await _prefs?.remove('token');
  }
}
