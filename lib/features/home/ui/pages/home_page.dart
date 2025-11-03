import 'dart:async';

import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:lk_assistant/core/api_manager/api_service.dart';
import 'package:lk_assistant/core/extensions/extensions.dart';
import 'package:lk_assistant/core/widgets/my_text_form_widget.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/shared_preferences.dart';
import '../../../../core/widgets/my_button.dart';
import '../../../room/bloc/my_status_cubit/my_status_cubit.dart';
import '../../../room/bloc/room_cubit/room_cubit.dart';
import '../../../room/bloc/user_control_cubit/user_control_cubit.dart';
import '../../../room/ui/pages/room.dart';

class PinputExample extends StatefulWidget {
  const PinputExample({Key? key}) : super(key: key);

  @override
  State<PinputExample> createState() => _PinputExampleState();
}

class _PinputExampleState extends State<PinputExample> {
  late final TextEditingController pinController;
  late final FocusNode focusNode;
  late final GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    // On web, disable the browser's context menu since this example uses a custom
    // Flutter-rendered context menu.
    if (kIsWeb) {
      BrowserContextMenu.disableContextMenu();
    }
    formKey = GlobalKey<FormState>();
    pinController = TextEditingController();
    focusNode = FocusNode();

    /// In case you need an SMS autofill feature
  }

  @override
  void dispose() {
    if (kIsWeb) {
      BrowserContextMenu.enableContextMenu();
    }
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );

    /// Optionally you can use form to validate the Pinput
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Directionality(
            // Specify direction if desired
            textDirection: TextDirection.ltr,
            child: Pinput(
              // You can pass your own SmsRetriever implementation based on any package
              // in this example we are using the SmartAuth
              enableInteractiveSelection: true,
              controller: pinController,
              focusNode: focusNode,
              defaultPinTheme: defaultPinTheme,
              separatorBuilder: (index) => const SizedBox(width: 8),
              validator: (value) {
                return value == '2222' ? null : 'Pin is incorrect';
              },
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              onCompleted: (pin) {
                debugPrint('onCompleted: $pin');
              },
              onChanged: (value) {
                debugPrint('onChanged: $value');
              },
              cursor: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 9),
                    width: 22,
                    height: 1,
                    color: focusedBorderColor,
                  ),
                ],
              ),
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              submittedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyBorderWith(
                border: Border.all(color: Colors.redAccent),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              focusNode.unfocus();
              formKey.currentState!.validate();
            },
            child: const Text('Validate'),
          ),
        ],
      ),
    );
  }
}

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
      url: 'GetJoinToken',
      type: ApiType.post,
      hostName: 'coretik-be.coretech-mena.com',
      additional: '/api/v1/Index/',
      body: {
        "identity": "Sharer",
        "name": "Sharer",
        "videoGrants": {
          "canPublish": false,
          "canPublishData": true,
          "canSubscribe": false,
          "room": "d747e704-a038-4a11-afbc-08de1ab1dade",
          "roomAdmin": false,
          "roomCreate": true,
          "roomJoin": true,
          "roomList": true
        },
        "attributes": {"lkUserType": LkUserType.user.index.toString()}
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
        return BlocListener<MyStatusCubit, MyStatusInitial>(
          listenWhen: (p, c) => c.statuses.done,
          listener: (context, sState) {
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
                                  onTap: () async {
                                    cubit.setToken(_tokenCtrl.text);
                                    await cubit.connect();
                                    if (context.mounted) {
                                      context
                                          .read<MyStatusCubit>()
                                          .fetchMyStatus(state.result.localParticipant?.identity ?? '');
                                    }
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
          ),
        );
      },
    );
  }
}
