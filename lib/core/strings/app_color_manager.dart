import 'package:flutter/material.dart';
import 'package:m_cubit/m_cubit.dart';

import '../app/app_widget.dart';

class AppColorManager {
  static const mainColor = Color(0xFF1B7683);
  static const secondColor = Color(0xFF8ACFD8);
  static const mainColorDark = Color(0xFF092629);
  static const mainColorDark1 = Color(0xFF103E45);
  static const mainColorDark2 = Color(0xFF144E57);
  static const mainColorLight = Color(0xFF1B7683);
  static const selectColor = Color(0xFFBBE5EB);
  static const green = Color(0xFF079455);

  static Color get textColor => Theme.of(ctx!).textTheme.bodyMedium!.color!;
  static Color get scaffoldColor => Theme.of(ctx!).scaffoldBackgroundColor;

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

  static Color get cardColor => Theme.of(ctx!).cardColor;
  static const blue = Color(0xFF0D479E);
  static const c8f = Color(0xFF8F7752);
  static const tableHeader = Color(0xFFFAF5FF);
  static const redPrice = Color(0xFFCF6B53);
  static const borderColor = Color(0xFFE5E7EB);

  static Color get dividerColor => Theme.of(ctx!).dividerColor;
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

  static Color get appBarColor => Theme.of(ctx!).appBarTheme.backgroundColor ?? mainColor;
}

Color getColorFromHex(String hexColor) {
  if (hexColor.isBlank) return AppColorManager.mainColor;
  String formattedHexColor = hexColor.replaceAll("#", ""); // Remove the '#' character if present
  if (formattedHexColor.length == 6) {
    formattedHexColor = "FF$formattedHexColor"; // Add the alpha value if it's missing
  }
  int colorValue = int.parse(formattedHexColor, radix: 16); // Parse the hex color string
  return Color(colorValue);
}

String colorToHex(Color color) {
  return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
}

bool isColorDark(Color color) {
  final luminance = (0.2126 * color.red + 0.7152 * color.green + 0.0722 * color.blue) / 255;
  return luminance < 0.5;
}

Color getCheckColor(Color color) {
  if (isColorDark(color)) {
    return Colors.white;
  } else {
    return AppColorManager.grey;
  }
}
