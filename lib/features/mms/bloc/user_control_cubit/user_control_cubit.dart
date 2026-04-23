import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/api_manager/api_service.dart';
import 'package:livekit_manager/core/api_manager/api_url.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/strings/enum_manager.dart';
import 'package:m_cubit/abstraction.dart';

import '../../../../core/app/app_widget.dart';
import '../../../../core/util/exts.dart';
import '../../data/request/message_request.dart';
import '../../data/request/update_participant_request.dart';

part 'user_control_state.dart';

class MMSUserControlCubit extends MCubit<MMSUserControlInitial> {
  MMSUserControlCubit() : super(MMSUserControlInitial.initial());

  @override
  MMSUserControlInitial get mState => state;

  Future<void> suspend(String participant) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: participant));
    final result = await APIService().callApi(
      url: PostUrl.suspend,
      type: ApiType.post,
      hostName: mmsLkManageUrl,
      additional: lkAdditional,
      body: state.updateRequest.toJson(state.room?.name)..addAll({'identity': participant}),
    );
    emit(state.copyWith(statuses: result.statusCode.success ? CubitStatuses.done : CubitStatuses.error));
  }

  Future<void> resume(String participant) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: participant));
    final result = await APIService().callApi(
      url: PostUrl.resume,
      type: ApiType.post,
      hostName: mmsLkManageUrl,
      additional: lkAdditional,
      body: state.updateRequest.toJson(state.room?.name)..addAll({'identity': participant}),
    );
    emit(state.copyWith(statuses: result.statusCode.success ? CubitStatuses.done : CubitStatuses.error));
  }

  Future<void> suspendAll() async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: ''));
    final result = await APIService().callApi(
      url: PostUrl.suspendAll,
      type: ApiType.post,
      hostName: mmsLkManageUrl,
      additional: lkAdditional,
      body: state.updateRequest.toJson(state.room?.name),
    );
    emit(state.copyWith(statuses: result.statusCode.success ? CubitStatuses.done : CubitStatuses.error));
  }

  Future<void> resumeAll() async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: ''));
    final result = await APIService().callApi(
      url: PostUrl.resumeAll,
      type: ApiType.post,
      hostName: mmsLkManageUrl,
      additional: lkAdditional,
      body: state.updateRequest.toJson(state.room?.name),
    );
    emit(state.copyWith(statuses: result.statusCode.success ? CubitStatuses.done : CubitStatuses.error));
  }

  Future<void> allowScreenShare(String participant) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: participant));
    final result = await APIService().callApi(
      url: PostUrl.allowScreenShare,
      type: ApiType.post,
      hostName: mmsLkManageUrl,
      additional: lkAdditional,
      body: state.updateRequest.toJson(state.room?.name)..addAll({'identity': participant}),
    );
    emit(state.copyWith(statuses: result.statusCode.success ? CubitStatuses.done : CubitStatuses.error));
  }

  Future<void> stopScreenShare(String participant) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: participant));
    final result = await APIService().callApi(
      url: PostUrl.stopScreenShare,
      type: ApiType.post,
      hostName: mmsLkManageUrl,
      additional: lkAdditional,
      body: state.updateRequest.toJson(state.room?.name)..addAll({'identity': participant}),
    );
    emit(state.copyWith(statuses: result.statusCode.success ? CubitStatuses.done : CubitStatuses.error));
  }

  Future<void> allowCamera(String participant) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: participant));
    final result = await APIService().callApi(
      url: PostUrl.allowCamera,
      type: ApiType.post,
      hostName: mmsLkManageUrl,
      additional: lkAdditional,
      body: state.updateRequest.toJson(state.room?.name)..addAll({'identity': participant}),
    );
    emit(state.copyWith(statuses: result.statusCode.success ? CubitStatuses.done : CubitStatuses.error));
  }

  Future<void> stopCamera(String participant) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: participant));
    final result = await APIService().callApi(
      url: PostUrl.stopCamera,
      type: ApiType.post,
      hostName: mmsLkManageUrl,
      additional: lkAdditional,
      body: state.updateRequest.toJson(state.room?.name)..addAll({'identity': participant}),
    );
    emit(state.copyWith(statuses: result.statusCode.success ? CubitStatuses.done : CubitStatuses.error));
  }

  Future<void> allowToSpeak(String participant) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: participant));
    final result = await APIService().callApi(
      url: PostUrl.allowAudio,
      type: ApiType.post,
      hostName: mmsLkManageUrl,
      additional: lkAdditional,
      body: state.updateRequest.toJson(state.room?.name)..addAll({'identity': participant}),
    );
    emit(state.copyWith(statuses: result.statusCode.success ? CubitStatuses.done : CubitStatuses.error));
  }

  Future<void> mute(String participant) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: participant));
    final result = await APIService().callApi(
      url: PostUrl.stopAudio,
      type: ApiType.post,
      hostName: mmsLkManageUrl,
      additional: lkAdditional,
      body: state.updateRequest.toJson(state.room?.name)..addAll({'identity': participant}),
    );
    emit(state.copyWith(statuses: result.statusCode.success ? CubitStatuses.done : CubitStatuses.error));
  }

  Future<void> updateRoomMetaData(Map<String, dynamic> metaData, String roomId) async {
    emit(state.copyWith(statuses: CubitStatuses.loading));
    final result = await APIService().callApi(
      url: PostUrl.updateRoomMeta,
      type: ApiType.post,
      hostName: mmsLkManageUrl,
      additional: lkAdditional,
      body: {"name": roomId, "metadata": jsonEncode(metaData)},
    );
    emit(state.copyWith(statuses: result.statusCode.success ? CubitStatuses.done : CubitStatuses.error));
  }

  Future<void> revoke(Participant participant, PermissionType type) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: participant));
    final result = await APIService().callApi(
      url: 'Index/UpdateParticipant',
      type: ApiType.post,
      hostName: mmsLkManageUrl,
      additional: lkAdditional,
      body: state.updateRequest.toJson(state.room?.name)
        ..addAll(
          type.revokePermissions(participant),
        ),
    );
    emit(state.copyWith(statuses: result.statusCode.success ? CubitStatuses.done : CubitStatuses.error));
  }

  Future<void> grant(Participant participant, PermissionType type) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: participant));
    final result = await APIService().callApi(
      url: 'Index/UpdateParticipant',
      type: ApiType.post,
      hostName: mmsLkManageUrl,
      additional: lkAdditional,
      body: state.updateRequest.toJson(state.room?.name)
        ..addAll(
          type.grantPermissions(participant),
        ),
    );
    emit(state.copyWith(statuses: result.statusCode.success ? CubitStatuses.done : CubitStatuses.error));
  }

  Future<void> kick(String participant, {bool block = false}) async {
    emit(state.copyWith(statuses: CubitStatuses.loading, id: participant));
    final result = await APIService().callApi(
      url: PostUrl.kick,
      type: ApiType.post,
      hostName: mmsLkManageUrl,
      additional: lkAdditional,
      body: state.updateRequest.toJson(state.room?.name)
        ..addAll(
          {
            'identity': participant,
            if (block) 'isBlock': true,
          },
        ),
    );
    emit(state.copyWith(statuses: result.statusCode.success ? CubitStatuses.done : CubitStatuses.error));
  }

  Future<void> sendMessage(MessageRequest request) async {
    await APIService().callApi(
      url: PostUrl.sendMessage,
      type: ApiType.post,
      hostName: mmsLkManageUrl,
      additional: lkAdditional,
      body: request.toJson(),
    );
  }

  //---------------------Local----------------------

  void setRoom(Room? room) {
    emit(state.copyWith(request: room));
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
