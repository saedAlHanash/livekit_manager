import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// import 'package:web/web.dart' as web;
import 'package:livekit_client/livekit_client.dart';
import 'package:livekit_manager/core/api_manager/api_service.dart';
import 'package:livekit_manager/core/app/app_provider.dart';
import 'package:livekit_manager/core/util/shared_preferences.dart';

import '../core/api_manager/api_url.dart';
import '../core/app/app_widget.dart';
import '../core/injection/injection_container.dart';
import '../features/auth/bloc/login_cubit/login_cubit.dart';
import '../features/auth/ui/pages/login_page.dart';
import '../features/home/bloc/home_cubit/home_cubit.dart';
import '../features/home/bloc/homes_cubit/homes_cubit.dart';
import '../features/home/ui/pages/home_page.dart';
import '../features/home/ui/pages/home_screen.dart';
import '../features/home/ui/pages/homes_page.dart';
import '../features/lesson/bloc/active_session_cubit/active_session_cubit.dart';
import '../features/room/bloc/room_cubit/room_cubit.dart';
import '../features/room/ui/pages/teacher_page.dart';
import '../features/setting/bloc/setting_cubit/setting_cubit.dart';
import '../features/setting/bloc/settings_cubit/settings_cubit.dart';
import '../features/setting/ui/pages/setting_page.dart';
import '../features/setting/ui/pages/settings_page.dart';
import '../features/splash/ui/spalsh_page.dart';
import '../features/staff_record/bloc/staff_details_cubit/staff_details_cubit.dart';
import '../features/user/bloc/user_cubit/user_cubit.dart';
import '../features/user/bloc/users_cubit/users_cubit.dart';
import '../features/user/ui/pages/user_page.dart';
import '../features/user/ui/pages/users_page.dart';

final goRouter = GoRouter(
  navigatorKey: sl<GlobalKey<NavigatorState>>(),
  routes: [
    //region setting

    ///setting
    GoRoute(
      path: RouteName.setting,
      name: RouteName.setting,
      builder: (_, state) {
        String settingId = state.uri.queryParameters['id'] ?? '';
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => sl<SettingCubit>()..getData(settingId: settingId),
            ),
          ],
          child: SettingPage(),
        );
      },
    ),

    ///settings
    GoRoute(
      path: RouteName.settings,
      name: RouteName.settings,
      builder: (_, state) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => sl<SettingsCubit>()..getData(),
            ),
          ],
          child: SettingsPage(),
        );
      },
    ),
    //endregion

    //region room

    ///room
    GoRoute(
      path: RouteName.room,
      name: RouteName.room,
      builder: (_, state) {
        final link = state.uri.queryParameters['link'] ?? '';
        final token = state.uri.queryParameters['token'] ?? '';

        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => sl<RoomCubit>()
                ..setUrl(link)
                ..setToken(token)
                ..connect(),
            ),
          ],
          child: TeacherPage(),
        );
      },
    ),

    //endregion

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
              create: (_) => sl<UserCubit>()..getData(userId: userId),
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
              create: (_) => sl<UsersCubit>()..getData(),
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
      builder: (c, state) {
        String link = state.uri.queryParameters['url'] ?? wsLink;
        String token = state.uri.queryParameters['token'] ?? '';
        String theme = state.uri.queryParameters['theme'] ?? '';

        if (theme.isNotEmpty) {
          if (theme == 'dark') {
            MyApp.changeTheme(c, ThemeMode.dark);
          } else if (theme == 'light') {
            AppSharedPreference.setThemeMode(ThemeMode.light);
            MyApp.changeTheme(c, ThemeMode.light);
            // View.of(_).platformDispatcher.platformBrightness == Brightness.light;
          }
        } else {
          AppSharedPreference.setThemeMode(ThemeMode.system);
          // AppSharedPreference.setThemeMode(ThemeMode.system);
          // View.of(_).platformDispatcher.platformBrightness == Brightness.light;
        }

        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<HomeCubit>()),
          ],
          child: HomePage(link: link, token: token),
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
              create: (_) => sl<HomesCubit>()..getData(),
            ),
          ],
          child: HomesPage(),
        );
      },
    ),

    ///sessions
    GoRoute(
      path: RouteName.sessions,
      name: RouteName.sessions,
      builder: (_, state) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => sl<ActiveSessionCubit>()..getData(staffId: AppProvider.getStaff.staffRecordId),
            ),
          ],
          child: HomeScreen(),
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

    //region auth

    ///login
    GoRoute(
      path: RouteName.login,
      name: RouteName.login,
      builder: (_, state) {
        final providers = [
          BlocProvider(
            create: (_) => sl<LoginCubit>(),
          ),
        ];
        return MultiBlocProvider(
          providers: providers,
          child: const LoginPage(),
        );
      },
    ),

    //endregion
  ],
);

class RouteName {
  static const teacherPage = '/TeacherPage';
  static const sessions = '/sessions';
  static const login = '/login';
  static const setting = '/setting';
  static const settings = '/settings';

  static const room = '/room';
  static const rooms = '/rooms';

  static const user = '/user';
  static const users = '/users';

  static const home = '/home';
  static const homes = '/homes';

  static const splash = '/';
}
