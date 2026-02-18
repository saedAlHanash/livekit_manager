import 'package:audioplayers/audioplayers.dart';


// ...
class SoundService {
  static final player = AudioPlayer();

  static Future<void> play(String source) async {
    await player.play(AssetSource(source.replaceAll('assets/', '')));
  }
}
