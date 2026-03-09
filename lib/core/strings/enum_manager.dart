import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';

import '../../generated/l10n.dart';
import 'app_color_manager.dart';

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
  december
  ;

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
  screen
  ;

  bool get isMedia => this == MediaType.media;

  bool get isScreen => this == MediaType.screen;

  IconData get icon {
    return switch (this) {
      MediaType.media => Icons.videocam,
      MediaType.screen => Icons.monitor,
    };
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
  achievement,
  message,
  chosen,
  ;

  IconData get icon {
    return switch (this) {
      ManagerActions.requestPermission => Icons.pan_tool_outlined,
      ManagerActions.achievement => Icons.star,
      ManagerActions.chosen => Icons.select_all,
      ManagerActions.message => Icons.message,
    };
  }
}

enum LkUserType {
  manager,
  sharer,
  user
  ;

  bool get isManager => this == LkUserType.manager;

  bool get isSharer => this == LkUserType.sharer;

  bool get isUser => this == LkUserType.user;
}

enum PermissionType {
  speak,
  listen,
  both
  ;

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

enum UserType {
  student,
  staff,
  schoolmaster,
  ;

  static UserType getByNameOrIndex(String name) {
    final index = int.tryParse(name);

    if (index != null) {
      return UserType.values[index];
    }

    switch (name.toLowerCase()) {
      case 'student':
        return student;
      case 'staff':
        return staff;
      case 'schoolmaster':
        return schoolmaster;
    }
    return student;
  }

  bool get isStudent => this == UserType.student;

  bool get isStaff => this == UserType.staff;
}

enum SignalRStatus {
  connected,
  reconnecting,
  notConnected
  ;

  Color get getColor {
    switch (this) {
      case SignalRStatus.connected:
        return AppColorManager.green;
      case SignalRStatus.reconnecting:
        return AppColorManager.ampere;
      case SignalRStatus.notConnected:
        return AppColorManager.red;
    }
  }
}

enum SignalStudentStatus { nun, add, remove }

enum SignalMessageType {
  notification,
  closedExam,
  startExam
  ;

  bool get isNotification => this == notification;

  bool get isStartExam => this == startExam;

  bool get isClosedExam => this == closedExam;
}

enum PageType {
  manager,
  sharer,
  teacher,
}

enum ParticipantsLayoutMode { grid, focus, scroll }
