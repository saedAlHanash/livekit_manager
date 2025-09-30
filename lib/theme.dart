import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//
// Flutter has a color profile issue so colors will look different
// on Apple devices.
// https://github.com/flutter/flutter/issues/55092
// https://github.com/flutter/flutter/issues/39113
//

extension LKColors on Colors {
  static const lkBlue = Color(0xFF5A8BFF);
  static const lkDarkBlue = Color(0xFF00153C);
}

class LiveKitTheme {
  //
  final bgColor = Colors.black;
  final textColor = Colors.white;
  final cardColor = LKColors.lkDarkBlue;
  final accentColor = LKColors.lkBlue;

  ThemeData buildThemeData(BuildContext ctx) => ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: cardColor,
        ),
        cardColor: cardColor,
        scaffoldBackgroundColor: bgColor,
        canvasColor: bgColor,
        iconTheme: IconThemeData(
          color: textColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            textStyle: WidgetStateProperty.all<TextStyle>(GoogleFonts.montserrat(
              fontSize: 15,
            )),
            padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(vertical: 20, horizontal: 25)),
            shape:
                WidgetStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
            // backgroundColor: WidgetStateProperty.all<Color>(accentColor),
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return accentColor.withValues(alpha: 0.5);
              }
              return accentColor;
            }),
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          checkColor: WidgetStateProperty.all(Colors.white),
          fillColor: WidgetStateProperty.all(accentColor),
        ),
        switchTheme: SwitchThemeData(
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return accentColor;
            }
            return accentColor.withValues(alpha: 0.3);
          }),
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.white;
            }
            return Colors.white.withValues(alpha: 0.3);
          }),
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(ctx).textTheme,
        ).apply(
          displayColor: textColor,
          bodyColor: textColor,
          decorationColor: textColor,
        ),
        hintColor: Colors.red,
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(
            color: LKColors.lkBlue,
          ),
          hintStyle: TextStyle(
            color: LKColors.lkBlue.withValues(alpha: 5),
          ),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          surface: bgColor,
        ),
      );
}

ThemeData get darkTheme => ThemeData(
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
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
          fontSize: 18.0,
        ),
      ),
      cardColor: Color(0xFF1C1B1F),
      cardTheme: CardThemeData(
        color: Color(0xFF1C1B1F),
        elevation: 2,
        shadowColor: Colors.black38,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
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
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
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
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: AppColorManager.mainColorDark2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: AppColorManager.mainColorDark2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
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
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
      ),
      textTheme: TextTheme(
        bodyMedium: TextStyle(
          fontSize: 14.0,
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
          fontSize: 14.0,
        ),
        headingRowColor: WidgetStatePropertyAll(AppColorManager.mainColorDark),
        headingTextStyle: TextStyle(
          color: AppColorManager.white,
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
        dividerThickness: 10,
        decoration: BoxDecoration(
          border: Border.all(color: AppColorManager.mainColorDark2),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );

class AppColorManager {
  static const mainColor = Color(0xFF1B7683);
  static const secondColor = Color(0xFF8ACFD8);
  static const mainColorDark = Color(0xFF092629);
  static const mainColorDark1 = Color(0xFF103E45);
  static const mainColorDark2 = Color(0xFF144E57);
  static const mainColorLight = Color(0xFF1B7683);
  static const selectColor = Color(0xFFBBE5EB);
  static const green = Color(0xFF079455);

  // static Color get textColor => Theme.of(ctx!).textTheme.bodyMedium!.color!;
  // static Color get scaffoldColor => Theme.of(ctx!).scaffoldBackgroundColor;

  static const darkColor = Color(0xFF151319);
  static const greenPrice = Color(0xFF479D78);
  static const black = Color(0xFF000000);
  static const tileColor = Color(0xFF1F1C26);

  static const ampere = Color(0xFFFFC107);
  static const grey = Color(0xFF848484);
  static const lightGray = Color(0xFFFBFBFB);
  static const lightGrayAb = Color(0xFFABABAB);
  static const lightGrayEd = Color(0xFFEDEDED);
  static const offWhit = Color(0xFFD9D9D9);
  static const white = Color(0xFFFFFFFF);
  static const red = Color(0xFFC60000);

  // static Color get cardColor => Theme.of(ctx!).cardColor;
  static const blue = Color(0xFF0D479E);
  static const c8f = Color(0xFF8F7752);
  static const tableHeader = Color(0xFFFAF5FF);
  static const redPrice = Color(0xFFCF6B53);
  static const borderColor = Color(0xFFE5E7EB);

  // static Color get dividerColor => Theme.of(/ctx!).dividerColor;
  static const f1 = Color(0xFFf1f1f1);
  static const f9 = Color(0xFFF9FAFB);
  static const c99 = Color(0xFF999999);
  static const f6 = Color(0xFFf6f6f6);
  static const f3 = Color(0xFFf3f3f3);
  static const e4 = Color(0xFF4E5053);
  static const ac = Color(0xFFACACAC);
  static const ee = Color(0xFFEEEEEE);
  static const d9 = Color(0xFFD9D9D9);
  static const warning = Color(0xFFEAB308);
  static const b2 = Color(0xFFB2B7BC);
  static const ae = Color(0xFFAEAEAE);
  static const fc = Color(0xFFFCFCFC);
  static const c50 = Color(0xFF505050);
  static const c6e = Color(0xFF6E6E6E);

  static const f8 = Color(0xFFF8F8F8);

  static const darkBlue = Color(0xFF1E3354);

  static Color getPolyLineColor(int i) {
    if (i >= polyLineColors.length) {
      return black;
    }
    return polyLineColors[i];
  }

  static const polyLineColors = [
    Color(0xFFE6194B), // Red
    Color(0xFF3CB44B), // Green
    Color(0xFF0082C8), // Blue
    Color(0xFFF58231), // Orange
    Color(0xFF911EB4), // Purple
    Color(0xFF46F0F0), // Cyan
    Color(0xFFF032E6), // Magenta
    Color(0xFFD2F53C), // Lime
    Color(0xFFFABEBE), // Pink
    Color(0xFF008080), // Teal
    Color(0xFFE6BEFF), // Lavender
    Color(0xFFAA6E28), // Brown
    Color(0xFFFFFAC8), // Beige
    Color(0xFF800000), // Maroon
    Color(0xFFAAFFC3), // Mint
    Color(0xFF808000), // Olive
    Color(0xFFFFD8B1), // Apricot
    Color(0xFF000080), // Navy
    Color(0xFF808080), // Gray
    Color(0xFFFFFFC0), // Light Yellow
  ];
}
