import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:livekit_client/livekit_client.dart' as client;
import 'package:livekit_client/livekit_client.dart';
import 'package:lk_assistant/core/util/exts.dart';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_client/livekit_client.dart' as client;
import 'package:livekit_client/livekit_client.dart';

import 'package:permission_handler/permission_handler.dart';

import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/my_style.dart';
import '../../../../core/widgets/menu_widget.dart';
import '../../../../core/widgets/my_button.dart';
import '../../bloc/room_cubit/room_cubit.dart';

class ControlsWidget extends StatefulWidget {
  //
  final Room room;
  final LocalParticipant participant;

  const ControlsWidget(
    this.room,
    this.participant, {
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ControlsWidgetState();
}

class _ControlsWidgetState extends State<ControlsWidget> {
  //

  List<MediaDevice>? _audioInputs;
  List<MediaDevice>? _audioOutputs;
  List<MediaDevice>? _videoInputs;

  StreamSubscription? _subscription;

  bool _speakerphoneOn = Hardware.instance.speakerOn ?? false;

  @override
  void initState() {
    super.initState();
    participant.addListener(_onChange);
    _subscription = Hardware.instance.onDeviceChange.stream.listen((List<MediaDevice> devices) {
      _loadDevices(devices);
    });
    Hardware.instance.enumerateDevices().then(_loadDevices);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    participant.removeListener(_onChange);
    super.dispose();
  }

  LocalParticipant get participant => widget.participant;

  void _loadDevices(List<MediaDevice> devices) async {
    _audioInputs = devices.where((d) => d.kind == 'audioinput').toList();
    _audioOutputs = devices.where((d) => d.kind == 'audiooutput').toList();
    _videoInputs = devices.where((d) => d.kind == 'videoinput').toList();
    setState(() {});
  }

  void _onChange() {
    // trigger refresh
    setState(() {});
  }

  void _unpublishAll() async {
    final result = await context.showUnPublishDialog();
    if (result == true) await participant.unpublishAllTracks();
  }

  bool get isMuted => participant.isMuted;

  void _disableAudio() async {
    await participant.setMicrophoneEnabled(false);
  }

  Future<void> _enableAudio() async {
    await participant.setMicrophoneEnabled(true);
  }

  void _disableVideo() async {
    await participant.setCameraEnabled(
      false,
    );
  }

  void _enableVideo() async {
    await participant.setCameraEnabled(
      true,
    );
  }

  void _selectAudioOutput(MediaDevice device) async {
    await widget.room.setAudioOutputDevice(device);
    setState(() {});
  }

  void _selectAudioInput(MediaDevice device) async {
    await widget.room.setAudioInputDevice(device);
    setState(() {});
  }

  void _selectVideoInput(MediaDevice device) async {
    await widget.room.setVideoInputDevice(device);
    setState(() {});
  }

  void _setSpeakerphoneOn() async {
    _speakerphoneOn = !_speakerphoneOn;
    await widget.room.setSpeakerOn(_speakerphoneOn, forceSpeakerOutput: false);
    setState(() {});
  }

  void _toggleCamera() async {
    final track = participant.videoTrackPublications.firstOrNull?.track;
    if (track == null) return;

    try {
      await track.setCameraPosition(CameraPosition.front);
    } catch (error) {
      print('could not restart track: $error');
      return;
    }
  }

  void _enableScreenShare() async {
    if (lkPlatformIsDesktop()) {
      try {
        final source = await showDialog<DesktopCapturerSource>(
          context: context,
          builder: (context) => ScreenSelectDialog(),
        );

        if (source == null) return;

        print('DesktopCapturerSource: ${source.id}');
        var track = await LocalVideoTrack.createScreenShareTrack(
          ScreenShareCaptureOptions(sourceId: source.id, maxFrameRate: 15.0),
        );
        await participant.publishVideoTrack(track);
      } catch (e) {
        print('could not publish video: $e');
      }
      return;
    }
    if (lkPlatformIs(PlatformType.android)) {
      // Android specific
      bool hasCapturePermission = await Helper.requestCapturePermission();
      if (!hasCapturePermission) {
        return;
      }

      requestBackgroundPermission([bool isRetry = false]) async {
        // Required for android screenshare.
        try {
          bool hasPermissions = await FlutterBackground.hasPermissions;
          if (!isRetry) {
            const androidConfig = FlutterBackgroundAndroidConfig(
              notificationTitle: 'Screen Sharing',
              notificationText: 'LiveKit Example is sharing the screen.',
              notificationImportance: AndroidNotificationImportance.normal,
              notificationIcon: AndroidResource(name: 'livekit_ic_launcher', defType: 'mipmap'),
            );
            hasPermissions = await FlutterBackground.initialize(androidConfig: androidConfig);
          }
          if (hasPermissions && !FlutterBackground.isBackgroundExecutionEnabled) {
            await FlutterBackground.enableBackgroundExecution();
          }
        } catch (e) {
          if (!isRetry) {
            return await Future<void>.delayed(const Duration(seconds: 1), () => requestBackgroundPermission(true));
          }
          print('could not publish video: $e');
        }
      }

      await requestBackgroundPermission();
    }

    if (lkPlatformIsWebMobile()) {
      await context.showErrorDialog('Screen share is not supported on mobile web');
      return;
    }
    await participant.setScreenShareEnabled(true, captureScreenAudio: true);
  }

  void _disableScreenShare() async {
    await participant.setScreenShareEnabled(false);

    if (lkPlatformIs(PlatformType.android)) {
      // Android specific
      try {
        await FlutterBackground.disableBackgroundExecution();
      } catch (error) {
        print('error disabling screen share: $error');
      }
    }
  }

  void _onTapDisconnect() async {
    final result = await context.showDisconnectDialog();
    if (result == true) await widget.room.disconnect();
  }

  void _onTapUpdateSubscribePermission() async {
    final result = await context.showSubscribePermissionDialog();
    if (result != null) {
      try {
        widget.room.localParticipant?.setTrackSubscriptionPermissions(allParticipantsAllowed: result);
      } catch (error) {
        await context.showErrorDialog(error);
      }
    }
  }

  void _onTapSimulateScenario() async {
    final result = await context.showSimulateScenarioDialog();
    if (result != null) {
      print('${result}');

      if (SimulateScenarioResult.e2eeKeyRatchet == result) {
        await widget.room.e2eeManager?.ratchetKey();
      }

      if (SimulateScenarioResult.participantMetadata == result) {
        widget.room.localParticipant?.setMetadata('new metadata ${widget.room.localParticipant?.identity}');
      }

      if (SimulateScenarioResult.participantName == result) {
        widget.room.localParticipant?.setName('new name for ${widget.room.localParticipant?.identity}');
      }

      await widget.room.sendSimulateScenario(
        speakerUpdate: result == SimulateScenarioResult.speakerUpdate ? 3 : null,
        signalReconnect: result == SimulateScenarioResult.signalReconnect ? true : null,
        fullReconnect: result == SimulateScenarioResult.fullReconnect ? true : null,
        nodeFailure: result == SimulateScenarioResult.nodeFailure ? true : null,
        migration: result == SimulateScenarioResult.migration ? true : null,
        serverLeave: result == SimulateScenarioResult.serverLeave ? true : null,
        switchCandidate: result == SimulateScenarioResult.switchCandidate ? true : null,
      );
    }
  }

  void _onTapSendData() async {
    final result = await context.showSendDataDialog();
    if (result == true) {
      await widget.participant.publishData(
        utf8.encode('This is a sample data message'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 15,
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 5,
        runSpacing: 5,
        children: [
          if (participant.isMicrophoneEnabled())
            IconButton(
              onPressed: _disableAudio,
              icon: const Icon(Icons.mic),
              tooltip: 'mute audio',
            )
          else
            IconButton(
              onPressed: _enableAudio,
              icon: const Icon(Icons.mic_off),
              tooltip: 'un-mute audio',
            ),
          // if (participant.isCameraEnabled())
          //   IconButton(
          //     onPressed: _disableVideo,
          //     icon: const Icon(Icons.videocam),
          //     tooltip: 'mute video',
          //   )
          // else
          //   IconButton(
          //     onPressed: _enableVideo,
          //     icon: const Icon(Icons.videocam_off),
          //     tooltip: 'un-mute video',
          //   ),
          if (participant.isScreenShareEnabled())
            IconButton(
              icon: const Icon(Icons.stop_screen_share_sharp),
              onPressed: () => _disableScreenShare(),
              tooltip: 'unshare screen (experimental)',
            )
          else
            IconButton(
              icon: const Icon(Icons.screen_share_sharp),
              onPressed: () => _enableScreenShare(),
              tooltip: 'share screen (experimental)',
            ),
          IconButton(
            onPressed: _onTapDisconnect,
            icon: const Icon(Icons.call_end),
            tooltip: 'disconnect',
          ),
        ],
      ),
    );
  }
}

class ControlsUserWidget extends StatefulWidget {
  const ControlsUserWidget(
    this.room,
    this.participant, {
    super.key,
    this.onFullScreen,
  });

  //
  final Room room;
  final LocalParticipant participant;
  final VoidCallback? onFullScreen;

  @override
  State<StatefulWidget> createState() => _ControlsUserWidgetState();
}

class _ControlsUserWidgetState extends State<ControlsUserWidget> {
  @override
  void initState() {
    super.initState();
    participant.addListener(_onChange);
  }

  @override
  void dispose() {
    participant.removeListener(_onChange);
    super.dispose();
  }

  LocalParticipant get participant => widget.participant;

  void _onChange() {
    // trigger refresh
    setState(() {});
  }

  bool get isMuted => participant.isMuted;

  void _disableAudio() async {
    await participant.setMicrophoneEnabled(false);
  }

  Future<void> _enableAudio() async {
    await participant.setMicrophoneEnabled(true);
  }

  void _disableVideo() async {
    await participant.setCameraEnabled(
      false,
    );
  }

  void _enableVideo() async {
    if (await Permission.camera.isGranted) {
      await participant.setCameraEnabled(
        true,
      );
    } else {
      await Permission.camera.request();
    }
  }

  void _onFullScreen() {
    widget.onFullScreen?.call();
  }

  void _enableScreenShare() async {
    if (lkPlatformIsDesktop()) {
      try {
        final source = await showDialog<DesktopCapturerSource>(
          context: context,
          builder: (context) => ScreenSelectDialog(),
        );

        if (source == null) return;

        var track = await LocalVideoTrack.createScreenShareTrack(
          ScreenShareCaptureOptions(sourceId: source.id, maxFrameRate: 15.0),
        );
        await participant.publishVideoTrack(track);
      } catch (e) {
        print('could not publish video: $e');
      }
      return;
    }
    if (lkPlatformIs(PlatformType.android)) {
      // Android specific
      final hasCapturePermission = await Helper.requestCapturePermission();
      if (!hasCapturePermission) return;

      requestBackgroundPermission([bool isRetry = false]) async {
        // Required for android screenshare.
        try {
          var hasPermissions = await FlutterBackground.hasPermissions;

          if (!isRetry) {
            const androidConfig = FlutterBackgroundAndroidConfig(
              notificationTitle: 'Screen Sharing',
              notificationText: 'MMS is sharing the screen.',
              notificationImportance: AndroidNotificationImportance.normal,
              notificationIcon: AndroidResource(name: 'livekit_ic_launcher', defType: 'mipmap'),
            );

            hasPermissions = await FlutterBackground.initialize(androidConfig: androidConfig);
          }
          if (hasPermissions && !FlutterBackground.isBackgroundExecutionEnabled) {
            await FlutterBackground.enableBackgroundExecution();
          }
        } catch (e) {
          if (!isRetry) {
            return await Future<void>.delayed(const Duration(seconds: 1), () => requestBackgroundPermission(true));
          }
          print('could not publish video: $e');
        }
      }

      await requestBackgroundPermission();
    }

    if (lkPlatformIsWebMobile()) {
      await context.showErrorDialog('Screen share is not supported on mobile web');
      return;
    }
    await participant.setScreenShareEnabled(true, captureScreenAudio: true);
  }

  void _disableScreenShare() async {
    await participant.setScreenShareEnabled(false);

    if (Platform.isAndroid) {
      try {
        await FlutterBackground.disableBackgroundExecution();
      } catch (error) {
        print('error disabling screen share: $error');
      }
    }
  }

  void _onTapDisconnect() async {
    final result = await context.showDisconnectDialog();
    if (result == true) await widget.room.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, RoomInitial>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 15,
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                DynamicPopupMenu(
                  items: NotesMessages.values.map(
                    (e) {
                      return PopupMenuItemModel(
                        icon: e.icon,
                        label: e.name,
                        onTap: () {
                          context.read<RoomCubit>().sendMessage(e.name);
                        },
                      );
                    },
                  ).toList(),
                ),
                IconButton(
                  onPressed: () => _onFullScreen(),
                  icon: const Icon(Icons.fullscreen),
                  tooltip: 'enter full screen',
                ),
                IconButton(
                  onPressed: _onTapDisconnect,
                  icon: const Icon(
                    Icons.call_end,
                    color: Colors.red,
                  ),
                  tooltip: 'disconnect',
                ),
                if (!participant.permissions.canPublish) ...[
                  MyButton(
                    width: 0.5.sw,
                    onTap: () async {
                      context.read<RoomCubit>().raiseHand();
                    },
                    startIcon: state.loadingPermissions ? MyStyle.loadingWidget(size: 25.0, color: Colors.white) : null,
                    endIcon: ImageMultiType(
                      url: Icons.back_hand_outlined,
                      color: Colors.white,
                    ),
                    text: 'Request to speak',
                  ),
                ] else ...[
                  if (participant.isMicrophoneEnabled())
                    IconButton(
                      onPressed: _disableAudio,
                      icon: const Icon(
                        Icons.mic,
                        color: Colors.green,
                      ),
                      tooltip: 'mute audio',
                    )
                  else
                    IconButton(
                      onPressed: _enableAudio,
                      icon: const Icon(
                        Icons.mic_off,
                        color: Colors.red,
                      ),
                      tooltip: 'un-mute audio',
                    ),
                  if (participant.isCameraEnabled())
                    IconButton(
                      onPressed: _disableVideo,
                      icon: const Icon(
                        Icons.videocam,
                        color: Colors.green,
                      ),
                      tooltip: 'mute video',
                    )
                  else
                    IconButton(
                      onPressed: _enableVideo,
                      icon: const Icon(
                        Icons.videocam_off,
                        color: Colors.red,
                      ),
                      tooltip: 'un-mute video',
                    ),
                  if (participant.isScreenShareEnabled())
                    IconButton(
                      icon: const Icon(Icons.screen_share_sharp, color: Colors.green),
                      onPressed: () => _disableScreenShare(),
                      tooltip: 'unshare screen (experimental)',
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.stop_screen_share_sharp),
                      color: Colors.red,
                      onPressed: () => _enableScreenShare(),
                      tooltip: 'share screen (experimental)',
                    ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
