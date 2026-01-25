import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';
import 'package:livekit_manager/core/widgets/app_bar/app_bar_widget.dart';
import 'package:livekit_manager/core/widgets/refresh_widget/refresh_widget.dart';
import 'package:livekit_manager/features/lesson/bloc/lesson_cubit/lesson_cubit.dart';
import 'package:livekit_manager/generated/l10n.dart';
import 'package:livekit_manager/features/lesson/ui/widget/ai_bot_widget.dart';
import 'package:m_cubit/m_cubit.dart';

class LessonPage extends StatelessWidget {
  const LessonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        titleText: context.read<LessonCubit>().state.result.title,
      ),
      body: BlocBuilder<LessonCubit, LessonInitial>(
        builder: (context, state) {
          final lesson = state.result;
          return RefreshWidget(
            isLoading: state.statuses == CubitStatuses.loading,
            onRefresh: () => context.read<LessonCubit>().getData(id: state.id.toString(), newData: true),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0).r,
              child: lesson == null
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0).r,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DrawableText(
                                  text: lesson.title,
                                  size: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                12.verticalSpace,
                                _buildInfoRow(Icons.tag, 'Sequence', lesson.sequence.toString()),
                                8.verticalSpace,
                                _buildInfoRow(Icons.info_outline, 'Status', lesson.lessonStatus.toString()),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
      floatingActionButton: BlocBuilder<LessonCubit, LessonInitial>(
        builder: (context, state) {
          final lesson = state.result;
          if (lesson.id.isEmpty) {
            return const SizedBox.shrink();
          }
          return AiBotWidget(lessonId: lesson.id);
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20.r, color: AppColorManager.mainColor),
        8.horizontalSpace,
        DrawableText(
          text: '$label: ',
          size: 16.sp,
          color: Colors.grey[700],
        ),
        Expanded(
          child: DrawableText(
            text: value,
            size: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
