
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static late SharedPreferences _preferences;

  static const _keyLanguage = 'language';
  static const _keyAppTheme = 'app_theme';

  static Future init() async => _preferences = await SharedPreferences.getInstance();

  static Future setLanguage(String language) async =>
      await _preferences.setString(_keyLanguage, language);

  static String? getLanguage() => _preferences.getString(_keyLanguage);

  static Future setAppTheme(int appTheme) async =>
      await _preferences.setInt(_keyAppTheme, appTheme);

  static int? getAppTheme() => _preferences.getInt(_keyAppTheme);
}