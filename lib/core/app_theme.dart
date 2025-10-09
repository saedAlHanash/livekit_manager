import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';
import 'package:livekit_manager/core/strings/enum_manager.dart';
import 'package:livekit_manager/core/util/shared_preferences.dart';

import 'app/app_widget.dart';

var primaryColor = AppColorManager.mainColor;
var secondaryColor = AppColorManager.white;

ThemeData get lightTheme => ThemeData(
      progressIndicatorTheme: ProgressIndicatorThemeData(
        borderRadius: BorderRadius.circular(8.0),
        linearMinHeight: 7.0,
        strokeCap: StrokeCap.round,
      ),
      primaryColorDark: Colors.grey[200],
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                return AppColorManager.lightGray;
              }
              return AppColorManager.mainColor.withValues(alpha: 0.3);
            },
          ),
        ),
      ),
      textTheme: TextTheme(
        bodyMedium: TextStyle(fontSize: 14.0.sp),
      ),
      fontFamily: FontManager.semeBold.name,
      dividerColor: AppColorManager.lightGrayEd,
      primaryTextTheme: TextTheme(
        displayMedium: TextStyle(
          fontFamily: FontManager.semeBold.name,
          color: Color(0xFF132332),
        ),
      ),
      listTileTheme: ListTileThemeData(
        horizontalTitleGap: 10.0,
        tileColor: Colors.white.withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0.r)),
        controlAffinity: ListTileControlAffinity.leading,
      ),
      brightness: Brightness.light,
      primaryColor: primaryColor,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColorManager.secondColor,
        selectionColor: AppColorManager.secondColor.withValues(alpha: 0.7),
        selectionHandleColor: AppColorManager.secondColor,
      ),
      scaffoldBackgroundColor: AppColorManager.lightGray,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColorManager.white,
        iconTheme: IconThemeData(color: AppColorManager.mainColor),
        titleTextStyle: TextStyle(
          color: Color(0xFF132332),
          fontFamily: FontManager.semeBold.name,
          fontSize: 18.sp,
        ),
      ),
      cardColor: Colors.white,
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0.r)),
      ),
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: AppColorManager.secondColor,
        surface: secondaryColor,
        background: AppColorManager.lightGray,
        error: AppColorManager.red,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primaryColor;
          return AppColorManager.lightGrayAb;
        }),
        trackOutlineColor: WidgetStatePropertyAll(AppColorManager.mainColor),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColorManager.mainColorLight.withValues(alpha: 0.5);
          }
          return AppColorManager.lightGrayEd;
        }),
      ),
      tabBarTheme: TabBarThemeData(
        dividerColor: Colors.grey[300],
        indicatorSize: TabBarIndicatorSize.tab,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(AppColorManager.mainColor),
          foregroundColor: WidgetStatePropertyAll(AppColorManager.white),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0.r)),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: AppColorManager.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0.r),
          borderSide: BorderSide(color: AppColorManager.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0.r),
          borderSide: BorderSide(color: AppColorManager.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0.r),
          borderSide: BorderSide(color: AppColorManager.mainColor),
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: AppColorManager.white,
        scrimColor: AppColorManager.mainColor.withOpacity(0.3),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16.r),
            bottomRight: Radius.circular(16.r),
          ),
        ),
      ),
      shadowColor: Colors.grey[300],
    );

ThemeData get darkTheme => ThemeData(
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                return AppColorManager.darkColor.withValues(alpha: 0.5);
              }
              return AppColorManager.mainColor.withValues(alpha: 0.3);
            },
          ),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        borderRadius: BorderRadius.circular(8.0),
        linearMinHeight: 7.0,
        strokeCap: StrokeCap.round,
      ),
      primaryColorDark: Color(0xff13161D),
      dividerColor: Color(0xff4D5259),
      shadowColor: AppColorManager.darkColor.withValues(alpha: 0.5),
      listTileTheme: ListTileThemeData(
        horizontalTitleGap: 10.0,
        tileColor: Color(0xFF1C1B1F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0.r)),
        controlAffinity: ListTileControlAffinity.leading,
      ),
      brightness: Brightness.dark,
      primaryColor: AppColorManager.secondColor,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColorManager.secondColor,
        selectionColor: AppColorManager.secondColor.withValues(alpha: 0.7),
        selectionHandleColor: AppColorManager.secondColor,
      ),
      scaffoldBackgroundColor: AppColorManager.tileColor,
      colorScheme: ColorScheme.dark(
        primary: AppColorManager.secondColor,
        secondary: AppColorManager.mainColorLight,
        surface: AppColorManager.tileColor,
        background: AppColorManager.darkColor,
        error: AppColorManager.red,
      ),
      fontFamily: FontManager.semeBold.name,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColorManager.secondColor,
        foregroundColor: AppColorManager.darkColor,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColorManager.darkColor,
        iconTheme: IconThemeData(color: AppColorManager.secondColor),
        titleTextStyle: TextStyle(
          color: AppColorManager.white,
          fontFamily: FontManager.semeBold.name,
          fontSize: 18.sp,
        ),
      ),
      cardColor: Color(0xFF1C1B1F),
      cardTheme: CardThemeData(
        color: Color(0xFF1C1B1F),
        elevation: 2,
        shadowColor: Colors.black38,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0.r)),
      ),
      tabBarTheme: TabBarThemeData(
        dividerColor: AppColorManager.darkColor,
        indicatorSize: TabBarIndicatorSize.tab,
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppColorManager.tileColor,
        headerBackgroundColor: AppColorManager.mainColorDark,
        headerForegroundColor: AppColorManager.white,
        confirmButtonStyle: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(AppColorManager.secondColor),
          foregroundColor: WidgetStatePropertyAll(AppColorManager.darkColor),
        ),
        cancelButtonStyle: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(AppColorManager.mainColorDark2),
          foregroundColor: WidgetStatePropertyAll(AppColorManager.white),
        ),
        dayBackgroundColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return AppColorManager.secondColor;
            }
            return null;
          },
        ),
        dayForegroundColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return AppColorManager.darkColor;
            }
            return AppColorManager.white;
          },
        ),
        dayOverlayColor: WidgetStatePropertyAll(AppColorManager.secondColor),
        todayBackgroundColor: WidgetStatePropertyAll(AppColorManager.mainColorLight),
        todayForegroundColor: WidgetStatePropertyAll(AppColorManager.white),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: AppColorManager.tileColor,
        hourMinuteTextColor: AppColorManager.white,
        confirmButtonStyle: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(AppColorManager.secondColor),
          foregroundColor: WidgetStatePropertyAll(AppColorManager.darkColor),
        ),
        cancelButtonStyle: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(AppColorManager.mainColorDark2),
          foregroundColor: WidgetStatePropertyAll(AppColorManager.white),
        ),
        dialBackgroundColor: AppColorManager.mainColorDark,
        dialHandColor: AppColorManager.secondColor,
        dayPeriodColor: AppColorManager.mainColorDark2,
        dayPeriodTextColor: AppColorManager.white,
        hourMinuteColor: AppColorManager.mainColorDark2,
        timeSelectorSeparatorColor: WidgetStatePropertyAll(AppColorManager.secondColor),
        dayPeriodTextStyle: TextStyle(color: AppColorManager.white, fontSize: 14),
        dialTextStyle: TextStyle(color: AppColorManager.white, fontSize: 14),
        helpTextStyle: TextStyle(color: AppColorManager.secondColor, fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(AppColorManager.secondColor),
          foregroundColor: WidgetStatePropertyAll(AppColorManager.darkColor),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0.r)),
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColorManager.darkColor;
          return AppColorManager.mainColorDark;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (states) {
            return Colors.transparent;
          },
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return AppColorManager.secondColor;
            }
            return AppColorManager.mainColorDark2;
          },
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: AppColorManager.tileColor,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0.r),
          borderSide: BorderSide(color: AppColorManager.mainColorDark2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0.r),
          borderSide: BorderSide(color: AppColorManager.mainColorDark2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0.r),
          borderSide: BorderSide(color: AppColorManager.secondColor),
        ),
        labelStyle: TextStyle(color: AppColorManager.white),
        hintStyle: TextStyle(color: AppColorManager.lightGrayAb),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: AppColorManager.tileColor,
        scrimColor: AppColorManager.mainColorDark.withOpacity(0.5),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16.r),
            bottomRight: Radius.circular(16.r),
          ),
        ),
      ),
      textTheme: TextTheme(
        bodyMedium: TextStyle(
          fontSize: 14.0.sp,
        ),
      ),
      dataTableTheme: DataTableThemeData(
        dataRowColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppColorManager.secondColor.withOpacity(0.2);
          }
          return null;
        }),
        dataTextStyle: TextStyle(
          color: AppColorManager.white,
          fontFamily: FontManager.semeBold.name,
          fontSize: 14.sp,
        ),
        headingRowColor: WidgetStatePropertyAll(AppColorManager.mainColorDark),
        headingTextStyle: TextStyle(
          color: AppColorManager.white,
          fontFamily: FontManager.semeBold.name,
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
        ),
        dividerThickness: 10,
        decoration: BoxDecoration(
          border: Border.all(color: AppColorManager.mainColorDark2),
          borderRadius: BorderRadius.circular(8.0.r),
        ),
      ),
    );

ThemeData get currentTheme {
  switch (AppSharedPreference.getThemeMode) {
    case ThemeMode.system:
      return isSystemDarkMode ? darkTheme : lightTheme;
    case ThemeMode.dark:
      return darkTheme;
    case ThemeMode.light:
      return lightTheme;
  }

  return AppSharedPreference.getThemeMode == ThemeMode.dark ? darkTheme : lightTheme;
}

bool get isSystemDarkMode {
  final brightness = MediaQuery.platformBrightnessOf(ctx!);
  return brightness == Brightness.dark;
}
