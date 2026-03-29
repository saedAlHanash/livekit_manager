import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/strings/enum_manager.dart';
import 'package:livekit_manager/features/room/ui/widget/users/focus_participants_layout.dart';
import 'package:livekit_manager/features/room/ui/widget/users/grid_participants_layout.dart';
import 'package:livekit_manager/features/room/ui/widget/users/scrollable_participants_layout.dart';

import '../../../bloc/room_cubit/room_cubit.dart';

class ParticipantsLayout extends StatelessWidget {
  const ParticipantsLayout({
    super.key,
    this.fit = VideoViewFit.contain,
    this.onTap,
  });

  final VideoViewFit fit;
  final Function(Participant)? onTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, RoomInitial>(
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Positioned.fill(
                  child: Builder(
                    builder: (context) {
                      switch (state.layoutMode) {
                        case ParticipantsLayoutMode.grid:
                          return GridParticipantsLayoutView();
                        case ParticipantsLayoutMode.focus:
                          return FocusParticipantsLayoutView();
                        case ParticipantsLayoutMode.scroll:
                          return ScrollableParticipantsLayout();
                      }
                    },
                  ),
                ),

                // FloatingLocalUser(
                //   constraints: constraints,
                //   localParticipant: state.result.localParticipant,
                // ),
              ],
            );
          },
        );
      },
    );
  }
}
