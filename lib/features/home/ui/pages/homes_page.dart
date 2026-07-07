  import 'package:drawable_text/drawable_text.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:flutter_screenutil/flutter_screenutil.dart';
  import 'package:go_router/go_router.dart';
  import 'package:livekit_manager/router/go_router.dart';

  import '../../../../core/widgets/app_bar/app_bar_widget.dart';
  import '../../../../core/widgets/refresh_widget/refresh_widget.dart';
  import '../../bloc/homes_cubit/homes_cubit.dart';
  import '../widget/item_home.dart';

class HomesPage extends StatelessWidget {
  const HomesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),

      body: BlocBuilder<HomesCubit, HomesInitial>(
        builder: (context, state) {
          return RefreshWidget(
            isLoading: state.loading,
            onRefresh: () => context.read<HomesCubit>().getData(newData: true),
            child: state.result.isEmpty && !state.loading
                ? _EmptyState(
                    onCreateSession: () =>
                        context.pushNamed(RouteName.createSession),
                  )
                : ListView.separated(
                    itemCount: state.result.length,
                    separatorBuilder: (_, i) => 10.0.verticalSpace,
                    itemBuilder: (_, i) {
                      final item = state.result[i];
                      return ItemHome(home: item);
                    },
                  ),
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onCreateSession});

  final VoidCallback onCreateSession;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90.r,
              height: 90.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1DB954).withValues(alpha: 0.12),
              ),
              child: Icon(
                Icons.video_call_rounded,
                size: 48.sp,
                color: const Color(0xFF1DB954),
              ),
            ),
            20.verticalSpace,
            DrawableText(
              text: 'لا توجد جلسات بعد',
              size: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              textAlign: TextAlign.center,
            ),
            10.verticalSpace,
            DrawableText(
              text: 'أنشئ جلسة جديدة وابدأ الاجتماع فوراً',
              size: 13.sp,
              color: Colors.white54,
              textAlign: TextAlign.center,
            ),
            28.verticalSpace,
            GestureDetector(
              onTap: onCreateSession,
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1DB954), Color(0xFF0E8C3A)],
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1DB954).withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_rounded, color: Colors.white, size: 22.sp),
                    8.horizontalSpace,
                    DrawableText(
                      text: 'إنشاء جلسة جديدة',
                      size: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

