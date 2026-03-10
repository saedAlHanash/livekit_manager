import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/features/room/bloc/room_cubit/room_cubit.dart';
import 'package:livekit_manager/features/room/ui/widget/users/participant_card.dart';
import 'package:collection/collection.dart';

class FocusParticipantsLayoutView extends StatelessWidget {
  const FocusParticipantsLayoutView({
    super.key,

    this.onTap,
  });

  final Function(Participant)? onTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, RoomInitial>(
      builder: (context, state) {
        final participants = state.participantTracksWithoutMe;
        final allMembers = state.allRoomMembers;

        if (allMembers.isEmpty) return Container();

        final speaker = state.selectedParticipant ?? (participants.isNotEmpty ? participants.first : null);
        
        final speakerMember = speaker != null 
             ? allMembers.firstWhereOrNull((m) => m.identity == speaker.identity) 
             : allMembers.first;

        if (speakerMember == null) return Container();

        final sidebarParticipants = allMembers.where((p) => p.identity != speakerMember.identity).toList();
        return Row(
          children: [
            // Master View (75%)
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.all(8.r),
                child: ParticipantCard(
                  participant: speakerMember.participant,
                  user: speakerMember.user,
                  fit: .contain,
                  isMaster: true,
                  onTap: () => speakerMember.participant != null ? onTap?.call(speakerMember.participant!) : null,
                ),
              ),
            ),
            // Sidebar (25% or fixed width)
            if (sidebarParticipants.isNotEmpty)
              SizedBox(
                width: 150.w,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  itemCount: sidebarParticipants.length,
                  itemBuilder: (context, index) {
                    final p = sidebarParticipants[index];
                    return Container(
                      height: 120.h,
                      margin: EdgeInsets.only(bottom: 8.h, right: 8.w),
                      child: ParticipantCard(
                        participant: p.participant,
                        user: p.user,
                        fit: .contain,
                        onTap: () => p.participant != null ? onTap?.call(p.participant!) : null,
                        small: true,
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
