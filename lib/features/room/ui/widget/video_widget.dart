import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_manager/core/widgets/my_card_widget.dart';
import 'package:livekit_manager/features/room/ui/widget/local_media.dart';
import 'package:livekit_manager/features/room/ui/widget/notes_widget.dart';
import 'package:livekit_manager/features/room/ui/widget/users/participants_layout.dart';

import '../../../../core/strings/app_color_manager.dart';
import '../../../room/bloc/room_cubit/room_cubit.dart';

class VideoWidget extends StatefulWidget {
  const VideoWidget({super.key});

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  @override
  Widget build(BuildContext context) {
    return 0.0.verticalSpace;
  }
}
