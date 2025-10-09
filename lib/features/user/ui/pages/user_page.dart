import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_bar/app_bar_widget.dart';
import '../../../../core/widgets/refresh_widget/refresh_widget.dart';
import '../../bloc/user_cubit/user_cubit.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UserCubit, UserInitial>(
          listenWhen: (p, c) => c.done,
          listener: (context, state) {},
        ),
      ],
      child: Scaffold(
        appBar: AppBarWidget(),
        body: BlocBuilder<UserCubit, UserInitial>(
          builder: (context, state) {
            return RefreshWidget(
              isLoading: state.loading,
              onRefresh: () {
                context.read<UserCubit>().getData(newData: true);
              },
              child: ListView(
                shrinkWrap: true,
                children: [],
              ),
            );
          },
        ),
      ),
    );
  }
}
