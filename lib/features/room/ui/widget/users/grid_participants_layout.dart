import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/features/room/bloc/room_cubit/room_cubit.dart';
import 'package:livekit_manager/features/room/ui/widget/users/participant_card.dart';

import '../../../../../core/extensions/extensions.dart';

class GridParticipantsLayoutView extends StatelessWidget {
  const GridParticipantsLayoutView({
    super.key,
    this.onTap,
  });

  final Function(Participant)? onTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, RoomInitial>(
      builder: (context, state) {
        final participants = state.participantTracksWithoutMe;

        if (participants.isEmpty) return Container();
        return LayoutBuilder(
          builder: (context, constraints) {
            final count = participants.length;
            final crossAxisCount = count <= 1 ? 1 : (count <= 4 ? 2 : 3);
            final rows = (count / crossAxisCount).ceil();

            final spacing = 8.r;
            final itemWidth = (constraints.maxWidth - (crossAxisCount + 1) * spacing) / crossAxisCount;
            final itemHeight = (constraints.maxHeight - (rows + 1) * spacing) / rows;

            return Padding(
              padding: EdgeInsets.all(spacing),
              child: Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: participants.map((p) {
                  return SizedBox(
                    width: itemWidth,
                    height: itemHeight,
                    child: ParticipantCard(
                      participant: p,
                      fit: .contain,
                      onTap: () => onTap?.call(p),
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
