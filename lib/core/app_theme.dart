import 'package:flutter/material.dart';

import 'app/app_widget.dart';
import 'theme/app_theme.dart';
import 'util/shared_preferences.dart';

ThemeData get lightTheme => AppTheme.light;

ThemeData get darkTheme => AppTheme.dark;

ThemeData get currentTheme {
  switch (AppSharedPreference.getThemeMode) {
    case ThemeMode.system:
      return isSystemDarkMode ? darkTheme : lightTheme;
    case ThemeMode.dark:
      return darkTheme;
    case ThemeMode.light:
      return lightTheme;
  }
}

bool get isSystemDarkMode {
  final context = ctx;
  if (context == null) return false;
  final brightness = MediaQuery.platformBrightnessOf(context);
  return brightness == Brightness.dark;
}
