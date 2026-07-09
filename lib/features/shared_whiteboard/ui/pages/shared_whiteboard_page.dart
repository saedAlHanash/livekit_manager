import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livekit_manager/features/shared_whiteboard/bloc/shared_whiteboard_cubit.dart';
import 'package:livekit_manager/features/shared_whiteboard/ui/widget/shared_whiteboard_widget.dart';

class SharedWhiteboardPage extends StatelessWidget {
  const SharedWhiteboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SharedWhiteboardCubit>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SharedWhiteboardWidget(
            sessionId: cubit.sessionId,
            userId: cubit.userId,
          ),
        ),
      ),
    );
  }
}
