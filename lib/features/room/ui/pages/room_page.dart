import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/api_manager/api_service.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: cubit.disconnect,
        backgroundColor: Colors.red,
        child: const Icon(Icons.call_end, color: Colors.white),
      ),
      body: BlocBuilder<RoomCubit, RoomInitial>(
        builder: (context, state) {
          loggerObject.i(state.raiseHands);
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.participantTracks.length,
                    padding: EdgeInsets.all(15.0),
                    itemBuilder: (context, i) {
                      final participant = state.participantTracks[i].participant as RemoteParticipant;
                      final audio = state.participantTracks[i].activeAudioTrack;
                      final isSelected = participant.sid == state.selectedParticipantTrack?.participant.sid;
                      // loggerObject.w('''
                      // state.participantTracks[i].activeVideoTrack:${state.participantTracks[i].activeVideoTrack?.isActive}
                      // state.participantTracks[i].activeAudioTrack:${state.participantTracks[i].activeAudioTrack?.isActive}
                      // ''');
                      return Container(
                        height: 120.0.h,
                        decoration: BoxDecoration(
                          color: AppColorManager.appBarColor,
                          borderRadius: BorderRadius.circular(12.0).r,
                          border: Border.all(
                              color: isSelected ? AppColorManager.mainColor : Colors.transparent, width: 3.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: ClipRRect(
                          clipBehavior: Clip.hardEdge,
                          borderRadius: BorderRadius.circular(12.0).r,
                          child: Stack(
                            alignment: AlignmentGeometry.center,
                            children: [
                              DynamicUser(
                                participantTrack: state.participantTracks[i],
                                fit: VideoViewFit.cover,
                              ),
                              if (audio != null)
                                Align(
                                  alignment: AlignmentGeometry.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: SoundWaveformWidget(
                                      key: ValueKey(audio.hashCode),
                                      audioTrack: audio,
                                      barCount: 3,
                                    ),
                                  ),
                                ),
                              if (state.raiseHands.contains(participant.sid))
                                Align(
                                  alignment: AlignmentGeometry.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: ImageMultiType(
                                      url: Icons.back_hand_outlined,
                                      width: 18.0.w,
                                    ),
                                  ),
                                ),
                              if (participant.userType.isSharer)
                                Align(
                                  alignment: AlignmentGeometry.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: ImageMultiType(
                                      url: Icons.screenshot_monitor,
                                      width: 18.0.w,
                                    ),
                                  ),
                                ),
                              Align(
                                alignment: AlignmentGeometry.bottomCenter,
                                child: _Switch(participant: participant),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (state.selectedParticipantTrack != null)
                  Expanded(
                    flex: 5,
                    child: Container(
                      height: 1.0.sh,
                      decoration: BoxDecoration(
                        color: AppColorManager.appBarColor,
                        borderRadius: BorderRadius.circular(12.0).r,
                      ),
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
  const _Switch({required this.participant});

  final RemoteParticipant participant;

  @override
  Widget build(BuildContext context) {
    final l = ManagerActions.values.where((e) => e != ManagerActions.raseHand);
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: l.map(
          (e) {
            return InkWell(
              onTap: () {
                context.read<RoomCubit>().state.result.localParticipant?.publishData(
                      utf8.encode(
                        jsonEncode(
                          SettingMessage(
                            sid: participant.sid,
                            name: participant.name,
                            action: e,
                          ),
                        ),
                      ),
                    );
              },
              child: ImageMultiType(
                url: e.icon,
                height: 15.0.r,
                width: 15.0.r,
                color: switch (e) {
                  ManagerActions.mic => participant.isMicrophoneEnabled(),
                  ManagerActions.video => participant.isCameraEnabled(),
                  ManagerActions.shareScreen => participant.isScreenShareEnabled(),
                  ManagerActions.raseHand => true,
                }
                    ? Colors.green
                    : Colors.red,
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
