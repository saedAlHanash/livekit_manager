import 'dart:async';

import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/util/snack_bar_message.dart';
import 'package:livekit_manager/core/widgets/my_button.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../generated/l10n.dart';
import '../../../room/bloc/room_cubit/room_cubit.dart';
import '../../../room/ui/pages/room_page.dart';

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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, RoomInitial>(
      builder: (context, state) {
        return state.isConnect
            ? RoomPage()
            : Scaffold(
                body: Container(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      constraints: BoxConstraints(maxWidth: 500),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DrawableText(text: state.url),
                          20.0.verticalSpace,
                          DrawableText(text: state.token),
                          20.0.verticalSpace,
                          MyButton(
                            width: 1.0.sw,
                            loading: state.loading,
                            onTap: () {
                              cubit.connect();
                              // cubit.initial().then(
                              //   (value) {
                              //   },
                              // );
                            },
                            text: 'Join',
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }
}
