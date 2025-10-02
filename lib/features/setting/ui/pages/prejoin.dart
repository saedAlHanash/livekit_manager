import 'dart:async';
import 'dart:math' as math;

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:lk_assistant/core/util/snack_bar_message.dart';

import '../../../room/ui/pages/room.dart';

class JoinArgs {
  JoinArgs({
    required this.url,
    required this.token,
    this.e2ee = false,
    this.e2eeKey,
    this.simulcast = true,
    this.adaptiveStream = true,
    this.dynacast = true,
    this.preferredCodec = 'VP8',
    this.enableBackupVideoCodec = true,
  });

  final String url;
  final String token;
  final bool e2ee;
  final String? e2eeKey;
  final bool simulcast;
  final bool adaptiveStream;
  final bool dynacast;
  final String preferredCodec;
  final bool enableBackupVideoCodec;
}

class PreJoinPage extends StatefulWidget {
  const PreJoinPage({
    required this.args,
    super.key,
  });

  final JoinArgs args;

  @override
  State<StatefulWidget> createState() => _PreJoinPageState();
}

class _PreJoinPageState extends State<PreJoinPage> {
  List<MediaDevice> _audioInputs = [];
  StreamSubscription? _subscription;

  bool _busy = false;
  bool _enableAudio = true;
  LocalAudioTrack? _audioTrack;

  MediaDevice? _selectedAudioDevice;

  @override
  void initState() {
    super.initState();
    _subscription = Hardware.instance.onDeviceChange.stream.listen(_loadDevices);
    Hardware.instance.enumerateDevices().then(_loadDevices);
  }

  @override
  void deactivate() {
    _subscription?.cancel();
    super.deactivate();
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

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _join(BuildContext context) async {
    _busy = true;

    setState(() {});

    var args = widget.args;

    try {
      //create new room
      var cameraEncoding = const VideoEncoding(
        maxBitrate: 5 * 1000 * 1000,
        maxFramerate: 30,
      );

      var screenEncoding = const VideoEncoding(
        maxBitrate: 3 * 1000 * 1000,
        maxFramerate: 15,
      );

      E2EEOptions? e2eeOptions;
      if (args.e2ee && args.e2eeKey != null) {
        final keyProvider = await BaseKeyProvider.create();
        e2eeOptions = E2EEOptions(keyProvider: keyProvider);
        await keyProvider.setKey(args.e2eeKey!);
      }

      final room = Room(
        roomOptions: RoomOptions(
          adaptiveStream: args.adaptiveStream,
          dynacast: args.dynacast,
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
            simulcast: args.simulcast,
            videoCodec: args.preferredCodec,
            backupVideoCodec: BackupVideoCodec(
              enabled: args.enableBackupVideoCodec,
            ),
            videoEncoding: cameraEncoding,
            screenShareEncoding: screenEncoding,
          ),
          e2eeOptions: e2eeOptions,
        ),
      );
      // Create a Listener before connecting
      final listener = room.createListener();

      await room.prepareConnection(args.url, args.token);

      // Try to connect to the room
      // This will throw an Exception if it fails for any reason.
      await room.connect(
        args.url,
        args.token,
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
      print('Could not connect $error');
    } finally {
      setState(() {
        _busy = false;
      });
    }
  }

  void _actionBack(BuildContext context) async {
    await _setEnableAudio(false);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Devices',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _actionBack(context),
        ),
      ),
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
                  onPressed: _busy ? null : () => _join(context),
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
                      const Text('JOIN'),
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
