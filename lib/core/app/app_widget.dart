import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_manager/features/home/bloc/home_cubit/home_cubit.dart';

import '../../features/room/bloc/room_cubit/room_cubit.dart';
import '../../features/room/bloc/user_control_cubit/user_control_cubit.dart';
import '../../generated/assets.dart';
import '../../generated/l10n.dart';
import '../../router/go_router.dart';

import '../api_manager/api_service.dart';
import '../app_theme.dart';
import '../injection/injection_container.dart';
import '../util/shared_preferences.dart';
import 'app_provider.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();

  static Future<void> setLocale(BuildContext context, String langCode) async {
    await AppSharedPreference.cashLocal(langCode);

    if (context.mounted) {
      final state = context.findAncestorStateOfType<MyAppState>();
      await state?.setLocale(Locale.fromSubtags(languageCode: AppSharedPreference.getLocal));
    }
  }
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    S.load(Locale(AppSharedPreference.getLocal));

    setImageMultiTypeErrorImage(
      const Opacity(
        opacity: 0.3,
        child: ImageMultiType(url: Assets.iconsLogo, height: 30.0, width: 30.0),
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    // Unlock to portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
  }

  Future<void> setLocale(Locale locale) async {
    AppSharedPreference.cashLocal(locale.languageCode);
    await S.load(locale);
    setState(() {});
  }

//changeThem
  Future<void> changeThem(ThemeMode mode) async {
    await AppSharedPreference.setThemeMode(mode);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    loggerObject.w(AppSharedPreference.getToken);
    return ScreenUtilInit(
      // designSize: const Size(375, 833),
      // designSize: Size(MediaQuery.sizeOf(context).width * 2, MediaQuery.sizeOf(context).height),
      // designSize: const Size(1400, 972),
      designSize: MediaQuery.of(context).size,
      minTextAdapt: true,
      builder: (context, child) {
        // loggerObject.w(MediaQuery.of(context).size);
        return GestureDetector(
          onTap: () => AppProvider.unFocus(context: context),
          child: MaterialApp.router(
            darkTheme: darkTheme,
            theme: lightTheme,
            themeMode: AppSharedPreference.getThemeMode,
            routerConfig: goRouter,
            debugShowCheckedModeBanner: false,
            locale: Locale.fromSubtags(languageCode: AppSharedPreference.getLocal),
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            builder: (ctx, child) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => sl<RoomCubit>()
                      ..setUrl('ws://192.168.1.69:7880')
                      ..setToken(
                          'eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoi2YXYr9mK2LEg2KfZhNi62LHZgdipIiwiYXR0cmlidXRlcyI6eyJpbWFnZVVybCI6Imh0dHBzOi8vY2RuLWljb25zLXBuZy5mbGF0aWNvbi5jb20vNTEyLzk3MDMvOTcwMzU5Ni5wbmcifSwidmlkZW8iOnsicm9vbUpvaW4iOnRydWUsImNhblB1Ymxpc2giOnRydWUsImNhblN1YnNjcmliZSI6dHJ1ZSwiY2FuUHVibGlzaERhdGEiOnRydWUsInJvb21MaXN0Ijp0cnVlLCJyb29tIjoiczEiLCJyb29tQWRtaW4iOnRydWUsImNhblVwZGF0ZU93bk1ldGFkYXRhIjp0cnVlfSwiaXNzIjoiQVBJUXhaUGp3cEdvY2NyIiwiZXhwIjoxNzYwOTc2OTU5LCJuYmYiOjAsInN1YiI6Im1TYWVkIn0.9t-H7A7l4obyLFp177cODvptGZHR-1GD0i7XRL8AGJg')
                      ..initial(),
                  ),
                  BlocProvider(create: (context) => sl<UserControlCubit>()),
                ],
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: SafeArea(bottom: true, left: false, right: false, top: false, child: child!),
                ),
              );
            },
            scrollBehavior: MyCustomScrollBehavior(),
          ),
        );
      },
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {PointerDeviceKind.touch, PointerDeviceKind.mouse};
}

BuildContext? get ctx => sl<GlobalKey<NavigatorState>>().currentContext;
