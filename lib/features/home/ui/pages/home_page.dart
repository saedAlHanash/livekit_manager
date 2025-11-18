import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/util/shared_preferences.dart';
import 'package:livekit_manager/core/widgets/my_button.dart';
import 'package:livekit_manager/core/widgets/my_text_form_widget.dart';

import '../../../../core/api_manager/api_service.dart';
import '../../../../core/strings/enum_manager.dart';
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

  final _tokenCtrl = TextEditingController(text: AppSharedPreference.getToken);

  // Future<void> getToken() async {
  //   final r = await APIService().callApi(
  //     url: 'GetJoinToken',
  //     type: ApiType.post,
  //     hostName: 'coretik-be.coretech-mena.com',
  //     additional: '/api/v1/Index/',
  //     body: {
  //       "identity": "Admin",
  //       "name": "Admin",
  //       "videoGrants": {
  //         "canPublish": false,
  //         "canPublishData": true,
  //         "canSubscribe": true,
  //         "room": "s1",
  //         "roomAdmin": false,
  //         "roomCreate": true,
  //         "roomJoin": true,
  //         "roomList": true
  //       },
  //       "attributes": {
  //         "type": LkUserType.manager.index.toString(),
  //       }
  //     },
  //   );
  //
  //   setState(() {
  //     _tokenCtrl.text = r.jsonBodyPure['token'];
  //     AppSharedPreference.cashToken(_tokenCtrl.text);
  //   });
  // }

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
                          MyButton(
                            width: 1.0.sw,
                            loading: state.loading,
                            onTap: () {
                              cubit
                                ..setUrl(widget.link)
                                ..setToken(widget.token)
                                ..connect();
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
