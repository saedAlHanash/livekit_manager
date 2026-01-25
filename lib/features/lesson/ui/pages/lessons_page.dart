import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_cubit/m_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_manager/core/strings/app_color_manager.dart';
import 'package:livekit_manager/core/widgets/app_bar/app_bar_widget.dart';
import 'package:livekit_manager/core/widgets/refresh_widget/refresh_widget.dart';
import 'package:livekit_manager/generated/l10n.dart';
import 'package:livekit_manager/features/lesson/bloc/lessons_cubit/lessons_cubit.dart';
import 'package:livekit_manager/features/lesson/ui/widget/item_lesson.dart';

class LessonsPage extends StatelessWidget {
  const LessonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        titleText: 'S.of(context).lessons',
      ),
      body: BlocBuilder<LessonsCubit, LessonsInitial>(
        builder: (context, state) {
          return RefreshWidget(
            isLoading: state.statuses == CubitStatuses.loading,
            onRefresh: () => context.read<LessonsCubit>().getData(newData: true),
            child: ListView.separated(
              padding: EdgeInsets.all(16.0).r,
              itemCount: state.result.length,
              separatorBuilder: (_, i) => 16.0.verticalSpace,
              itemBuilder: (_, i) {
                final item = state.result[i];
                return ItemLesson(lesson: item);
              },
            ),
          );
        },
      ),
    );
  }
}
