import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/features/room/ui/widget/users/participant_card.dart';

class FloatingLocalUser extends StatefulWidget {
  const FloatingLocalUser({super.key, required this.constraints, this.localParticipant});

  final BoxConstraints constraints;
  final LocalParticipant? localParticipant;

  @override
  State<FloatingLocalUser> createState() => _FloatingLocalUserState();
}

class _FloatingLocalUserState extends State<FloatingLocalUser> {
  Offset? _localOffset;

  final double _localCardWidth = 120.0.r;
  final double _localCardHeight = 100.0.r;

  void _snapToCorners(BoxConstraints constraints) {
    if (_localOffset == null) return;

    double midX = (constraints.maxWidth - _localCardWidth) / 2;
    double midY = (constraints.maxHeight - _localCardHeight) / 2;

    double targetX = _localOffset!.dx < midX ? 16.w : constraints.maxWidth - _localCardWidth - 16.w;
    double targetY = _localOffset!.dy < midY ? 16.h : constraints.maxHeight - _localCardHeight - 16.h;

    setState(() {
      _localOffset = Offset(targetX, targetY);
    });
  }

  BoxConstraints get constraints => widget.constraints;

  @override
  Widget build(BuildContext context) {
    if (widget.localParticipant == null) return 0.0.verticalSpace;
    _localOffset ??= Offset(
      constraints.maxWidth - _localCardWidth - 5.r,
      constraints.maxHeight - _localCardHeight - 5.r,
    );

    return Positioned(
      left: _localOffset!.dx,
      top: _localOffset!.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _localOffset = Offset(
              (_localOffset!.dx + details.delta.dx).clamp(0.0, constraints.maxWidth - _localCardWidth),
              (_localOffset!.dy + details.delta.dy).clamp(0.0, constraints.maxHeight - _localCardHeight),
            );
          });
        },
        onPanEnd: (_) => _snapToCorners(constraints),
        child: Container(
          width: _localCardWidth,
          height: _localCardHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: ParticipantCard(
              participant: widget.localParticipant,
              fit: .contain,
              small: true,
            ),
          ),
        ),
      ),
    );
  }
}
