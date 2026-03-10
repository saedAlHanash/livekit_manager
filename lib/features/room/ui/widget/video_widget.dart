import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/widgets/my_card_widget.dart';
import 'package:livekit_manager/features/room/ui/widget/local_media.dart';
import 'package:livekit_manager/features/room/ui/widget/notes_widget.dart';
import 'package:livekit_manager/features/room/ui/widget/users/participants_layout.dart';

import '../../../../core/strings/app_color_manager.dart';
import '../../../../generated/l10n.dart';
import '../../../room/bloc/room_cubit/room_cubit.dart';

class VideoWidget extends StatefulWidget {
  const VideoWidget({super.key});

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RoomCubit>();
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: ParticipantsLayout(
            onTap: (participant) {
              cubit.selectParticipant(participant.identity);
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: MyCardWidget(
            cardColor: AppColorManager.tileColor,
            padding: EdgeInsets.all(7.0).r,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    SizedBox(
                      height: constraints.maxWidth - 50.0.w,
                      child: LocalMedia(),
                    ),
                    10.0.verticalSpace,
                    Expanded(
                      child: NotesWidget(),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
