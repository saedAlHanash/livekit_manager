// import 'package:flutter/foundation.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:path_provider/path_provider.dart';
//
// import '../core/api_manager/api_service.dart';
//
// PackageInfo? _appData;
//
// class AppInfoService {
//   static Future<void> initial() async {
//     try {
//       _appData = await PackageInfo.fromPlatform();
//     } catch (e) {
//       loggerObject.e('AppInfoService: $e');
//     }
//   }
//
//   static PackageInfo get appInfo => _appData!;
//
//   static String get fullVersionName => 'V:${appInfo.version}';
//
//   static Future<String> get voiceFile async =>
//       kIsWeb ? '' : '${await AppInfoService.docPath}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
//   static Future<String> get videoPath async =>
//       kIsWeb ? '' : '${await AppInfoService.docPath}/video_${DateTime.now().millisecondsSinceEpoch}.mp4';
//
//   static Future<String> get docPath async =>
//       kIsWeb ? '' : '${(await getApplicationDocumentsDirectory()).path}\\${AppInfoService.appInfo.appName}';
// }
