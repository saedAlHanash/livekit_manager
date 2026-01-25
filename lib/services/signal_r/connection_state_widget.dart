import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../generated/l10n.dart';
import 'bloc/signal_r_cubit/signal_r_cubit.dart';

class ConnectionStateWidget extends StatelessWidget {
  const ConnectionStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignalRCubit, SignalRInitial>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0.r),
            color: state.connectionState.getColor.withValues(alpha: 0.2),
          ),
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0).r,
          margin: EdgeInsets.symmetric(horizontal: 15.0).r,
          child: DrawableText(
            text: S.of(context).connection,
            drawablePadding: 10.0.w,
            drawableEnd: ImageMultiType(
              url: Icons.circle,
              color: state.connectionState.getColor,
              height: 15.0.r,
              width: 15.0.r,
            ),
          ),
        );
      },
    );
  }
}
