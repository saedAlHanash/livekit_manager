import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/widgets/my_button.dart';
import 'package:livekit_manager/features/mms/ui/pages/room_page.dart';

import '../../../../core/widgets/my_text_form_widget.dart';
import '../../../room/bloc/room_cubit/room_cubit.dart';
import '../../bloc/room_cubit/room_cubit.dart';
import '../../bloc/user_control_cubit/user_control_cubit.dart';

class MMSPage extends StatefulWidget {
  const MMSPage({
    super.key,
    required this.link,
    required this.token,
  });

  final String link;

  final String token;

  @override
  State<StatefulWidget> createState() => _MMSPageState();
}

class _MMSPageState extends State<MMSPage> {
  MMSRoomCubit get cubit => context.read<MMSRoomCubit>();

  MMSUserControlCubit get ucCubit => context.read<MMSUserControlCubit>();
  var token = '';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MMSRoomCubit, MMSRoomInitial>(
      listener: (context, state) {
        ucCubit.setRoom(state.result);
      },
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
                          if (widget.token.isEmpty)
                            MyTextFormWidget(
                              onChanged: (value) => token = value,
                              helperText: 'يرجى إدخال رمز الجلسة',
                            ),
                          20.0.verticalSpace,
                          20.0.verticalSpace,
                          MyButton(
                            width: 1.0.sw,
                            loading: state.loading,
                            onTap: () {
                              cubit
                                ..setUrl(widget.link)
                                ..setToken(widget.token.isEmpty ? token : widget.token)
                                ..connect();
                            },
                            text: 'انضمام',
                          ),
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
