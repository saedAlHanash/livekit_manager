import 'dart:async';

import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:lk_assistant/core/api_manager/api_service.dart';
import 'package:lk_assistant/core/extensions/extensions.dart';
import 'package:lk_assistant/core/widgets/my_text_form_widget.dart';

import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/shared_preferences.dart';
import '../../../../core/widgets/my_button.dart';
import '../../../../generated/l10n.dart';
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

  final _codeC = TextEditingController();
  String token = '';

  var loading = false;

  @override
  void initState() {
    if (widget.token.isNotEmpty) {
      token = widget.token;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, RoomInitial>(
      builder: (context, state) {
        return BlocListener<MyStatusCubit, MyStatusInitial>(
          listenWhen: (p, c) => c.statuses.done,
          listener: (context, sState) {
            if (state.result.localParticipant?.userType == LkUserType.sharer) return;

            switch ((sState.result.state.canPublish, sState.result.state.canSubscribe)) {
              //suspended
              case (false, false):
                if (state.result.localParticipant?.permissions.isSuspend ?? true) return;
                context.read<UserControlCubit>().suspend(state.result.localParticipant!.identity);
                break;
              //only listen
              case (false, true):
                if (state.result.localParticipant?.permissions.isSilence ?? true) return;
                context.read<UserControlCubit>().revoke(state.result.localParticipant!, PermissionType.speak);
                break;
              //only speak
              case (true, false):
                break;
              //normal
              case (true, true):
                if (state.result.localParticipant?.permissions.isAll ?? true) return;
                context.read<UserControlCubit>().grant(state.result.localParticipant!, PermissionType.both);
                break;
            }
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
                                if (widget.token.isEmpty)
                                  MyTextFormWidget(
                                    controller: _codeC,
                                    helperText: 'يرجى إدخال رمز الجلسة',
                                  ),
                                20.0.verticalSpace,
                                MyButton(
                                  width: 1.0.sw,
                                  loading: state.loading || loading,
                                  onTap: () async {
                                    var token = widget.token;
                                    var url = widget.link;

                                    if (token.isEmpty) {
                                      setState(() => loading = true);
                                      var code = _codeC.text;
                                      var response = await APIService().callApi(
                                        type: ApiType.get,
                                        url: 'Meeting/GetSharingToken',
                                        query: {'code': code},
                                        additional: '/api/v1/',
                                        hostName: 'mmsv2-be.coretech-mena.com',
                                      );
                                      setState(() => loading = false);
                                      final json = response.jsonBody;

                                      token = json['token'];
                                      url = json['url'];
                                    }

                                    cubit
                                      ..setToken(token)
                                      ..setUrl(url);

                                    await cubit.connect();
                                    if (context.mounted) {
                                      context
                                          .read<MyStatusCubit>()
                                          .fetchMyStatus(state.result.localParticipant?.identity ?? '');
                                    }
                                  },
                                  text: S.of(context).join,
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
