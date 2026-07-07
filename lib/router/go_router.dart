import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:livekit_manager/core/util/shared_preferences.dart';
import 'package:livekit_manager/features/room/ui/pages/teacher_page.dart';

import '../core/api_manager/api_url.dart';
import '../core/app/app_widget.dart';
import '../core/injection/injection_container.dart';
import '../features/home/bloc/home_cubit/home_cubit.dart';
import '../features/home/bloc/homes_cubit/homes_cubit.dart';
import '../features/home/ui/pages/create_session_page.dart';
import '../features/home/ui/pages/home_page.dart';
import '../features/home/ui/pages/homes_page.dart';

import '../features/room/bloc/room_cubit/room_cubit.dart';
import '../features/setting/bloc/setting_cubit/setting_cubit.dart';
import '../features/setting/bloc/settings_cubit/settings_cubit.dart';
import '../features/setting/ui/pages/setting_page.dart';
import '../features/setting/ui/pages/settings_page.dart';
import '../features/splash/ui/spalsh_page.dart';
import '../features/user/bloc/user_cubit/user_cubit.dart';
import '../features/user/bloc/users_cubit/users_cubit.dart';
import '../features/user/ui/pages/user_page.dart';
import '../features/user/ui/pages/users_page.dart';

import '../features/shared_whiteboard/bloc/shared_whiteboard_cubit.dart';
import '../features/shared_whiteboard/ui/pages/shared_whiteboard_page.dart';
import '../services/signal_r/bloc/signal_r_cubit/signal_r_cubit.dart';

final goRouter = GoRouter(
  navigatorKey: sl<GlobalKey<NavigatorState>>(),
  routes: [
    //region shared whiteboard
    GoRoute(
      path: RouteName.sharedWhiteboard,
      name: RouteName.sharedWhiteboard,
      builder: (context, state) {
        final lessonId = state.uri.queryParameters['lessonId'] ?? 'ed783d91-a4fd-4610-2092-08de58154480';
        final userId = state.uri.queryParameters['userId'] ?? 'ed783d91-a4fd-4610-2092-08de58154480';
        final userName = state.uri.queryParameters['userName'] ?? 'راكان';
        final userType = state.uri.queryParameters['userType'] ?? 'teacher';
        final token = state.uri.queryParameters['token'] ?? 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6ImU2ZTVlM2NmLTQ1OGQtNGRjOC1iMzNjLTMzZDMyNTdiN2E2OCIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL2VtYWlsYWRkcmVzcyI6IkhhbGFAZ21haWwuY29tIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwOS8wOS9pZGVudGl0eS9jbGFpbXMvYWN0b3IiOiJDbGllbnQiLCJTZXNzaW9uSWQiOiIzYWYyM2NlYS05MzI3LTQyMWUtYmYzZC1iOGM1ODMyMmNiNTUiLCJuYmYiOjE3ODIwNDU5OTksImV4cCI6MTc4MjI2MTk5OSwiaXNzIjoibG9jYWxob3N0IiwiYXVkIjoibG9jYWxob3N0In0.Ybjg70ruOV6VPCZdDsOAT5T6mSKqRU5cp-b1cnXkVPA';

          AppSharedPreference.setUserId(userId);
        if (token.isNotEmpty) {
          AppSharedPreference.cashToken(token);
        }

        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => SignalRCubit()
                ..initialSignalR(lessonId, userId),
            ),
            BlocProvider(
              create: (context) => SharedWhiteboardCubit(
                sessionId: lessonId,
                userId: userId,
                userName: userName,
                userType: userType,
                signalRCubit: context.read<SignalRCubit>(),
              ),
            ),
          ],
          child: const SharedWhiteboardPage(),
        );
      },
    ),
    //endregion

    //region create session
    GoRoute(
      path: RouteName.createSession,
      name: RouteName.createSession,
      builder: (_, __) => const CreateSessionPage(),
    ),
    //endregion

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
              create: (context) => sl<SettingCubit>()..getData(settingId: settingId),
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
              create: (context) => sl<SettingsCubit>()..getData(),
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
      path: RouteName.teacher,
      name: RouteName.teacher,
      builder: (_, state) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => sl<RoomCubit>(),
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
      builder: (context, state) {
        final link = state.uri.queryParameters['url'] ?? state.uri.queryParameters['link'] ?? wsLink;
        final token = state.uri.queryParameters['token'] ?? '';
        final groupTermId = state.uri.queryParameters['groupTermId'];
        final theme = state.uri.queryParameters['theme'] ?? '';

        if (theme.isNotEmpty) {
          if (theme == 'dark') {
            MyApp.changeTheme(context, ThemeMode.dark);
          } else if (theme == 'light') {
            AppSharedPreference.setThemeMode(ThemeMode.light);
            MyApp.changeTheme(context, ThemeMode.light);
            // View.of(context).platformDispatcher.platformBrightness == Brightness.light;
          }
        } else {
          AppSharedPreference.setThemeMode(ThemeMode.system);
          // AppSharedPreference.setThemeMode(ThemeMode.system);
          // View.of(context).platformDispatcher.platformBrightness == Brightness.light;
        }

        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => sl<HomeCubit>()),
            BlocProvider(create: (context) => sl<UsersCubit>()..getData(groupTermId: groupTermId)),
          ],
          child: HomePage(
            link: link,
            token: token,
            page: .teacher,
          ),
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
  static const setting = '/setting';
  static const settings = '/settings';

  static const teacher = '/teacher';
  static const rooms = '/rooms';

  static const user = '/user';
  static const users = '/users';

  static const home = '/';
  static const homes = '/homes';

  static const splash = '/splash';
  static const mms = '/mms';

  static const sharedWhiteboard = '/shared_whiteboard';
  static const createSession = '/create_session';
}
