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
  mic,
  video,
  shareScreen,
  raseHand;

  IconData get icon {
    return switch (this) {
      ManagerActions.mic => Icons.mic,
      ManagerActions.video => Icons.videocam,
      ManagerActions.shareScreen => Icons.screen_share,
      ManagerActions.raseHand => Icons.front_hand,
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
