import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/api_manager/livekit_twirp_client.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/strings/enum_manager.dart';
import 'package:m_cubit/abstraction.dart';

import '../../../../core/api_manager/api_service.dart';
import '../../../../core/app/app_widget.dart';
import '../../../../core/util/exts.dart';
import '../../../../core/util/snack_bar_message.dart';
import '../../data/request/message_request.dart';
import '../../data/request/update_participant_request.dart';
import '../room_cubit/room_cubit.dart';

part 'user_control_state.dart';

class UserControlCubit extends MCubit<UserControlInitial> {
  UserControlCubit() : super(UserControlInitial.initial());

  final _lk = LiveKitTwirpClient();

  @override
  UserControlInitial get mState => state;

  // ---------------------------------------------------------------------------
  // Helper — resolves current room name from RoomCubit
  // ---------------------------------------------------------------------------
  String get _roomName => ctx?.read<RoomCubit>().state.result.name ?? '';

  // ---------------------------------------------------------------------------
  // Helper — emit result and optionally show error snackbar
  // ---------------------------------------------------------------------------
  void _handleResult(String? error, String id) {
    if (error != null) {
      emit(state.copyWith(statuses: CubitStatuses.error, id: id));
      if (ctx != null) {
        NoteMessage.showErrorSnackBar(message: error, context: ctx!);
      }
    } else {
      emit(state.copyWith(statuses: CubitStatuses.done, id: id));
    }
  }

  // ---------------------------------------------------------------------------
  // Suspend / Resume single participant
  // ---------------------------------------------------------------------------

  /// Suspend: revoke publish + subscribe (participant goes fully silent/blind).
  Future<void> suspend(String participant) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: participant));
    final result = await _lk.updateParticipant(
      roomName: _roomName,
      identity: participant,
      canPublish: false,
      canSubscribe: false,
    );
    _handleResult(result.second, participant);
  }

  /// Resume: keep publish off, restore subscribe (can see/hear again).
  Future<void> resume(String participant) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: participant));
    final result = await _lk.updateParticipant(
      roomName: _roomName,
      identity: participant,
      canPublish: false,
      canSubscribe: true,
    );
    _handleResult(result.second, participant);
  }

  // ---------------------------------------------------------------------------
  // Suspend / Resume ALL remote participants
  // ---------------------------------------------------------------------------

  /// Suspend all — iterates every remote participant and calls UpdateParticipant.
  Future<void> suspendAll() async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: ''));
    final participants =
        ctx?.read<RoomCubit>().state.result.remoteParticipants.values.toList() ?? [];

    String? lastError;
    for (final p in participants) {
      final result = await _lk.updateParticipant(
        roomName: _roomName,
        identity: p.identity,
        canPublish: false,
        canSubscribe: false,
      );
      if (result.second != null) lastError = result.second;
    }
    _handleResult(lastError, '');
  }

  /// Resume all — restores subscribe for every remote participant.
  Future<void> resumeAll() async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: ''));
    final participants =
        ctx?.read<RoomCubit>().state.result.remoteParticipants.values.toList() ?? [];

    String? lastError;
    for (final p in participants) {
      final result = await _lk.updateParticipant(
        roomName: _roomName,
        identity: p.identity,
        canPublish: false,
        canSubscribe: true,
      );
      if (result.second != null) lastError = result.second;
    }
    _handleResult(lastError, '');
  }

  // ---------------------------------------------------------------------------
  // Screen Share
  // ---------------------------------------------------------------------------

  /// Grant screen share: set canPublish=true (while keeping current subscribe)
  Future<void> allowScreenShare(String participant) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: participant));
    final p = ctx?.read<RoomCubit>().state.result.remoteParticipants[participant];
    final result = await _lk.updateParticipant(
      roomName: _roomName,
      identity: participant,
      canPublish: true,
      canSubscribe: p?.permissions.canSubscribe ?? true,
    );
    _handleResult(result.second, participant);
  }

  /// Revoke screen share: set canPublish=false
  Future<void> stopScreenShare(String participant) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: participant));
    final p = ctx?.read<RoomCubit>().state.result.remoteParticipants[participant];
    final result = await _lk.updateParticipant(
      roomName: _roomName,
      identity: participant,
      canPublish: false,
      canSubscribe: p?.permissions.canSubscribe ?? true,
    );
    _handleResult(result.second, participant);
  }

  // ---------------------------------------------------------------------------
  // Camera (Video track muting via MutePublishedTrack)
  // ---------------------------------------------------------------------------

  /// Allow camera — unmute the VIDEO track server-side.
  Future<void> allowCamera(String participant) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: participant));
    final result = await _lk.muteTrackByType(
      roomName: _roomName,
      identity: participant,
      trackType: 'VIDEO',
      muted: false,
    );
    _handleResult(result.second, participant);
  }

  /// Stop camera — mute the VIDEO track server-side.
  Future<void> stopCamera(String participant) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: participant));
    final result = await _lk.muteTrackByType(
      roomName: _roomName,
      identity: participant,
      trackType: 'VIDEO',
      muted: true,
    );
    _handleResult(result.second, participant);
  }

  // ---------------------------------------------------------------------------
  // Audio (Microphone track muting via MutePublishedTrack)
  // ---------------------------------------------------------------------------

  /// Allow to speak — unmute the AUDIO track server-side.
  Future<void> allowToSpeak(String participant) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: participant));
    final result = await _lk.muteTrackByType(
      roomName: _roomName,
      identity: participant,
      trackType: 'AUDIO',
      muted: false,
    );
    _handleResult(result.second, participant);
  }

  /// Mute — mute the AUDIO track server-side.
  Future<void> mute(String participant) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: participant));
    final result = await _lk.muteTrackByType(
      roomName: _roomName,
      identity: participant,
      trackType: 'AUDIO',
      muted: true,
    );
    _handleResult(result.second, participant);
  }

  // ---------------------------------------------------------------------------
  // Room Metadata
  // ---------------------------------------------------------------------------

  Future<void> updateRoomMetaData(Map<String, dynamic> metaData, String roomId) async {
    emit(state.copyWith(statuses: CubitStatuses.loading));
    final result = await _lk.updateRoomMetadata(
      roomName: roomId,
      metadata: jsonEncode(metaData),
    );
    _handleResult(result.second, '');
  }

  // ---------------------------------------------------------------------------
  // Revoke / Grant permissions (fine-grained via ParticipantPermissionType)
  // ---------------------------------------------------------------------------

  Future<void> revoke(Participant participant, ParticipantPermissionType type) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: participant));
    final perms = type.revokePermissions(participant);
    final result = await _lk.updateParticipant(
      roomName: _roomName,
      identity: participant.identity,
      canPublish: perms['can_publish'] as bool? ?? false,
      canSubscribe: perms['can_subscribe'] as bool? ?? false,
      canPublishData: perms['can_publish_data'] as bool? ?? true,
    );
    _handleResult(result.second, participant.identity);
  }

  Future<void> grant(Participant participant, ParticipantPermissionType type) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: participant));
    final perms = type.grantPermissions(participant);
    final result = await _lk.updateParticipant(
      roomName: _roomName,
      identity: participant.identity,
      canPublish: perms['can_publish'] as bool? ?? true,
      canSubscribe: perms['can_subscribe'] as bool? ?? true,
      canPublishData: perms['can_publish_data'] as bool? ?? true,
    );
    _handleResult(result.second, participant.identity);
  }

  // ---------------------------------------------------------------------------
  // Kick
  // ---------------------------------------------------------------------------

  Future<void> kick(String participant, {bool block = false}) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: participant));
    final result = await _lk.removeParticipant(
      roomName: _roomName,
      identity: participant,
    );
    // `block` flag — not supported natively by LiveKit Twirp.
    // Implement at app level if needed (e.g. maintain a blocklist in room metadata).
    _handleResult(result.second, participant);
  }

  // ---------------------------------------------------------------------------
  // Send Message / Data Signal
  // ---------------------------------------------------------------------------

  Future<void> sendMessage(MessageRequest request) async {
    final result = await _lk.sendData(
      roomName: request.roomName,
      data: request.data,
      destinationIdentities: request.identities,
    );
    if (result.second != null) {
      loggerObject.e('sendMessage error: ${result.second}');
    }
  }

  // ---------------------------------------------------------------------------
  // Local participant controls (unchanged — all SDK-side)
  // ---------------------------------------------------------------------------

  void setLocalParticipant(LocalParticipant? localParticipant) {
    emit(state.copyWith(request: localParticipant));
  }

  Future<void> toggleLocalMic() async {
    if (state.localParticipant?.isMicrophoneEnabled() == true) {
      await stopLocalMic();
    } else {
      await startLocalMic();
    }
  }

  Future<void> stopLocalMic() async {
    await state.localParticipant?.setMicrophoneEnabled(false);
  }

  Future<void> startLocalMic() async {
    await state.localParticipant?.setMicrophoneEnabled(true);
  }

  Future<void> unpublishAll() async {
    final result = await ctx?.showUnPublishDialog();
    if (result == true) await state.localParticipant?.unpublishAllTracks();
  }

  Future<void> toggleLocalCamera() async {
    if (state.localParticipant?.isCameraEnabled() == true) {
      await stopLocalCamera();
    } else {
      await startLocalCamera();
    }
  }

  Future<void> stopLocalCamera() async {
    await state.localParticipant?.setCameraEnabled(false);
  }

  Future<void> startLocalCamera() async {
    await state.localParticipant?.setCameraEnabled(true);
  }

  Future<void> toggleLocalScreenShare() async {
    if (state.localParticipant?.isScreenShareEnabled() == true) {
      await stopLocalScreenShare();
    } else {
      await startLocalScreenShare();
    }
  }

  Future<void> stopLocalScreenShare() async {
    await state.localParticipant?.setScreenShareEnabled(false);

    if (lkPlatformIs(PlatformType.android)) {
      try {
        await FlutterBackground.disableBackgroundExecution();
      } catch (error) {
        loggerObject.e('error disabling screen share: $error');
      }
    }
  }

  Future<void> startLocalScreenShare() async {
    if (lkPlatformIsDesktop()) {
      try {
        final source = await showDialog<DesktopCapturerSource>(
          context: ctx!,
          builder: (context) => ScreenSelectDialog(),
        );

        if (source == null) return;

        var track = await LocalVideoTrack.createScreenShareTrack(
          ScreenShareCaptureOptions(sourceId: source.id, maxFrameRate: 15.0),
        );
        await state.localParticipant?.publishVideoTrack(track);
      } catch (e) {
        loggerObject.e('could not publish video: $e');
      }
      return;
    }
    if (lkPlatformIs(PlatformType.android)) {
      final hasCapturePermission = await Helper.requestCapturePermission();
      if (!hasCapturePermission) return;

      requestBackgroundPermission([bool isRetry = false]) async {
        try {
          bool hasPermissions = await FlutterBackground.hasPermissions;
          if (!isRetry) {
            const androidConfig = FlutterBackgroundAndroidConfig(
              notificationTitle: 'Screen Sharing',
              notificationText: 'IMS app is sharing the screen.',
              notificationImportance: AndroidNotificationImportance.normal,
            );
            hasPermissions = await FlutterBackground.initialize(androidConfig: androidConfig);
          }
          if (hasPermissions && !FlutterBackground.isBackgroundExecutionEnabled) {
            await FlutterBackground.enableBackgroundExecution();
          }
        } catch (e) {
          loggerObject.e('could not publish video: $e');
          if (isRetry) return;
          return await Future.delayed(
            Duration(seconds: 1),
            () => requestBackgroundPermission(true),
          );
        }
      }

      await requestBackgroundPermission();
    }

    if (lkPlatformIsWebMobile()) {
      await ctx?.showErrorDialog('Screen share is not supported on mobile web');
      return;
    }

    await state.localParticipant?.setScreenShareEnabled(true, captureScreenAudio: true);
  }

  Future<void> unsubscribeRemoteUserAudio(Participant participant) async {
    if (participant is! RemoteParticipant) return;
    for (var publication in participant.audioTrackPublications) {
      await publication.disable();
    }
  }

  Future<void> subscribeRemoteUserAudio(Participant participant) async {
    if (participant is! RemoteParticipant) return;
    for (var publication in participant.audioTrackPublications) {
      await publication.enable();
    }
  }

  Future<void> toggleRemoteUserAudio(List<Participant> participants) async {
    if (participants.isEmpty) return;

    final isAudioEnabled = participants.any((element) => element.isAudioEnabled);

    emit(state.copyWith(statuses: CubitStatuses.loading));

    for (var p in participants) {
      if (isAudioEnabled) {
        await unsubscribeRemoteUserAudio(p);
      } else {
        await subscribeRemoteUserAudio(p);
      }
    }
    emit(state.copyWith(statuses: CubitStatuses.done));
  }
}
