import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/api_manager/api_service.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';
import 'package:livekit_manager/core/util/exts.dart';
import 'package:livekit_manager/core/widgets/my_card_widget.dart';
import 'package:livekit_manager/features/room/data/request/setting_message.dart';

import '../../../../core/strings/enum_manager.dart';
import '../widget/participant_info.dart';
import '../widget/sound_waveform.dart';
import '../widget/users/dynamic_user.dart';

class RoomPage extends StatefulWidget {
  const RoomPage(
    this.room,
    this.listener, {
    super.key,
  });

  final Room room;
  final EventsListener<RoomEvent> listener;

  @override
  State<StatefulWidget> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  List<ParticipantTrack> participantTracks = [];
  String? selectedUserId;

  List<ParticipantTrack> get participantTracksWithoutSelected => participantTracks
      .where((e) => e.participant.sid != selectedParticipantTrack?.participant.sid)
      .toList(growable: false);

  ParticipantTrack? get selectedParticipantTrack =>
      participantTracks.firstWhereOrNull((e) => e.participant.sid == selectedUserId) ?? participantTracks.firstOrNull;

  EventsListener<RoomEvent> get _listener => widget.listener;

  @override
  void initState() {
    super.initState();
    // add callback for a `RoomEvent` as opposed to a `ParticipantEvent`
    widget.room.addListener(_sortParticipants);
    // add callbacks for finer grained events
    _setUpListeners();
    _sortParticipants();
  }

  @override
  void dispose() {
    // always dispose listener
    (() async {
      widget.room.removeListener(_sortParticipants);
      await _listener.dispose();
      await widget.room.dispose();
    })();

    super.dispose();
  }

  /// for more information, see [event types](https://docs.livekit.io/client/events/#events)
  void _setUpListeners() => _listener
    ..on<RoomDisconnectedEvent>((event) async {
      WidgetsBindingCompatible.instance
          ?.addPostFrameCallback((timeStamp) => Navigator.popUntil(context, (route) => route.isFirst));
    })
    ..on<ParticipantEvent>((event) {
      _sortParticipants();
    })
    ..on<RoomRecordingStatusChanged>((event) {
      context.showRecordingStatusChangedDialog(event.activeRecording);
    })
    ..on<LocalTrackPublishedEvent>((_) => _sortParticipants())
    ..on<LocalTrackUnpublishedEvent>((_) => _sortParticipants())
    ..on<TrackSubscribedEvent>((_) => _sortParticipants())
    ..on<TrackUnsubscribedEvent>((_) => _sortParticipants())
    ..on<ParticipantNameUpdatedEvent>((event) {
      _sortParticipants();
    })
    ..on<DataReceivedEvent>((event) {
      try {
        final message = SettingMessage.fromJson(jsonDecode(utf8.decode(event.data)));
        if (message.sid != widget.room.localParticipant?.sid) return;
      } catch (err) {
        loggerObject.i('Failed to decode: $err');
      }
    })
    ..on<AudioPlaybackStatusChanged>((event) async {
      if (!widget.room.canPlaybackAudio) {
        final yesno = await context.showPlayAudioManuallyDialog();
        if (yesno == true) {
          await widget.room.startAudio();
        }
      }
    });

  void _sortParticipants() {
    List<ParticipantTrack> userMediaTracks = [];
    List<ParticipantTrack> screenTracks = [];
    for (var participant in widget.room.remoteParticipants.values) {
      screenTracks.add(
        ParticipantTrack(
          participant: participant,
          type: participant.videoTrackPublications.any((e) => e.isScreenShare) ? MediaType.screen : MediaType.media,
        ),
      );
    }
    // sort speakers for the grid
    userMediaTracks.sort((a, b) {
      // loudest speaker first
      if (a.participant.isSpeaking && b.participant.isSpeaking) {
        if (a.participant.audioLevel > b.participant.audioLevel) {
          return -1;
        } else {
          return 1;
        }
      }

      // last spoken at
      final aSpokeAt = a.participant.lastSpokeAt?.millisecondsSinceEpoch ?? 0;
      final bSpokeAt = b.participant.lastSpokeAt?.millisecondsSinceEpoch ?? 0;

      if (aSpokeAt != bSpokeAt) {
        return aSpokeAt > bSpokeAt ? -1 : 1;
      }

      // video on
      if (a.participant.hasVideo != b.participant.hasVideo) {
        return a.participant.hasVideo ? -1 : 1;
      }

      // joinedAt
      return a.participant.joinedAt.millisecondsSinceEpoch - b.participant.joinedAt.millisecondsSinceEpoch;
    });

    setState(() {
      participantTracks = [...screenTracks, ...userMediaTracks];
    });
  }

  void _onTapDisconnect() async {
    final result = await context.showDisconnectDialog();
    if (result == true) await widget.room.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                color: AppColorManager.appBarColor,
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    DrawableText(
                      text: 'Online users ',
                      matchParent: true,
                      size: 25.0.sp,
                      drawableEnd: IconButton(
                        onPressed: _onTapDisconnect,
                        icon: const Icon(Icons.call_end),
                        tooltip: 'disconnect',
                      ),
                    ),
                    Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: participantTracks.length,
                        itemBuilder: (context, i) {
                          final participant = participantTracks[i].participant as RemoteParticipant;
                          final audio = participantTracks[i].activeAudioTrack;
                          final isSelected = participant.sid == selectedParticipantTrack?.participant.sid;
                          return MyCardWidget(
                            cardColor: isSelected ? AppColorManager.mainColor.withValues(alpha: 0.2) : null,
                            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0).w,
                            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 7.0).w,
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedUserId = participant.sid;
                                    });
                                  },
                                  child: Container(
                                    height: 80.0.dg,
                                    width: 80.0.dg,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColorManager.scaffoldColor,
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: DynamicUser(participantTrack: participantTracks[i]),
                                  ),
                                ),
                                15.0.horizontalSpace,
                                Expanded(
                                  child: Column(
                                    children: [
                                      DrawableText(
                                        text: participant.name,
                                        matchParent: true,
                                        drawablePadding: 5.0,
                                        drawableStart: participant.connectionQuality.icon,
                                      ),
                                      if (participant.userType.isUser)
                                        Row(
                                          children: [
                                            _Switch(
                                              participant: participant,
                                              action: ManagerActions.video,
                                              localParticipant: widget.room.localParticipant,
                                            ),
                                            _Switch(
                                              participant: participant,
                                              action: ManagerActions.mic,
                                              localParticipant: widget.room.localParticipant,
                                            ),
                                            _Switch(
                                              participant: participant,
                                              action: ManagerActions.shareScreen,
                                              localParticipant: widget.room.localParticipant,
                                            ),
                                          ],
                                        )
                                      else
                                        DrawableText(text: 'VMW device'),
                                    ],
                                  ),
                                ),
                                if (audio != null)
                                  Container(
                                    child: SoundWaveformWidget(
                                      key: ValueKey(audio.hashCode),
                                      audioTrack: audio,
                                      width: 8,
                                      barCount: 3,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (selectedParticipantTrack != null)
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: DynamicUser(participantTrack: selectedParticipantTrack!),
                ),
              )
          ],
        ),
      ),
    );
  }
}

class _Switch extends StatelessWidget {
  const _Switch({super.key, required this.participant, required this.action, required this.localParticipant});

  final RemoteParticipant participant;
  final LocalParticipant? localParticipant;
  final ManagerActions action;

  @override
  Widget build(BuildContext context) {
    final value = switch (action) {
      ManagerActions.mic => participant.isMicrophoneEnabled(),
      ManagerActions.video => participant.isCameraEnabled(),
      ManagerActions.shareScreen => participant.isScreenShareEnabled(),
      ManagerActions.raseHand => true,
    };

    return Transform.scale(
      scale: 0.6,
      child: Row(
        children: [
          ImageMultiType(
            url: action.icon,
            height: 40.0.r,
            width: 40.0.r,
            color: value ? Colors.green : Colors.red,
          ),
          Switch(
            value: value,
            onChanged: (value) {
              localParticipant?.publishData(
                utf8.encode(
                  jsonEncode(
                    SettingMessage(
                      sid: participant.sid,
                      name: participant.name,
                      action: action,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
