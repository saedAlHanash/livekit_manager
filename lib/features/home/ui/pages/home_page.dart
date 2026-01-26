import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:livekit_manager/core/widgets/my_button.dart';
import 'package:livekit_manager/features/room/bloc/user_control_cubit/user_control_cubit.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/util/my_style.dart';
import '../../../../generated/assets.dart';
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
        return state.isConnect
            ? TeacherPage()
            : Scaffold(
                body: Stack(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: .min,
                          children: [
                            DrawableText(
                              text: 'إما ان الجلسة انتهت او يتم معاودة الاتصال ',
                              drawableEnd: MyStyle.loadingWidget(),
                            ),
                            20.0.verticalSpace,
                            Row(
                              spacing: 10.0,
                              children: [
                                Expanded(
                                  child: MyButton(
                                    onTap: () {
                                      cubit
                                        ..setUrl(widget.link)
                                        ..setToken(widget.token)
                                        ..connect();
                                    },
                                    text: 'معاودة الاتصال اجباريا',
                                    loading: state.loading,
                                  ),
                                ),
                                Expanded(
                                  child: MyButton(
                                    onTap: () {
                                      context.pop();
                                    },
                                    color: Colors.red,
                                    text: 'إنهاء الاتصال والرجوع',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (show)
                      Positioned(
                        bottom: 0,
                        child: IgnorePointer(
                          child: Lottie.asset(
                            Assets.lottiesClapping1,
                            frameRate: .composition,
                            filterQuality: .medium,
                            width: 1.0.sw,
                            alignment: .bottomCenter,
                          ),
                        ),
                      ),
                  ],
                ),
              );
      },
    );
  }
}
