import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

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
                      // ..setUrl('ws://192.168.1.69:7880')
                      ..setUrl('wss://coretik.coretech-mena.com')
                      ..setToken(
                        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJzYWVkIGFkbWluIiwianRpIjoic2FlZCBhZG1pbiIsImlzcyI6IkFQSWVTRmlWN3hpQ1J6UiIsIm5iZiI6MTc2MTIyODA5MCwiaWF0IjoxNzYxMjI4MDkwLCJleHAiOjE3NjEyMzE2OTAsInZpZGVvIjp7ImFnZW50IjpmYWxzZSwiY2FuUHVibGlzaCI6ZmFsc2UsImNhblB1Ymxpc2hEYXRhIjp0cnVlLCJjYW5QdWJsaXNoU291cmNlcyI6W10sImNhblN1YnNjcmliZSI6dHJ1ZSwiY2FuU3Vic2NyaWJlTWV0cmljcyI6ZmFsc2UsImNhblVwZGF0ZU93bk1ldGFkYXRhIjpmYWxzZSwiZGVzdGluYXRpb25Sb29tIjoiIiwiaGlkZGVuIjpmYWxzZSwiaW5ncmVzc0FkbWluIjpmYWxzZSwicmVjb3JkZXIiOmZhbHNlLCJyb29tIjoiczEiLCJyb29tQWRtaW4iOnRydWUsInJvb21DcmVhdGUiOnRydWUsInJvb21Kb2luIjp0cnVlLCJyb29tTGlzdCI6dHJ1ZSwicm9vbVJlY29yZCI6ZmFsc2V9LCJzaXAiOnsiYWRtaW4iOmZhbHNlLCJjYWxsIjpmYWxzZX0sIm5hbWUiOiJzYWVkIGFsIEhhbmFzaCIsIm1ldGFkYXRhIjoiIiwic2hhMjU2IjoiIiwia2luZCI6IiIsImF0dHJpYnV0ZXMiOnsidHlwZSI6IjIiLCJpbWFnZVVybCI6Imh0dHBzOi8vc2NvbnRlbnQtc29mMS0xLnh4LmZiY2RuLm5ldC92L3QzOS4zMDgwOC02LzMwMDQ5NzM1MV8xNjgxMzQxNjU4OTE0ODYxXzMyNzM5MDIzMzY5MDY0NDQ1ODZfbi5qcGc_X25jX2NhdD0xMDQmY2NiPTEtNyZfbmNfc2lkPTZlZTExYSZfbmNfb2hjPW9EQ0VFRnpOWG5RUTdrTnZ3RXNUZzV0Jl9uY19vYz1BZGtldWJuMHk0aEhlREYxQ1RMbm42UTRDal9IWGNPQ1BOamJFNkRxWmNLaWdyWktqdUhjVGtoS2RRd2Znc1FQQlF3Jl9uY196dD0yMyZfbmNfaHQ9c2NvbnRlbnQtc29mMS0xLnh4Jl9uY19naWQ9a0dwZjVMSldveWF6SWJzRzF1Ni1zZyZvaD0wMF9BZmZzdGhWeW1qcWE2QzVRYm1yVS0wYWRGQjl1akNrOTVGRkd0MkRKcXM1UzR3Jm9lPTY4RkVENDIwIn0sInJvb21Db25maWciOnt9fQ.tRqN1AVGMbDk8v6nz3DI9Papor5sm0a0Q10Ak1VHE38',
                      )
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
