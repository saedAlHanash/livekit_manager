import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';
import 'package:livekit_manager/features/room/bloc/room_cubit/room_cubit.dart';
import 'package:livekit_manager/features/shared_whiteboard/ui/widget/shared_whiteboard_widget.dart';

class TeacherWhiteboardDialogContent extends StatelessWidget {
  final String roomName;
  final String userId;

  const TeacherWhiteboardDialogContent({
    super.key,
    required this.roomName,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('اللوح التشاركي (لوحة المعلم)'),
        backgroundColor: AppColorManager.mainColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Row(
        children: [
          // Left Side: Whiteboard Canvas
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(8.r),
              child: SharedWhiteboardWidget(
                sessionId: roomName,
                userId: userId,
              ),
            ),
          ),
          
          // Right Side: Students Permissions Sidebar
          Container(
            width: 280.w,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                right: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(16.r),
                  color: AppColorManager.mainColor.withOpacity(0.05),
                  child: Row(
                    children: [
                      Icon(Icons.people_outline, color: AppColorManager.mainColor),
                      SizedBox(width: 10.w),
                      Text(
                        'صلاحيات الطلاب للكتابة',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColorManager.mainColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                
                Expanded(
                  child: BlocBuilder<RoomCubit, RoomInitial>(
                    builder: (context, roomState) {
                      final participants = roomState.result.remoteParticipants.values.toList();
                      
                      if (participants.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.r),
                            child: Text(
                              'لا يوجد طلاب متصلين حالياً بالجلسة',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey, fontSize: 13.sp),
                            ),
                          ),
                        );
                      }
                      
                      return ListView.separated(
                        itemCount: participants.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final participant = participants[index];
                          final hasPermission = roomState.whiteboardAllowedUsers.contains(participant.identity);
                          
                          return ListTile(
                            title: Text(
                              participant.name ?? participant.identity,
                              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              participant.identity,
                              style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                            ),
                            trailing: Switch(
                              value: hasPermission,
                              activeColor: AppColorManager.mainColor,
                              onChanged: (allowed) {
                                context.read<RoomCubit>().toggleWhiteboardPermission(
                                  participant.identity,
                                  allowed,
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
