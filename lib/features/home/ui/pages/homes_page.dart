import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:livekit_manager/router/go_router.dart';

import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_page_scaffold.dart';
import '../../../../core/widgets/app_bar/app_bar_widget.dart';
import '../../../../core/widgets/refresh_widget/refresh_widget.dart';
import '../../bloc/homes_cubit/homes_cubit.dart';
import '../widget/item_home.dart';

class HomesPage extends StatelessWidget {
  const HomesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(titleText: 'الجلسات'),
      body: BlocBuilder<HomesCubit, HomesInitial>(
        builder: (context, state) {
          return RefreshWidget(
            isLoading: state.loading,
            onRefresh: () => context.read<HomesCubit>().getData(newData: true),
            child: state.result.isEmpty && !state.loading
                ? AppEmptyState(
                    icon: Icons.video_call_outlined,
                    title: 'لا توجد جلسات بعد',
                    message: 'أنشئ جلسة جديدة وابدأ الاجتماع مباشرة.',
                    action: FilledButton.icon(
                      onPressed: () => context.pushNamed(RouteName.createSession),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('إنشاء جلسة جديدة'),
                    ),
                  )
                : AppPageScaffold(
                    child: ListView.separated(
                      itemCount: state.result.length,
                      separatorBuilder: (_, i) => 12.0.verticalSpace,
                      itemBuilder: (_, i) => ItemHome(home: state.result[i]),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
