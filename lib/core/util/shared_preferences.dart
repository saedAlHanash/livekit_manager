import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../strings/enum_manager.dart';

class AppSharedPreference {
  static late SharedPreferences prefs;

  static const _token = 'token';
  static const _lang = '4';
  static const _screenType = '5';
  static const _user = 'user';
  static const _studentRecord = 'studentRecord';
  static const _resendTime = '8';
  static const String _keyUserType = 'userType';
  static const String _keyThemeMode = 'themeMode'; // مفتاح جديد لوضع الثيم

  //region Init & Reload
  static Future<void> init(SharedPreferences preferences) async {
    prefs = preferences;
  }

  static Future<void> reload() async => prefs.reload();

  //endregion

  //region Token
  static Future<void> cashToken(String? token) async {
    if (token == null) return;
    await prefs.setString(_token, token);
  }

  static String get getToken => prefs.getString(_token) ?? '';

  //endregion

  //region StartPage
  static Future<void> cashStartPage(StartPage type) async {
    await prefs.setInt(_screenType, type.index);
  }

  static StartPage get getStartPage => StartPage.values[prefs.getInt(_screenType) ?? 0];

  //endregion

  //region Language
  static Future<void> cashLocal(String langCode) async {
    await prefs.setString(_lang, langCode);
  }

  static String get getLocal => prefs.getString(_lang) ?? 'ar';

  //endregion

  //region ThemeMode
  static Future<void> setThemeMode(ThemeMode themeMode) async {
    await prefs.setInt(_keyThemeMode, themeMode.index);
    await reload();
  }

  static ThemeMode get getThemeMode {
    // return ThemeMode.dark;
    final index = prefs.getInt(_keyThemeMode);
    if (index == null) return ThemeMode.system;
    return ThemeMode.values[index];
  }

  //endregion

  //region Resend DateTime
  static Future<void> setResendDateTime(int s) async {
    final d = DateTime.now().add(Duration(seconds: s));
    await prefs.setString(_resendTime, d.toIso8601String());
  }

  static DateTime get getResendDateTime => DateTime.tryParse(prefs.getString(_resendTime) ?? '') ?? DateTime.now();

  //endregion

  //region Clear & Logout
  static Future<void> clear() async => await prefs.clear();

  static Future<void> logout() async => await clear();
//endregion
}
