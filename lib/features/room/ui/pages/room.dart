import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:lk_assistant/core/api_manager/api_service.dart';
import 'package:lk_assistant/core/strings/app_color_manager.dart';
import 'package:lk_assistant/core/util/exts.dart';
import 'package:lk_assistant/features/room/ui/widget/no_video.dart';

import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/utils.dart';
import '../../data/request/setting_message.dart';
import '../widget/controls.dart';
import '../widget/participant_info.dart';
import '../widget/users/dynamic_user.dart';

class RoomPage1 extends StatefulWidget {
  const RoomPage1(
    this.room,
    this.listener, {
    super.key,
  });

  final Room room;
  final EventsListener<RoomEvent> listener;

  @override
  State<StatefulWidget> createState() => _RoomPage1State();
}

class _RoomPage1State extends State<RoomPage1> {
  String? selectedUserId;

  List<Participant> participants = [];

  EventsListener<RoomEvent> get _listener => widget.listener;

  bool get fastConnection => widget.room.engine.fastConnectOptions != null;

  List<Participant> get participantTracksWithoutSelected =>
      participants.where((e) => e.identity != selectedParticipant?.identity).toList(growable: false);

  Participant? get selectedParticipant =>
      participants.firstWhereOrNull((e) => e.identity == selectedUserId) ?? participants.firstOrNull;

  @override
  void initState() {
    super.initState();
    // add callback for a `RoomEvent` as opposed to a `ParticipantEvent`
    widget.room.addListener(_onRoomDidUpdate);
    // add callbacks for finer grained events
    _setUpListeners();
    _sortParticipants();
    WidgetsBindingCompatible.instance?.addPostFrameCallback((_) {
      if (!fastConnection) {
        _askPublish();
      }
    });

    if (lkPlatformIs(PlatformType.android)) {
      Hardware.instance.setSpeakerphoneOn(true);
    }

    if (lkPlatformIsDesktop()) {
      onWindowShouldClose = () async {
        unawaited(widget.room.disconnect());
        await _listener.waitFor<RoomDisconnectedEvent>(duration: const Duration(seconds: 5));
      };
    }
  }

  @override
  void dispose() {
    // always dispose listener
    (() async {
      widget.room.removeListener(_onRoomDidUpdate);
      await _listener.dispose();
      await widget.room.dispose();
    })();
    onWindowShouldClose = null;
    super.dispose();
  }

  /// for more information, see [event types](https://docs.livekit.io/client/events/#events)
  void _setUpListeners() => _listener
    ..on<RoomDisconnectedEvent>((event) async {
      if (event.reason != null) {
        loggerObject.i('Room disconnected: reason => ${event.reason}');
      }
      WidgetsBindingCompatible.instance
          ?.addPostFrameCallback((timeStamp) => Navigator.popUntil(context, (route) => route.isFirst));
    })
    ..on<ParticipantEvent>((event) {
      // sort participants on many track events as noted in documentation linked above
      _sortParticipants();
    })
    ..on<RoomRecordingStatusChanged>((event) {
      context.showRecordingStatusChangedDialog(event.activeRecording);
    })
    ..on<RoomAttemptReconnectEvent>((event) {
      loggerObject.i('Attempting to reconnect ${event.attempt}/${event.maxAttemptsRetry}, '
          '(${event.nextRetryDelaysInMs}ms delay until next attempt)');
    })
    ..on<LocalTrackSubscribedEvent>((event) {
      loggerObject.i('Local track subscribed: ${event.trackSid}');
    })
    ..on<LocalTrackPublishedEvent>((_) => _sortParticipants())
    ..on<LocalTrackUnpublishedEvent>((_) => _sortParticipants())
    ..on<TrackSubscribedEvent>((_) => _sortParticipants())
    ..on<TrackUnsubscribedEvent>((_) => _sortParticipants())
    ..on<TrackE2EEStateEvent>(_onE2EEStateEvent)
    ..on<ParticipantNameUpdatedEvent>((event) {
      loggerObject.i('Participant name updated: ${event.participant.identity}, name => ${event.name}');
      _sortParticipants();
    })
    ..on<ParticipantMetadataUpdatedEvent>((event) {
      loggerObject.i('Participant metadata updated: ${event.participant.identity}, metadata => ${event.metadata}');
    })
    ..on<RoomMetadataChangedEvent>((event) {
      loggerObject.i('Room metadata changed: ${event.metadata}');
    })
    ..on<DataReceivedEvent>((e) {
      try {
        final message = SettingMessage.fromJson(jsonDecode(utf8.decode(e.data)));

        loggerObject.w(message.toJson());
        if (message.identity != widget.room.localParticipant?.identity) return;

        switch (message.action) {
          case ManagerActions.mic:
            break;
          case ManagerActions.video:
            break;
          case ManagerActions.shareScreen:
            setState(() {
              selectedUserId = message.name;
            });
            break;
          case ManagerActions.raseHand:
            break;
        }
      } catch (err) {
        loggerObject.i('Failed to decode: $err');
      }
    });

  void _askPublish() async {
    final result = await context.showPublishDialog();
    if (result != true) return;
    // video will fail when running in ios simulator
    try {
      await widget.room.localParticipant?.setCameraEnabled(true);
    } catch (error) {
      loggerObject.i('could not publish video: $error');
      await context.showErrorDialog(error);
    }
    try {
      await widget.room.localParticipant?.setMicrophoneEnabled(true);
    } catch (error) {
      loggerObject.i('could not publish audio: $error');
      await context.showErrorDialog(error);
    }
  }

  void _onRoomDidUpdate() {
    _sortParticipants();
  }

  void _onE2EEStateEvent(TrackE2EEStateEvent e2eeState) {
    loggerObject.i('e2ee state: $e2eeState');
  }

  void _sortParticipants() {
    List<Participant> screenTracks = [];

    for (var participant in widget.room.remoteParticipants.values) {
      if (participant.videoTrackPublications.isNotEmpty) {
        screenTracks.add(participant);
      }
    }

    final localParticipantTracks = widget.room.localParticipant?.videoTrackPublications;
    if (localParticipantTracks != null) {
      screenTracks.add(widget.room.localParticipant!);
    }

    setState(() {
      participants = [...screenTracks];
    });
  }

  @override
  Widget build(BuildContext context) {
    loggerObject.w(participants.length);
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: selectedParticipant != null ? DynamicUser(participant: selectedParticipant!) : NoVideoWidget(),
              ),
              if (widget.room.localParticipant != null)
                SafeArea(
                  child: ControlsWidget(
                    widget.room,
                    widget.room.localParticipant!,
                  ),
                ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: math.max(0, participantTracksWithoutSelected.length),
                itemBuilder: (context, i) {
                  final item = participantTracksWithoutSelected[i];
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: AppColorManager.appBarColor,
                    ),
                    clipBehavior: Clip.hardEdge,
                    width: 180.0.dg,
                    height: 120.0.dg,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          loggerObject.i(item.name);
                          selectedUserId = item.identity;
                        });
                      },
                      child: DynamicUser(participant: item),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
