import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_motion.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light => _buildTheme(Brightness.light);

  static ThemeData get dark => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: isDark ? AppColors.darkSeed : AppColors.seed,
      brightness: brightness,
      primary: isDark ? AppColors.darkSeed : AppColors.primary,
      secondary: AppColors.secondary,
      tertiary: AppColors.tertiary,
      error: AppColors.error,
      surface: isDark ? AppColors.darkSurface : AppColors.lightSurface,
    );

    final textColor = scheme.onSurface;
    final textTheme = AppTypography.textTheme(textColor);
    final radius = BorderRadius.circular(AppRadius.sm);

    return ThemeData(
      useMaterial3: true,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: _AppPageTransitionsBuilder(),
          TargetPlatform.iOS: _AppPageTransitionsBuilder(),
          TargetPlatform.macOS: _AppPageTransitionsBuilder(),
          TargetPlatform.windows: _AppPageTransitionsBuilder(),
          TargetPlatform.linux: _AppPageTransitionsBuilder(),
        },
      ),
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: AppTypography.mediumFont,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      scaffoldBackgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      cardColor: isDark ? AppColors.darkSurfaceContainer : AppColors.lightSurface,
      shadowColor: isDark ? Colors.black54 : const Color(0x24111827),
      dividerColor: isDark ? const Color(0xFF2B3936) : const Color(0xFFD8E5E1),
      extensions: <ThemeExtension<dynamic>>[
        isDark ? AppSemanticColors.dark : AppSemanticColors.light,
      ],
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        surfaceTintColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        iconTheme: IconThemeData(color: scheme.primary),
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: isDark ? AppColors.darkSurfaceContainer : AppColors.lightSurface,
        elevation: 1,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shadowColor: isDark ? Colors.black45 : const Color(0x1A111827),
        shape: RoundedRectangleBorder(borderRadius: radius),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(44, 44)),
          padding: const WidgetStatePropertyAll(AppSpacing.control),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: radius)),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return scheme.onSurface.withValues(alpha: 0.12);
            if (states.contains(WidgetState.pressed)) return scheme.primary.withValues(alpha: 0.86);
            if (states.contains(WidgetState.hovered)) return scheme.primary.withValues(alpha: 0.94);
            return scheme.primary;
          }),
          foregroundColor: WidgetStatePropertyAll(scheme.onPrimary),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(44, 44)),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
          foregroundColor: WidgetStatePropertyAll(scheme.primary),
          overlayColor: WidgetStatePropertyAll(scheme.primary.withValues(alpha: 0.08)),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: radius)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.darkSurfaceContainer : Colors.white,
        contentPadding: AppSpacing.control,
        labelStyle: textTheme.bodyMedium,
        hintStyle: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        errorStyle: textTheme.bodySmall?.copyWith(color: scheme.error),
        border: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: scheme.error),
        ),
      ),
      listTileTheme: ListTileThemeData(
        tileColor: isDark ? AppColors.darkSurfaceContainer : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: radius),
        controlAffinity: ListTileControlAffinity.leading,
        iconColor: scheme.primary,
        textColor: scheme.onSurface,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.primary.withValues(alpha: 0.14),
        borderRadius: AppRadius.small,
        linearMinHeight: 7,
        strokeCap: StrokeCap.round,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected) ? scheme.primary : scheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? scheme.primary.withValues(alpha: 0.36)
              : scheme.surfaceContainerHighest;
        }),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: scheme.onInverseSurface),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: radius),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        scrimColor: Colors.black.withValues(alpha: isDark ? 0.55 : 0.32),
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.horizontal(end: Radius.circular(AppRadius.lg)),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: scheme.primary,
        unselectedLabelColor: scheme.onSurfaceVariant,
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        headerBackgroundColor: scheme.primary,
        headerForegroundColor: scheme.onPrimary,
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        dialHandColor: scheme.primary,
        dialBackgroundColor: scheme.surfaceContainerHighest,
      ),
      dataTableTheme: DataTableThemeData(
        headingRowColor: WidgetStatePropertyAll(scheme.surfaceContainerHighest),
        headingTextStyle: textTheme.titleSmall,
        dataTextStyle: textTheme.bodyMedium,
        dividerThickness: 1,
        decoration: BoxDecoration(
          border: Border.all(color: scheme.outlineVariant),
          borderRadius: radius,
        ),
      ),
    );
  }
}

class _AppPageTransitionsBuilder extends PageTransitionsBuilder {
  const _AppPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return AppMotion.fadeSlideTransition(context, animation, secondaryAnimation, child);
  }
}
