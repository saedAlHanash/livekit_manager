import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';

import '../../../bloc/room_cubit/room_cubit.dart';
import '../users/participant_card.dart';

class GroupStudents extends StatelessWidget {
  const GroupStudents({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, RoomInitial>(
      builder: (context, state) {
        final members = state.participants;
        if (members.isEmpty) return const SizedBox.shrink();

        return LayoutBuilder(
          builder: (context, constraints) {
            final spacing = 8.r;

            // زيادة عدد الأعمدة كلما زاد عدد المشاركين بدلاً من إضافة أسطر
            final int crossAxisCount = (members.length > 2) ? 3 : members.length;
            final int rowCount = (members.length / crossAxisCount).ceil();

            final double itemWidth = (constraints.maxWidth - (crossAxisCount + 1) * spacing) / crossAxisCount;
            final double itemHeight = (constraints.maxHeight - (rowCount + 1) * spacing) / rowCount;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: members.map((m) {
                return SizedBox(
                  width: itemWidth,
                  height: itemHeight,
                  child: ParticipantCard(
                    participant: m,
                    fit: VideoViewFit.contain,
                    justShow: true,
                  ),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}
