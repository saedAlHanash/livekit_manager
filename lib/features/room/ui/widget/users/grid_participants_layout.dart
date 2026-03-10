import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/api_manager/api_service.dart';
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
        final members = state.allRoomMembers;

        if (members.isEmpty) return Container();
        return LayoutBuilder(
          builder: (context, constraints) {
            final count = members.length;
            final crossAxisCount = count <= 1 ? 1 : (count <= 4 ? 4 : 5);
            final rows = (count / crossAxisCount).ceil();

            final spacing = 8.r;
            final itemWidth = (constraints.maxWidth - (crossAxisCount + 1) * spacing) / crossAxisCount;
            final itemHeight = (constraints.maxHeight - (rows + 1) * spacing) / rows;

            return Padding(
              padding: EdgeInsets.all(spacing),
              child: Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: members.map((m) {
                  if (m.participant != null) {
                    loggerObject.f(m.user?.studentName);
                  }
                  return SizedBox(
                    width: itemWidth,
                    height: itemHeight,
                    child: ParticipantCard(
                      participant: m.participant,
                      user: m.user,
                      fit: .contain,
                      onTap: m.participant != null ? () => onTap?.call(m.participant!) : null,
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
