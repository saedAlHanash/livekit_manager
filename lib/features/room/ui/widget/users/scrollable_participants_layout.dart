import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/features/room/ui/widget/users/participant_card.dart';
import 'package:livekit_manager/features/room/ui/widget/users/floating_local_user.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';

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
        final participants = state.participantTracksWithoutMe;

        return LayoutBuilder(
          builder: (context, constraints) {

            const int crossAxisCount = 5;
            final spacing = 8.r;
            final double itemWidth = (constraints.maxWidth - (crossAxisCount + 1) * spacing) / crossAxisCount;

            final double itemHeight = itemWidth * 0.8;

            return participants.isEmpty
                ? Container()
                : SingleChildScrollView(
                    padding: EdgeInsets.all(spacing),
                    child: Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      alignment: WrapAlignment.start,
                      children: participants.map((p) {
                        return SizedBox(
                          width: itemWidth,
                          height: itemHeight,
                          child: ParticipantCard(
                            participant: p,
                            fit: widget.fit,
                            onTap: () => _handleTap(p),
                            small: true, // Use the small property added by the user
                          ),
                        );
                      }).toList(),
                    ),
                  );
          },
        );
      },
    );
  }
}
