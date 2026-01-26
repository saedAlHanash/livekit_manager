import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';
import 'package:livekit_manager/core/widgets/app_bar/app_bar_widget.dart';
import 'package:livekit_manager/features/room/bloc/user_control_cubit/user_control_cubit.dart';
import 'package:livekit_manager/features/room/ui/widget/controls.dart';
import 'package:livekit_manager/features/room/ui/widget/notes_widget.dart';
import 'package:livekit_manager/features/room/ui/widget/speakers_widget.dart';
import 'package:livekit_manager/generated/l10n.dart';

import '../../bloc/room_cubit/room_cubit.dart';
import '../widget/users/dynamic_user.dart';
import '../widget/users/remote_user.dart';

class TeacherPage extends StatefulWidget {
  const TeacherPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  RoomCubit get cubit => context.read<RoomCubit>();

  void enterFullScreenLandscape() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void exitFullScreenPortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  void showFullScreenDialog(Participant? item) {
    if (item == null) return;
    enterFullScreenLandscape();
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, _, __) {
        return BlocProvider.value(
          value: this.context.read<RoomCubit>(),
          child: _FullScreenMedia(item: item),
        );
      },
    ).then((value) {
      exitFullScreenPortrait();
      // Reset selection so we can select the same user again if needed
      this.context.read<RoomCubit>().selectParticipant('');
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, RoomInitial>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBarWidget(
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.group),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
            actions: [
              Builder(
                builder: (context) => IconButton(
                  icon: Stack(
                    alignment: .center,
                    children: [
                      Icon(Icons.speaker_notes),
                      if (state.haveNewNote)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            height: 10.0.dg,
                            width: 10.0.dg,
                            decoration: BoxDecoration(shape: .circle, color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                  onPressed: () {
                    context.read<RoomCubit>().setHaveNewNote(false);
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
              ),
            ],
          ),
          drawer: Drawer(
            backgroundColor: AppColorManager.appBarColor,
            child: SafeArea(child: const SpeakersWidget()),
          ),
          endDrawer: Drawer(
            backgroundColor: AppColorManager.appBarColor,
            child: SafeArea(child: const NotesWidget()),
          ),
          body: BlocBuilder<UserControlCubit, UserControlInitial>(
            builder: (context, state) {
              return BlocBuilder<RoomCubit, RoomInitial>(
                builder: (context, state) {
                  final list = state.participantWithoutMe;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200.0.w,
                    ),
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      final item = list[i];
                      return RemoteUser(
                        participant: item,
                        onTab: (participant) {
                          showFullScreenDialog(participant);
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _FullScreenMedia extends StatefulWidget {
  const _FullScreenMedia({required this.item});

  final Participant item;

  @override
  State<_FullScreenMedia> createState() => _FullScreenMediaState();
}

class _FullScreenMediaState extends State<_FullScreenMedia> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, RoomInitial>(
      builder: (context, state) {
        final p = state.getParticipantById(widget.item.identity) ?? widget.item;

        return Scaffold(
          backgroundColor: Colors.black,
          body: GestureDetector(
            onDoubleTap: () => Navigator.pop(context),
            child: InteractiveViewer(
              constrained: false,
              scaleEnabled: true,
              minScale: 0.01,
              child: Stack(
                children: [
                  SizedBox(
                    height: 1.0.sh,
                    width: 1.0.sw,
                    child: DynamicUser(
                      participant: p,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.5),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const ImageMultiType(
                              url: Icons.cancel_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
