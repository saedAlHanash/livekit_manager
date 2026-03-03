import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:collection/collection.dart';
import 'package:livekit_manager/generated/l10n.dart';
import '../../../../../core/api_manager/api_service.dart';
import '../../../../../core/extensions/extensions.dart';
import '../../../bloc/room_cubit/room_cubit.dart';
import 'participant_card.dart';

class ParticipantsLayout extends StatefulWidget {
  const ParticipantsLayout({
    super.key,
    this.fit = VideoViewFit.contain,
    this.selectedIdentity,
    this.onTap,
  });

  final VideoViewFit fit;
  final String? selectedIdentity;
  final Function(Participant)? onTap;

  @override
  State<ParticipantsLayout> createState() => _ParticipantsLayoutState();
}

class _ParticipantsLayoutState extends State<ParticipantsLayout> {
  String? _internalSelectedIdentity;

  String? get _currentSelectedIdentity => widget.selectedIdentity ?? _internalSelectedIdentity;

  void _handleTap(Participant p) {
    if (widget.onTap != null) {
      widget.onTap!(p);
    } else {
      setState(() {
        if (_internalSelectedIdentity == p.identity) {
          _internalSelectedIdentity = null;
        } else {
          _internalSelectedIdentity = p.identity;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, RoomInitial>(
      builder: (context, state) {
        final participants = state.participants;
        // Use Master view if explicitly selected OR if > 4 participants
        final useMasterView = participants.length > 4 || _currentSelectedIdentity != null;

        if (useMasterView) {
          Participant? masterParticipant;
          if (_currentSelectedIdentity != null) {
            masterParticipant = participants.firstWhereOrNull(
              (p) => p.identity == _currentSelectedIdentity || p.sid == _currentSelectedIdentity,
            );
          }
          masterParticipant ??= participants.first;

          final otherParticipants = participants.where((p) => p.identity != masterParticipant!.identity).toList();

          return Row(
            children: [
              // Master view (large)
              Expanded(
                flex: 4,
                child: ParticipantCard(
                  participant: masterParticipant,
                  fit: widget.fit,
                  isMaster: true,
                  isSelected: true,
                  onTap: () => _handleTap(masterParticipant!),
                ),
              ),
              // Sidebar with other profiles
              if (otherParticipants.isNotEmpty)
                SizedBox(
                  width: 220.w,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
                    itemCount: otherParticipants.length,
                    itemBuilder: (context, index) {
                      final p = otherParticipants[index];
                      return Container(
                        height: 140.h,
                        margin: EdgeInsets.only(bottom: 4.h),
                        child: ParticipantCard(
                          participant: p,
                          fit: widget.fit,
                          onTap: () => _handleTap(p),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        }

        // Grid view mode (for <= 4 participants)
        final crossAxisCount = _calculateCrossAxisCount(participants.length);

        if (participants.isEmpty) {
          return Center(
            child: DrawableText(text: S.of(context).noActiveVideoParticipants),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth - 8.w;
            final availableHeight = constraints.maxHeight - 8.h;
            final rowCount = (participants.length / crossAxisCount).ceil();

            final cardWidth = (availableWidth - (crossAxisCount - 1) * 4.w) / crossAxisCount;
            final cardHeight = (availableHeight - (rowCount - 1) * 4.h) / rowCount;

            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(4.w),
              child: Wrap(
                spacing: 4.w,
                runSpacing: 4.h,
                children: participants.map((p) {
                  loggerObject.w('''
    isActive; : ${p.activeVideoTrack?.isActive}
    mediaType.name; : ${p.activeVideoTrack?.mediaType.name}
    kind.name; : ${p.activeVideoTrack?.kind.name}
    muted; : ${p.activeVideoTrack?.muted}
    hasVideo; : ${p.hasVideo}
    hasAudio; : ${p.hasAudio}
    haveActiveVideoTrack; : ${p.haveActiveVideoTrack}
    isMuted; : ${p.isMuted}
    isSpeaking; : ${p.isSpeaking}
    haveActiveVideoTrack; : ${p.haveActiveVideoTrack}
    ''');
                  return SizedBox(
                    width: cardWidth,
                    height: cardHeight,
                    child: ParticipantCard(
                      participant: p,
                      fit: widget.fit,
                      isSelected: _currentSelectedIdentity == p.identity,
                      onTap: () => _handleTap(p),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }

  int _calculateCrossAxisCount(int count) {
    if (count <= 1) return 1;
    if (count <= 4) return 2;
    return 2;
  }
}
