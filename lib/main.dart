import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:livekit_manager/core/error/error_manager.dart';
import 'package:m_cubit/caching_service/caching_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/app/app_widget.dart';
import 'core/injection/injection_container.dart' as di;
import 'core/util/shared_preferences.dart';

// final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  // runZonedGuarded(() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance().then((value) {
    AppSharedPreference.init(value);
  });

  // await AppInfoService.initial();

  await CachingService.initial(
    onError: (second) => showErrorFromApi(second),
    version: 3,
    timeInterval: 60,
  );
  // if (kIsWeb) {
  //   GoRouter.optionURLReflectsImperativeAPIs = true;
  // }

  // await FirebaseService.initial();

  // await Note.initialize();

  await di.init();

  HttpOverrides.global = MyHttpOverrides();
  // if (kIsWeb) usePathUrlStrategy();
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      };
  }
}

/*
class Note {
  static Future initialize() async {
    var androidInitialize = const AndroidInitializationSettings('mipmap/ic_launcher');
    var iOSInitialize = const DarwinInitializationSettings();
    // final WindowsInitializationSettings initializationSettingsWindows = WindowsInitializationSettings(
    //   appName: 'Flutter Local Notifications Example',
    //   appUserModelId: 'Com.Dexterous.FlutterLocalNotificationsExample',
    //   // Search online for GUID generators to make your own
    //   guid: 'd49b0314-ee7a-4626-bf79-97cdb8a991bb',
    // );
    var initializationsSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iOSInitialize,
      windows: initializationSettingsWindows,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  }

  static Future showBigTextNotification({
    int id = 0,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'ies',
      'ies_notifications',
      playSound: true,
      enableVibration: true,
    );

    var not = const NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.show(
      (DateTime.now().millisecondsSinceEpoch ~/ 1000),
      title,
      body,
      not,
      payload: payload,
    );
  }
}
*/
