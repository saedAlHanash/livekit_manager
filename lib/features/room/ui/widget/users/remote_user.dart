import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/api_manager/api_service.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';
import 'package:m_cubit/m_cubit.dart';
import 'package:collection/collection.dart';

import '../../../../../core/strings/enum_manager.dart';
import '../no_video.dart';

class RemoteUser extends StatefulWidget {
  const RemoteUser({super.key, required this.participant, this.fit = VideoViewFit.contain});

  final Participant participant;
  final VideoViewFit fit;

  @override
  State<RemoteUser> createState() => _RemoteUserState();
}

class _RemoteUserState extends State<RemoteUser> {
  @override
  void initState() {
    super.initState();
    widget.participant.addListener(_onParticipantChanged);
    _onParticipantChanged();
  }

  @override
  void dispose() {
    widget.participant.removeListener(_onParticipantChanged);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant RemoteUser oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only update listeners if the participant actually changed
    if (oldWidget.participant.sid != widget.participant.sid) {
      oldWidget.participant.removeListener(_onParticipantChanged);
      widget.participant.addListener(_onParticipantChanged);
      _onParticipantChanged();
    }
  }

  void _onParticipantChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext ctx) {
    try {
      // Check if participant has active video first
      if (!widget.participant.videoActive) {
        return const NoVideoWidget();
      }

      // Get the first subscribed and unmuted video track
      final videoTrack =
          widget.participant.remoteVideoPublications
                  .where((pub) => pub.subscribed && pub.track != null && !pub.muted)
                  .firstOrNull
                  ?.track
              as VideoTrack?;

      if (videoTrack == null) {
        return const NoVideoWidget();
      }

      return VideoTrackRenderer(
        videoTrack,
        fit: widget.fit,
        renderMode: VideoRenderMode.auto,
      );
    } catch (e) {
      loggerObject.e('Error rendering video: $e');
      return const NoVideoWidget();
    }
  }
}

class ListRemoteUser extends StatefulWidget {
  const ListRemoteUser({super.key, required this.participants, required this.fit});

  final List<Participant> participants;
  final VideoViewFit fit;

  @override
  State<ListRemoteUser> createState() => _ListRemoteUserState();
}

class _ListRemoteUserState extends State<ListRemoteUser> {
  String? _selectedParticipantSid;

  // Calculate optimal number of columns based on participant count
  int _calculateCrossAxisCount(int participantCount) {
    if (participantCount <= 1) return 1;
    if (participantCount <= 4) return 2;
    if (participantCount <= 9) return 3;
    return 4;
  }

  void _selectParticipant(String? sid) {
    setState(() {
      _selectedParticipantSid = sid;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter participants with active video only
    final activeParticipants = widget.participants.where((p) => p.videoActive).toList();

    if (activeParticipants.isEmpty) {
      return const Center(
        child: DrawableText(text: 'لا يوجد مشاركين بفيديو نشط'),
      );
    }

    // Master view mode
    if (_selectedParticipantSid != null) {
      final masterParticipant = activeParticipants.firstWhereOrNull((p) => p.sid == _selectedParticipantSid);

      // If selected participant is no longer active, reset
      if (masterParticipant == null) {
        _selectedParticipantSid = null;
        return build(context);
      }

      final otherParticipants = activeParticipants.where((p) => p.sid != _selectedParticipantSid).toList();

      return Row(
        children: [
          // Master view (large)
          Expanded(
            flex: 4,
            child: GestureDetector(
              onDoubleTap: () => _selectParticipant(null), // Return to grid
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColorManager.mainColor, width: 2),
                ),
                child: Stack(
                  children: [
                    RemoteUser(participant: masterParticipant, fit: widget.fit),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 30.0,
                        color: Colors.black54,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                        child: Center(child: DrawableText(text: masterParticipant.displayName)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Sidebar with other participants
          if (otherParticipants.isNotEmpty)
            SizedBox(
              width: 200,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  itemCount: otherParticipants.length,
                  itemBuilder: (context, index) {
                    final participant = otherParticipants[index];
                    return GestureDetector(
                      onTap: () => _selectParticipant(participant.sid),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        height: 120,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColorManager.mainColor),
                          borderRadius: BorderRadius.circular(12.0).r,
                        ),
                        child: Stack(
                          children: [
                            RemoteUser(participant: participant, fit: widget.fit),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 25.0,
                                color: Colors.black54,
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                                child: Center(
                                  child: DrawableText(
                                    text: participant.displayName,
                                    size: 10.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      );
    }

    // Grid view mode
    final crossAxisCount = _calculateCrossAxisCount(activeParticipants.length);
    final shouldScroll = activeParticipants.length >= 8;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate card dimensions based on available space
        final availableWidth = constraints.maxWidth - 8.0;
        final availableHeight = constraints.maxHeight - 8.0;
        final rowCount = (activeParticipants.length / crossAxisCount).ceil();

        // Calculate card size
        final cardWidth = (availableWidth - (crossAxisCount - 1) * 4.0) / crossAxisCount;
        final cardHeight = shouldScroll ? cardWidth / (16 / 9) : (availableHeight - (rowCount - 1) * 4.0) / rowCount;

        return SingleChildScrollView(
          physics: shouldScroll ? null : const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(4.0),
          child: Wrap(
            spacing: 4.0,
            runSpacing: 4.0,
            children: activeParticipants.map((participant) {
              return GestureDetector(
                onTap: () => _selectParticipant(participant.sid),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColorManager.mainColor),
                    borderRadius: BorderRadius.circular(16.0).r,
                  ),
                  clipBehavior: .hardEdge,
                  width: cardWidth,
                  height: cardHeight,
                  child: Container(
                    key: ValueKey(participant.sid),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColorManager.mainColor),
                    ),
                    child: Stack(
                      children: [
                        RemoteUser(participant: participant, fit: widget.fit),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 30.0,
                            color: Colors.black54,
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                            child: Center(child: DrawableText(text: participant.displayName)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
