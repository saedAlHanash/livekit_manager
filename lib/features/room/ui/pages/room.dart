import 'package:flutter/material.dart';

class RoomPage1 extends StatelessWidget {
  const RoomPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

/*
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

  List<Participant> participantTracks = [];

  List<Participant> get participantTracksWithoutSelected => participantTracks
      .where((e) => e.sid != selectedParticipant.sid)
      .toList(growable: false);

  Participant get selectedParticipant =>
      participantTracks.firstWhereOrNull((e) => e.sid == selectedUserId) ?? participantTracks.first;

  EventsListener<RoomEvent> get _listener => widget.listener;

  bool get fastConnection => widget.room.engine.fastConnectOptions != null;

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
    ..on<DataReceivedEvent>((event) {
      String decoded = 'Failed to decode';
      try {
        decoded = utf8.decode(event.data);
      } catch (err) {
        loggerObject.i('Failed to decode: $err');
      }
      context.showDataReceivedDialog(decoded);
    })
    ..on<AudioPlaybackStatusChanged>((event) async {
      if (!widget.room.canPlaybackAudio) {
        loggerObject.i('Audio playback failed for iOS Safari ..........');
        bool? yesno = await context.showPlayAudioManuallyDialog();
        if (yesno == true) {
          await widget.room.startAudio();
        }
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
    List<Participant> userMediaTracks = [];
    List<Participant> screenTracks = [];
    for (var participant in widget.room.remoteParticipants.values) {
      for (var t in participant.videoTrackPublications) {
        if (t.isScreenShare) {
          screenTracks.add(Participant(
            participant: participant,
            type: MediaType.screen,
          ));
        } else {
          userMediaTracks.add(Participant(participant: participant));
        }
      }
    }
    // sort speakers for the grid
    userMediaTracks.sort((a, b) {
      // loudest speaker first
      if (a.isSpeaking && b.isSpeaking) {
        if (a.audioLevel > b.audioLevel) {
          return -1;
        } else {
          return 1;
        }
      }

      // last spoken at
      final aSpokeAt = a.lastSpokeAt?.millisecondsSinceEpoch ?? 0;
      final bSpokeAt = b.lastSpokeAt?.millisecondsSinceEpoch ?? 0;

      if (aSpokeAt != bSpokeAt) {
        return aSpokeAt > bSpokeAt ? -1 : 1;
      }

      // video on
      if (a.hasVideo != b.hasVideo) {
        return a.hasVideo ? -1 : 1;
      }

      // joinedAt
      return a.joinedAt.millisecondsSinceEpoch - b.joinedAt.millisecondsSinceEpoch;
    });

    final localParticipants = widget.room.localParticipant?.videoTrackPublications;
    if (localParticipants != null) {
      for (var t in localParticipants) {
        if (t.isScreenShare) {
          screenTracks.add(Participant(
            participant: widget.room.localParticipant!,
            type: MediaType.screen,
          ));
        } else {
          userMediaTracks.add(Participant(participant: widget.room.localParticipant!));
        }
      }
    }
    setState(() {
      participantTracks = [...screenTracks, ...userMediaTracks];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: participantTracks.isNotEmpty
                    ? DynamicUser(participantTrack: selectedParticipant)
                    : Container(),
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
              width: 0.2.sw,
              child: ListView.builder(
                itemCount: math.max(0, participantTracksWithoutSelected.length),
                itemBuilder: (context, i) {
                  final item = participantTracksWithoutSelected[i];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        loggerObject.i(item.name);
                        selectedUserId = item.sid;
                      });
                    },
                    child: SizedBox(
                      width: 180,
                      height: 120,
                      child: DynamicUser(participantTrack: item),
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
*/
