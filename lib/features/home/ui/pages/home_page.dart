import 'dart:async';

import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:lk_assistant/core/api_manager/api_service.dart';
import 'package:lk_assistant/core/api_manager/api_url.dart';
import 'package:lk_assistant/core/extensions/extensions.dart';
import 'package:lk_assistant/core/widgets/my_text_form_widget.dart';

import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/shared_preferences.dart';
import '../../../../core/widgets/my_button.dart';
import '../../../../services/record_service.dart';
import '../../../room/bloc/my_status_cubit/my_status_cubit.dart';
import '../../../room/bloc/room_cubit/room_cubit.dart';
import '../../../room/bloc/user_control_cubit/user_control_cubit.dart';
import '../../../room/ui/pages/room.dart';

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

  final _tokenCtrl = TextEditingController(text: AppSharedPreference.getToken);

  Future<void> getToken() async {
    final r = await APIService().callApi(
      url: 'Index/GetJoinToken',
      type: ApiType.post,
      body: {
        "identity": "Sharer",
        "name": "Sharer",
        "videoGrants": {
          "canPublish": true,
          "canPublishData": true,
          "canSubscribe": true,
          "room": "s1",
          "roomAdmin": false,
          "roomCreate": true,
          "roomJoin": true,
          "roomList": true
        },
        "attributes": {"lkUserType": LkUserType.sharer.index.toString()}
      },
    );

    setState(() {
      _tokenCtrl.text = r.jsonBodyPure['token'];
      AppSharedPreference.cashToken(_tokenCtrl.text);
    });
  }

  @override
  void initState() {
    _tokenCtrl.text = widget.token;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, RoomInitial>(
      builder: (context, state) {
        return BlocListener<MyStatusCubit, MyStatusInitial>(
          listenWhen: (p, c) => c.statuses.done,
          listener: (context, sState) {
            // switch ((sState.result.state.canPublish, sState.result.state.canSubscribe)) {
            //   //suspended
            //   case (false, false):
            //     if (state.result.localParticipant?.permissions.isSuspend ?? true) return;
            //     context.read<UserControlCubit>().suspend(state.result.localParticipant!.identity);
            //     break;
            //   //only listen
            //   case (false, true):
            //     if (state.result.localParticipant?.permissions.isSilence ?? true) return;
            //     context.read<UserControlCubit>().revoke(state.result.localParticipant!, PermissionType.speak);
            //     break;
            //   //only speak
            //   case (true, false):
            //     break;
            //   //normal
            //   case (true, true):
            //     if (state.result.localParticipant?.permissions.isAll ?? true) return;
            //     context.read<UserControlCubit>().grant(state.result.localParticipant!, PermissionType.both);
            //     break;
            // }
          },
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: state.isConnect
                  ? RoomPage1()
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
                                if (widget.token.isEmpty) ...[
                                  DrawableText(text: state.url),
                                  20.0.verticalSpace,
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 25),
                                    child: MyTextFormWidget(
                                      label: 'Token',
                                      controller: _tokenCtrl,
                                      iconWidget: IconButton(
                                        onPressed: () {
                                          getToken();
                                        },
                                        icon: ImageMultiType(url: Icons.generating_tokens),
                                      ),
                                    ),
                                  ),
                                  20.0.verticalSpace,
                                ],
                                MyButton(
                                  width: 1.0.sw,
                                  loading: state.loading,
                                  onTap: () async {
                                    cubit
                                      ..setToken(_tokenCtrl.text)
                                      ..setUrl(wsLink);
                                    await cubit.connect();

                                    if (context.mounted) {
                                      context
                                          .read<MyStatusCubit>()
                                          .fetchMyStatus(state.result.localParticipant?.identity ?? '');
                                    }
                                  },
                                  text: 'Join',
                                ),
                                20.0.verticalSpace,
                                Row(
                                  children: [
                                    Expanded(
                                      child: MyButton(
                                        width: 1.0.sw,
                                        onTap: () async {
                                          RecorderService.startRecording();
                                          return;
                                          cubit
                                            ..setToken(_tokenCtrl.text)
                                            ..setUrl(wsLink);
                                          await cubit.connect();

                                          if (context.mounted) {
                                            context
                                                .read<MyStatusCubit>()
                                                .fetchMyStatus(state.result.localParticipant?.identity ?? '');
                                          }
                                        },
                                        text: 'start',
                                      ),
                                    ),
                                    Expanded(
                                      child: MyButton(
                                        width: 1.0.sw,
                                        onTap: () async {
                                          RecorderService.stopRecording();
                                          return;
                                          cubit
                                            ..setToken(_tokenCtrl.text)
                                            ..setUrl(wsLink);
                                          await cubit.connect();

                                          if (context.mounted) {
                                            context
                                                .read<MyStatusCubit>()
                                                .fetchMyStatus(state.result.localParticipant?.identity ?? '');
                                          }
                                        },
                                        text: 'stop',
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
