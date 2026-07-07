import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_manager/core/strings/enum_manager.dart';
import 'package:livekit_manager/core/util/snack_bar_message.dart';
import 'package:livekit_manager/core/widgets/my_text_form_widget.dart';
import 'package:livekit_manager/features/room/bloc/user_control_cubit/user_control_cubit.dart';
import 'package:livekit_manager/features/room/ui/room_status.dart';
import 'package:livekit_manager/generated/l10n.dart';
import 'package:livekit_manager/router/go_router.dart';

import '../../../room/bloc/room_cubit/room_cubit.dart';
import '../../../room/ui/pages/teacher_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.link,
    required this.token,
    required this.page,
  });

  final String link;
  final String token;
  final PageType page;

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String token = '';

  RoomCubit get cubit => context.read<RoomCubit>();

  UserControlCubit get ucCubit => context.read<UserControlCubit>();

  final controller = TextEditingController();

  @override
  void initState() {
    token = widget.token;
    if (token.isNotEmpty) {
      cubit
        ..setUrl(widget.link)
        ..setToken(token)
        ..connect();
    }
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: token.isNotEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () => context.pushNamed(RouteName.createSession),
              backgroundColor: const Color(0xFF1DB954),
              icon: const Icon(Icons.videocam_rounded, color: Colors.white),
              label: DrawableText(
                text: S.of(context).createSession,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
      body: BlocConsumer<RoomCubit, RoomInitial>(
        listener: (context, state) {
          ucCubit.setLocalParticipant(state.result.localParticipant);
        },
        builder: (context, state) {
          if (token.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: .min,
                children: [
                  Row(
                    mainAxisAlignment: .start,
                    crossAxisAlignment: .end,
                    mainAxisSize: .min,

                    spacing: 10.0.w,
                    children: [
                      0.1.sw.horizontalSpace,
                      Expanded(
                        child: MyTextFormWidget(
                          controller: controller,
                          titleLabel: 'Token',
                          hint: 'Token',
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            token = controller.text;
                            cubit
                              ..setUrl(widget.link)
                              ..setToken(token)
                              ..connect();
                          });
                        },
                        icon: ImageMultiType(url: Icons.connected_tv),
                      ),
                      0.1.sw.horizontalSpace,
                    ],
                  ),
                ],
              ),
            );
          }
          return Center(
            child: RoomStatus(
              videoCall: Builder(
                builder: (context) {
                  switch (widget.page) {
                    case PageType.teacher:
                      return TeacherPage();
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
