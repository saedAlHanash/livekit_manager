import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:livekit_manager/features/whiteboard_standalone/logic/whiteboard_standalone_cubit.dart';
import 'package:livekit_manager/features/whiteboard_standalone/presentation/widgets/whiteboard_standalone_widget.dart';

class WhiteboardStandalonePage extends StatelessWidget {
  const WhiteboardStandalonePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WhiteboardStandaloneCubit>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: WhiteboardStandaloneWidget(
            sessionId: cubit.lessonId,
            userId: cubit.userId,
          ),
        ),
      ),
    );
  }
}
