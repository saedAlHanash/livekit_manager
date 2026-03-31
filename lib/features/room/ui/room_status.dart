import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:web/web.dart' as web;
import '../../../../../core/util/my_style.dart';
import '../../../../../core/widgets/my_button.dart';
import '../../../../../generated/l10n.dart';
import '../bloc/room_cubit/room_cubit.dart';

class RoomStatus extends StatelessWidget {
  const RoomStatus({super.key, required this.videoCall});

  final Widget videoCall;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<RoomCubit, RoomInitial>(
        builder: (context, state) {
          switch (state.result.connectionState) {
            case .disconnected:
              if (state.loading) {
                return Connecting();
              } else {
                return EndSession();
              }
            case .connecting:
              return Connecting();
            case .reconnecting:
              return ReConnecting();
            case .connected:
              return videoCall;
          }
        },
      ),
    );
  }
}

class EndSession extends StatelessWidget {
  const EndSession({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: .min,
        children: [
          DrawableText(
            text: S.of(context).sessionEndedThankYou,
          ),
          20.0.verticalSpace,
          Row(
            spacing: 10.0,
            children: [
              Expanded(
                child: MyButton(
                  onTap: () => web.window.location.reload(),
                  text: S.of(context).back,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ReConnecting extends StatelessWidget {
  const ReConnecting({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawableText(
      padding: const EdgeInsets.all(8.0),
      text: S.of(context).reconnectingPleaseWait,
      drawableEnd: MyStyle.loadingWidget(),
    );
  }
}

class Connecting extends StatelessWidget {
  const Connecting({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawableText(
      text: S.of(context).connectingJustAMoment,
      padding: const EdgeInsets.all(8.0),
      drawableEnd: MyStyle.loadingWidget(),
    );
  }
}
