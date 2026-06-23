import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';import 'package:m_cubit/util.dart';
import 'package:livekit_manager/features/room/ui/widget/users/participant_card.dart';

import '../../../bloc/room_cubit/room_cubit.dart';

class ScrollableParticipantsLayout extends StatefulWidget {
  const ScrollableParticipantsLayout({
    super.key,
    this.fit = VideoViewFit.contain,
    this.onTap,
  });

  final VideoViewFit fit;
  final Function(Participant)? onTap;

  @override
  State<ScrollableParticipantsLayout> createState() => _ScrollableParticipantsLayoutState();
}

class _ScrollableParticipantsLayoutState extends State<ScrollableParticipantsLayout> {
  void _handleTap(Participant p) {
    if (widget.onTap != null) {
      widget.onTap!(p);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, RoomInitial>(
      builder: (context, state) {
        final members = state.allRoomMembers;

        return LayoutBuilder(
          builder: (context, constraints) {
            final double spacing = 8.r;
            final double maxExtent = 180.0.dg;

            return members.isEmpty
                ? const SizedBox.shrink()
                : GridView.builder(
                    padding: EdgeInsets.all(spacing),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: maxExtent,
                      crossAxisSpacing: spacing,
                      mainAxisSpacing: spacing,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      final m = members[index];
                      return ParticipantCard(
                        participant: m.participant,
                        user: m.user,
                        fit: widget.fit,
                        onTap: () => m.participant != null ? _handleTap(m.participant!) : null,
                        small: true,
                      );
                    },
                  );
          },
        );
      },
    );
  }
}
