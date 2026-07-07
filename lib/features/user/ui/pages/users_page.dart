import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_page_scaffold.dart';
import '../../../../core/widgets/app_bar/app_bar_widget.dart';
import '../../../../core/widgets/refresh_widget/refresh_widget.dart';
import '../../bloc/users_cubit/users_cubit.dart';
import '../widget/item_user.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(titleText: 'المستخدمون'),
      body: BlocBuilder<UsersCubit, UsersInitial>(
        builder: (context, state) {
          return RefreshWidget(
            isLoading: state.loading,
            onRefresh: () => context.read<UsersCubit>().getData(newData: true),
            child: state.result.isEmpty && !state.loading
                ? const AppEmptyState(
                    icon: Icons.groups_2_outlined,
                    title: 'لا يوجد مستخدمون',
                    message: 'ستظهر قائمة المشاركين أو الطلاب هنا عند توفرها.',
                  )
                : AppPageScaffold(
                    child: ListView.separated(
                      itemCount: state.result.length,
                      separatorBuilder: (_, i) => 12.0.verticalSpace,
                      itemBuilder: (_, i) => ItemUser(user: state.result[i]),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
