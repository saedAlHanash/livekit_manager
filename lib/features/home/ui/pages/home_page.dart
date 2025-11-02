import 'dart:async';

import 'package:drawable_text/drawable_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:lk_assistant/core/api_manager/api_service.dart';
import 'package:lk_assistant/core/extensions/extensions.dart';
import 'package:lk_assistant/core/widgets/my_text_form_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/shared_preferences.dart';
import '../../../../core/util/snack_bar_message.dart';
import '../../../../core/widgets/my_button.dart';
import '../../../room/bloc/room_cubit/room_cubit.dart';
import '../../../room/ui/pages/room.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RoomCubit get cubit => context.read<RoomCubit>();

  final _tokenCtrl = TextEditingController(text: AppSharedPreference.getToken);

  Future<void> getToken() async {
    final r = await APIService().callApi(
      url: 'GetJoinToken',
      type: ApiType.post,
      hostName: 'coretik-be.coretech-mena.com',
      additional: '/api/v1/Index/',
      body: {
        "identity": "Sharer",
        "name": "Sharer",
        "videoGrants": {
          "canPublish": true,
          "canPublishData": true,
          "canSubscribe": true,
          "room": "c9d94a6f-617b-4eb6-8a25-08de1a1b2df0",
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
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, RoomInitial>(
      builder: (context, state) {
        return Scaffold(
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
                              MyButton(
                                width: 1.0.sw,
                                loading: state.loading,
                                onTap: () {
                                  cubit
                                    ..setToken(_tokenCtrl.text)
                                    ..connect();
                                },
                                text: 'Join',
                              )
                            ],
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
