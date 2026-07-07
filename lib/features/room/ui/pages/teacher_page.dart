import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_manager/core/util/snack_bar_message.dart';
import 'package:livekit_manager/features/room/ui/widget/controls.dart';
import 'package:livekit_manager/generated/l10n.dart';

import '../../../../core/strings/app_color_manager.dart';
import '../../../../core/widgets/my_card_widget.dart';
import '../../ui/widget/notes_widget.dart';
import '../../../user/bloc/users_cubit/users_cubit.dart';
import '../../bloc/room_cubit/room_cubit.dart';
import '../widget/local_media.dart';
import '../widget/users/participants_layout.dart';

class TeacherPage extends StatefulWidget {
  const TeacherPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  RoomCubit get cubit => context.read<RoomCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<UsersCubit, UsersInitial>(
      listenWhen: (p, c) => c.done,
      listener: (context, state) {
        context.read<RoomCubit>().setExpectedUsers(state.result);
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            final roomName = cubit.state.result.name ?? '';
            Clipboard.setData(ClipboardData(text: roomName));
            NoteMessage.showSuccessSnackBar(
              message: '${S.of(context).textCopiedToClipboard}: $roomName',
              context: context,
            );
          },
          backgroundColor: const Color(0xFF1DB954),
          icon: const Icon(Icons.share, color: Colors.white),
          label: DrawableText(
            text: S.of(context).shareCode,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: MyCardWidget(child: ParticipantsLayout()),
                    ),
                    10.0.horizontalSpace,
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
                ),
              ),
              10.0.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(),
                  MyCardWidget(
                    radios: 200.0,
                    padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
                    child: ControlsWidget(),
                  ),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
