import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/util/shared_preferences.dart';
import 'package:livekit_manager/core/widgets/my_button.dart';
import 'package:livekit_manager/core/widgets/my_text_form_widget.dart';
import 'package:livekit_manager/features/room/bloc/user_control_cubit/user_control_cubit.dart';
import 'package:livekit_manager/features/room/bloc/user_control_cubit/user_control_cubit.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../../../core/api_manager/api_service.dart';
import '../../../../core/api_manager/api_url.dart';
import '../../../../core/strings/enum_manager.dart';
import '../../../../core/util/my_style.dart';
import '../../../room/bloc/room_cubit/room_cubit.dart';
import '../../../room/ui/pages/room_page.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RoomCubit, RoomInitial>(
      listener: (context, state) {
        if (state.isConnect) {
          ucCubit.setLocalParticipant(state.result.localParticipant);
        }
      },

      builder: (context, state) {
        return state.isConnect ? TeacherPage() : MyStyle.loadingWidget();
      },
    );
  }
}
