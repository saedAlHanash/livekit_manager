import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';
import 'package:livekit_manager/core/strings/enum_manager.dart';
import 'package:livekit_manager/core/widgets/my_button.dart';
import 'package:livekit_manager/core/widgets/my_text_form_widget.dart';
import 'package:livekit_manager/features/room/bloc/user_control_cubit/user_control_cubit.dart';
import 'package:livekit_manager/features/room/ui/pages/sharer_page.dart';
import 'package:livekit_manager/generated/l10n.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../../../core/util/my_style.dart';
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
            child: Builder(
              builder: (context) {
                switch (state.result.connectionState) {
                  case .disconnected:
                    if (state.loading) {
                      return _Connecting();
                    } else {
                      return _EndSession();
                    }
                  case .connecting:
                    return _Connecting();
                  case .reconnecting:
                    return _ReConnecting();
                  case .connected:
                    switch (PageType.sharer) {
                      case PageType.manager:
                        // TODO: Handle this case.
                        throw UnimplementedError();
                      case PageType.sharer:
                        return SharerPage();
                      case PageType.teacher:
                        return TeacherPage();
                    }
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class _EndSession extends StatelessWidget {
  const _EndSession();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: .min,
        children: [
          DrawableText(
            text: 'Session ended, thank you',
          ),
          20.0.verticalSpace,
          Row(
            spacing: 10.0,
            children: [
              Expanded(
                child: MyButton(
                  onTap: () => context.pop(),
                  text: S.of(context).back,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReConnecting extends StatelessWidget {
  const _ReConnecting();

  @override
  Widget build(BuildContext context) {
    return DrawableText(
      padding: const EdgeInsets.all(8.0),
      text: 'Reconnecting, please be patient',
      drawableEnd: MyStyle.loadingWidget(),
    );
  }
}

class _Connecting extends StatelessWidget {
  const _Connecting();

  @override
  Widget build(BuildContext context) {
    return DrawableText(
      text: 'Connecting now, just a moment',
      padding: const EdgeInsets.all(8.0),
      drawableEnd: MyStyle.loadingWidget(),
    );
  }
}
