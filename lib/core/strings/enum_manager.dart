import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';

import '../../generated/l10n.dart';

enum ApiType { get, post, put, patch, delete }

enum StartPage { login, home, confirmPassword, createPassword }

enum FontManager { regular, semeBold, bold }

enum Month {
  january,
  february,
  march,
  april,
  may,
  june,
  july,
  august,
  september,
  october,
  november,
  december;

  String get name {
    return switch (this) {
      Month.january => S().january,
      Month.february => S().february,
      Month.march => S().march,
      Month.april => S().april,
      Month.may => S().may,
      Month.june => S().june,
      Month.july => S().july,
      Month.august => S().august,
      Month.september => S().september,
      Month.october => S().october,
      Month.november => S().november,
      Month.december => S().december,
    };
  }
}

enum MediaType {
  media,
  screen;

  bool get isMedia => this == MediaType.media;

  bool get isScreen => this == MediaType.screen;

  IconData get icon {
    return switch (this) { MediaType.media => Icons.videocam, MediaType.screen => Icons.monitor };
  }

  TrackSource get videoSourceType {
    return switch (this) {
      MediaType.media => TrackSource.camera,
      MediaType.screen => TrackSource.screenShareVideo,
    };
  }

  TrackSource get audioSourceType {
    return switch (this) {
      MediaType.media => TrackSource.microphone,
      MediaType.screen => TrackSource.screenShareAudio,
    };
  }
}

enum ManagerActions {
  requestPermission,
  requestToDisconnect,
  message,
  changeScreen;

  IconData get icon {
    return switch (this) {
      ManagerActions.requestPermission => Icons.pan_tool_outlined,
      ManagerActions.requestToDisconnect => Icons.exit_to_app,
      ManagerActions.message => Icons.message,
      ManagerActions.changeScreen => Icons.screen_share_outlined,
    };
  }
}

enum LkUserType {
  manager,
  sharer,
  user;

  bool get isManager => this == LkUserType.manager;

  bool get isSharer => this == LkUserType.sharer;

  bool get isUser => this == LkUserType.user;
}

enum PermissionType {
  speak,
  listen,
  both;

  Map<String, dynamic> revokePermissions(Participant participant) {
    final Map<String, dynamic> map = switch (this) {
      PermissionType.speak => {
          "canSubscribe": participant.permissions.canSubscribe,
          "canPublish": false,
          //----------
          "canPublishData": true,
        },
      PermissionType.listen => {
          "canSubscribe": false,
          "canPublish": participant.permissions.canPublish,
          //----------
          "canPublishData": true,
        },
      PermissionType.both => {
          "canSubscribe": false,
          "canPublish": false,
          //----------
          "canPublishData": true,
        },
    };
    return map..addAll({'identity': participant.identity});
  }

  Map<String, dynamic> grantPermissions(Participant participant) {
    final Map<String, dynamic> map = switch (this) {
      PermissionType.speak => {
          "canSubscribe": participant.permissions.canSubscribe,
          "canPublish": true,
          //----------
          "canPublishData": true,
        },
      PermissionType.listen => {
          "canSubscribe": true,
          "canPublish": participant.permissions.canPublish,
          //----------
          "canPublishData": true,
        },
      PermissionType.both => {
          "canSubscribe": true,
          "canPublish": true,
          //----------
          "canPublishData": true,
        },
    };
    return map..addAll({'identity': participant.identity});
  }
}
