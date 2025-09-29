import '../features/user/bloc/user_cubit/user_cubit.dart';
import '../features/user/bloc/users_cubit/users_cubit.dart';
import '../features/user/ui/pages/user_page.dart';
import '../features/user/ui/pages/users_page.dart';

import '../features/home/bloc/home_cubit/home_cubit.dart';
import '../features/home/bloc/homes_cubit/homes_cubit.dart';
import '../features/home/ui/pages/home_page.dart';
import '../features/home/ui/pages/homes_page.dart';

import '../features/splash/ui/spalsh_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/injection/injection_container.dart';

final goRouter = GoRouter(
  navigatorKey: sl<GlobalKey<NavigatorState>>(),
  routes: [
    //region user

    ///user
    GoRoute(
      path: RouteName.user,
      name: RouteName.user,
      builder: (_, state) {
        String userId = state.uri.queryParameters['id'] ?? '';
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => sl<UserCubit>()..getData(userId: userId),
            ),
          ],
          child: UserPage(),
        );
      },
    ),

    ///users
    GoRoute(
      path: RouteName.users,
      name: RouteName.users,
      builder: (_, state) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => sl<UsersCubit>()..getData(),
            ),
          ],
          child: UsersPage(),
        );
      },
    ),
    //endregion

    //region home

    ///home
    GoRoute(
      path: RouteName.home,
      name: RouteName.home,
      builder: (_, state) {
        String homeId = state.uri.queryParameters['id'] ?? '';
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => sl<HomeCubit>()..getData(homeId: homeId),
            ),
          ],
          child: HomePage(),
        );
      },
    ),

    ///homes
    GoRoute(
      path: RouteName.homes,
      name: RouteName.homes,
      builder: (_, state) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => sl<HomesCubit>()..getData(),
            ),
          ],
          child: HomesPage(),
        );
      },
    ),
    //endregion

    //region splash
    ///Splash
    GoRoute(
      path: RouteName.splash,
      name: RouteName.splash,
      builder: (_, state) {
        return const SplashScreenPage();
      },
    ),

    //endregion
  ],
);

class RouteName {
  static const user = '/user';
  static const users = '/users';

  static const home = '/home';
  static const homes = '/homes';

  static const splash = '/';
}
