import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:lk_assistant/core/api_manager/api_service.dart';
import 'package:lk_assistant/core/widgets/my_text_form_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/util/snack_bar_message.dart';
import '../../../room/ui/pages/room.dart';

const _storeKeyToken = 'token';

class HomePage extends StatefulWidget {
  //
  const HomePage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _tokenCtrl = TextEditingController();

  bool _busy = false;

  List<MediaDevice> _audioInputs = [];
  StreamSubscription? _subscription;

  bool _enableAudio = true;
  LocalAudioTrack? _audioTrack;

  MediaDevice? _selectedAudioDevice;

  @override
  void initState() {
    super.initState();
    _readPrefs();
    _subscription = Hardware.instance.onDeviceChange.stream.listen(_loadDevices);
    Hardware.instance.enumerateDevices().then(_loadDevices);
    Permission.microphone.request();
  }

  @override
  void deactivate() {
    _subscription?.cancel();
    super.deactivate();
  }

  @override
  void dispose() {
    _tokenCtrl.dispose();
    _subscription?.cancel();
    super.dispose();
  }

  void _loadDevices(List<MediaDevice> devices) async {
    _audioInputs = devices.where((d) => d.kind == 'audioinput').toList();

    if (_audioInputs.isNotEmpty) {
      if (_selectedAudioDevice == null) {
        _selectedAudioDevice = _audioInputs.first;
        Future.delayed(const Duration(milliseconds: 100), () async {
          await _changeLocalAudioTrack();
          setState(() {});
        });
      }
    }

    setState(() {});
  }

  Future<void> _setEnableAudio(value) async {
    _enableAudio = value;
    if (!_enableAudio) {
      await _audioTrack?.stop();
      _audioTrack = null;
    } else {
      await _changeLocalAudioTrack();
    }
    setState(() {});
  }

  Future<void> _changeLocalAudioTrack() async {
    if (_audioTrack != null) {
      await _audioTrack!.stop();
      _audioTrack = null;
    }

    if (_selectedAudioDevice != null) {
      _audioTrack = await LocalAudioTrack.create(
        AudioCaptureOptions(
          deviceId: _selectedAudioDevice!.deviceId,
        ),
      );
      await _audioTrack!.start();
    }
  }

  // Read saved URL and Token
  Future<void> _readPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    _tokenCtrl.text = const bool.hasEnvironment('TOKEN')
        ? const String.fromEnvironment('TOKEN')
        : prefs.getString(_storeKeyToken) ?? '';
  }

  // Save URL and Token
  Future<void> _writePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storeKeyToken, _tokenCtrl.text);
  }

  Future<void> _connect(BuildContext context) async {
    setState(() => _busy = true);

    var url = 'wss://coretik.coretech-mena.com';
    // var url = 'wss://coretest-4xi5uo5z.livekit.cloud';

    var token = _tokenCtrl.text;
    _writePrefs();

    try {
      var screenEncoding = const VideoEncoding(
        maxBitrate: 3 * 1000 * 1000,
        maxFramerate: 15,
      );

      final room = Room(
        roomOptions: RoomOptions(
          adaptiveStream: true,
          dynacast: true,
          defaultAudioPublishOptions: const AudioPublishOptions(
            name: 'custom_audio_track_name',
          ),
          defaultCameraCaptureOptions: const CameraCaptureOptions(
            maxFrameRate: 30,
            params: VideoParameters(
              dimensions: VideoDimensions(1280, 720),
            ),
          ),
          defaultScreenShareCaptureOptions: const ScreenShareCaptureOptions(
            useiOSBroadcastExtension: true,
            params: VideoParameters(
              dimensions: VideoDimensionsPresets.h1080_169,
            ),
          ),
          defaultVideoPublishOptions: VideoPublishOptions(
            simulcast: true,
            videoCodec: 'H264',
            backupVideoCodec: BackupVideoCodec(
              enabled: false,
            ),
            screenShareEncoding: screenEncoding,
          ),
        ),
      );
      // Create a Listener before connecting
      final listener = room.createListener();

      await room.prepareConnection(url, token);

      await room.connect(
        url,
        token,
        fastConnectOptions: FastConnectOptions(
          microphone: TrackOption(track: _audioTrack),
        ),
      );

      await Navigator.push<void>(
        context,
        MaterialPageRoute(builder: (_) => RoomPage1(room, listener)),
      );
    } catch (error) {
      NoteMessage.showAwesomeError(message: error.toString());
      loggerObject.e('Could not connect $error');
    } finally {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: MyTextFormWidget(
                    label: 'Token',
                    controller: _tokenCtrl,
                  ),
                ),
                20.0.verticalSpace,
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Micriphone:'),
                      Switch(
                        value: _enableAudio,
                        onChanged: (value) => _setEnableAudio(value),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<MediaDevice>(
                      isExpanded: true,
                      disabledHint: const Text('Disable Microphone'),
                      hint: const Text(
                        'Select Micriphone',
                      ),
                      items: _enableAudio
                          ? _audioInputs
                              .map((MediaDevice item) => DropdownMenuItem<MediaDevice>(
                                    value: item,
                                    child: Text(
                                      item.label,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList()
                          : [],
                      value: _selectedAudioDevice,
                      onChanged: (MediaDevice? value) async {
                        if (value != null) {
                          _selectedAudioDevice = value;
                          await _changeLocalAudioTrack();
                          setState(() {});
                        }
                      },
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        height: 40,
                        width: 140,
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _busy ? null : () => _connect(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_busy)
                        const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: SizedBox(
                            height: 15,
                            width: 15,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      const Text('CONNECT'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
