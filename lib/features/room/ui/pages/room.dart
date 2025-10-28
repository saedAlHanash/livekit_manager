import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:lk_assistant/core/api_manager/api_service.dart';
import 'package:lk_assistant/core/strings/app_color_manager.dart';
import 'package:lk_assistant/core/util/exts.dart';
import 'package:lk_assistant/features/room/ui/widget/no_video.dart';
import 'package:lk_assistant/features/room/ui/widget/video_widget.dart';

import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/utils.dart';
import '../../bloc/room_cubit/room_cubit.dart';
import '../../data/request/setting_message.dart';
import '../widget/controls.dart';
import '../widget/participant_info.dart';
import '../widget/users/dynamic_user.dart';

class RoomPage1 extends StatefulWidget {
  const RoomPage1({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _RoomPage1State();
}

class _RoomPage1State extends State<RoomPage1> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, RoomInitial>(
      builder: (context, state) {
        return Scaffold(
          body: Column(
            children: [
              Expanded(child: VideoWidget()),
              if (state.result.localParticipant != null)
                SafeArea(
                  child: ControlsWidget(
                    state.result,
                    state.result.localParticipant!,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
