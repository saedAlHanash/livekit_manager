import 'dart:convert';

import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';
import 'package:livekit_manager/core/widgets/my_card_widget.dart';
import 'package:livekit_manager/features/room/data/request/setting_message.dart';

import '../../../../core/strings/enum_manager.dart';
import '../../bloc/room_cubit/room_cubit.dart';
import '../widget/sound_waveform.dart';
import '../widget/users/dynamic_user.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  RoomCubit get cubit => context.read<RoomCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RoomCubit, RoomInitial>(
        builder: (context, state) {
          return Padding(
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
                            onPressed: cubit.disconnect,
                            icon: const Icon(Icons.call_end),
                            tooltip: 'disconnect',
                          ),
                        ),
                        Divider(),
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.participantTracks.length,
                            itemBuilder: (context, i) {
                              final participant = state.participantTracks[i].participant as RemoteParticipant;
                              final audio = state.participantTracks[i].activeAudioTrack;
                              final isSelected = participant.sid == state.selectedParticipantTrack?.participant.sid;
                              return MyCardWidget(
                                cardColor: isSelected ? AppColorManager.mainColor.withValues(alpha: 0.2) : null,
                                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0).w,
                                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 7.0).w,
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        cubit.selectParticipant(participant.sid);
                                      },
                                      child: Container(
                                        height: 80.0.dg,
                                        width: 80.0.dg,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColorManager.scaffoldColor,
                                        ),
                                        clipBehavior: Clip.hardEdge,
                                        child: DynamicUser(participantTrack: state.participantTracks[i]),
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
                                                  localParticipant: state.result.localParticipant,
                                                ),
                                                _Switch(
                                                  participant: participant,
                                                  action: ManagerActions.mic,
                                                  localParticipant: state.result.localParticipant,
                                                ),
                                                _Switch(
                                                  participant: participant,
                                                  action: ManagerActions.shareScreen,
                                                  localParticipant: state.result.localParticipant,
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
                if (state.selectedParticipantTrack != null)
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: DynamicUser(participantTrack: state.selectedParticipantTrack!),
                    ),
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Switch extends StatelessWidget {
  const _Switch({required this.participant, required this.action, required this.localParticipant});

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
