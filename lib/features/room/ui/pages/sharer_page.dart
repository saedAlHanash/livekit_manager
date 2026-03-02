import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../bloc/room_cubit/room_cubit.dart';
import '../widget/controls.dart';
import '../widget/video_widget.dart';

class SharerPage extends StatefulWidget {
  const SharerPage({super.key});

  @override
  State<StatefulWidget> createState() => _SharerPageState();
}

class _SharerPageState extends State<SharerPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, RoomInitial>(
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              spacing: 10.0.h,
              children: [
                Expanded(child: VideoWidget()),
                SafeArea(child: ControlsWidget()),
              ],
            ),
          ),
        );
      },
    );
  }
}
