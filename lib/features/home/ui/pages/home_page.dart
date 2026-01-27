import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:livekit_client/src/types/other.dart' as lk;
import 'package:livekit_manager/core/widgets/my_button.dart';
import 'package:livekit_manager/features/room/bloc/user_control_cubit/user_control_cubit.dart';

import '../../../../core/util/my_style.dart';
import '../../../room/bloc/room_cubit/room_cubit.dart';
import '../../../room/ui/pages/teacher_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.link,
    required this.token,
  });

  final String link;

  final String token;

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RoomCubit get cubit => context.read<RoomCubit>();

  UserControlCubit get ucCubit => context.read<UserControlCubit>();

  @override
  void initState() {
    cubit
      ..setUrl(widget.link)
      ..setToken(widget.token)
      ..connect();
    super.initState();
  }

  var show = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RoomCubit, RoomInitial>(
      listener: (context, state) {
        if (state.isConnect) {
          ucCubit.setLocalParticipant(state.result.localParticipant);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Builder(
              builder: (context) {
                switch (state.result.connectionState) {
                  case lk.ConnectionState.disconnected:
                    if (state.loading) {
                      return _Connecting();
                    } else {
                      return _EndSession();
                    }
                  case lk.ConnectionState.connecting:
                    return _Connecting();
                  case lk.ConnectionState.reconnecting:
                    return _ReConnecting();
                  case lk.ConnectionState.connected:
                    return TeacherPage();
                }
              },
            ),
          ),
        );
      },
    );
  }
}

class _EndSession extends StatelessWidget {
  const _EndSession({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: .min,
        children: [
          DrawableText(
            text: 'انتهت الجلسة شكرا لكم',
          ),
          20.0.verticalSpace,
          Row(
            spacing: 10.0,
            children: [
              Expanded(
                child: MyButton(
                  onTap: () => context.pop(),
                  text: 'العودة',
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
  const _ReConnecting({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawableText(
      padding: const EdgeInsets.all(8.0),
      text: 'تتم معاودة الاتصال, يرجى التحلي بالصبر',
      drawableEnd: MyStyle.loadingWidget(),
    );
  }
}

class _Connecting extends StatelessWidget {
  const _Connecting({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawableText(
      text: 'يتم الآن الاتصال, لحظات فقط ',
      padding: const EdgeInsets.all(8.0),
      drawableEnd: MyStyle.loadingWidget(),
    );
  }
}
