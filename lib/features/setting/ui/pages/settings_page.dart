import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/app_bar/app_bar_widget.dart';
import '../../../../core/widgets/refresh_widget/refresh_widget.dart';
import '../../bloc/settings_cubit/settings_cubit.dart';
import '../widget/item_setting.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      body: BlocBuilder<SettingsCubit, SettingsInitial>(
        builder: (context, state) {
          return RefreshWidget(
            isLoading: state.loading,
            onRefresh: () => context.read<SettingsCubit>().getData(newData: true),
            child: ListView.separated(
              itemCount: state.result.length,
              separatorBuilder: (_, i) => 10.0.verticalSpace,
              itemBuilder: (_, i) {
                final item = state.result[i];
                return ItemSetting(setting: item);
              },
            ),
          );
        },
      ),
    );
  }
}
