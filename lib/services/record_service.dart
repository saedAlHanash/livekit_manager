import 'package:flutter_screen_recording/flutter_screen_recording.dart';

class RecorderService {
  static Future<void> startRecording() async {
    bool started = await FlutterScreenRecording.startRecordScreenAndAudio(
      'saed',
      titleNotification: 'hi saed ',
      messageNotification: 'hi from message',
    );
  }

  static Future<String> stopRecording() async {
    final path = await FlutterScreenRecording.stopRecordScreen;
    return path;
  }
}
