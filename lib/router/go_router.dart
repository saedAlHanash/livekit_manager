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
import '../features/home/ui/pages/home_page.dart';
import '../features/home/ui/pages/homes_page.dart';
import '../features/mms/bloc/room_cubit/room_cubit.dart';
import '../features/mms/ui/pages/home_page.dart';
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

    ///group
    GoRoute(
      path: RouteName.group,
      name: RouteName.group,
      builder: (context, state) {
        final link = state.uri.queryParameters['url'] ?? state.uri.queryParameters['link'] ?? wsLink;
        final token = state.uri.queryParameters['token'] ?? '';
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
            BlocProvider(create: (context) => sl<UsersCubit>()),
          ],
          child: HomePage(
            link: link,
            token: token,
            page: .group,
          ),
        );
      },
    ),

    ///mms
    GoRoute(
      path: RouteName.mms,
      name: RouteName.mms,
      builder: (context, state) {
        final link = state.uri.queryParameters['url'] ?? state.uri.queryParameters['link'] ?? wsLink;
        mmsLkManageUrl = state.uri.queryParameters['manager_url'] ?? state.uri.queryParameters['manager_link'] ?? '';
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
            BlocProvider(
              create: (context) => sl<MMSRoomCubit>()
                ..setUrl(link)
                ..initial(),
            ),
            BlocProvider(create: (context) => sl<UsersCubit>()),
          ],
          child: MMSPage(
            link: link,
            token: token,
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
  static const group = '/group';
}

//https://lk-m.codemagic.app/mms?link=wss://coretik.coretech-mena.com
var tempToken =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIzYmEyMmU3Zi01YWYxLTRlZTAtOGJlYy0wOGRlOGUzZWNjODYiLCJqdGkiOiIzYmEyMmU3Zi01YWYxLTRlZTAtOGJlYy0wOGRlOGUzZWNjODYiLCJpc3MiOiJkZXZrZXkiLCJuYmYiOjE3NzY1ODgzMzAsImlhdCI6MTc3NjU4ODMzMCwiZXhwIjoxNzgxNzcyMzMwLCJ2aWRlbyI6eyJhZ2VudCI6ZmFsc2UsImNhblB1Ymxpc2giOmZhbHNlLCJjYW5QdWJsaXNoRGF0YSI6dHJ1ZSwiY2FuUHVibGlzaFNvdXJjZXMiOltdLCJjYW5TdWJzY3JpYmUiOnRydWUsImNhblN1YnNjcmliZU1ldHJpY3MiOmZhbHNlLCJjYW5VcGRhdGVPd25NZXRhZGF0YSI6ZmFsc2UsImRlc3RpbmF0aW9uUm9vbSI6IiIsImhpZGRlbiI6ZmFsc2UsImluZ3Jlc3NBZG1pbiI6ZmFsc2UsInJlY29yZGVyIjpmYWxzZSwicm9vbSI6ImY5NmMyYTk1LTkyMmMtNDcxYy0zZjM0LTA4ZGU5NjQzZjAyMSIsInJvb21BZG1pbiI6dHJ1ZSwicm9vbUNyZWF0ZSI6dHJ1ZSwicm9vbUpvaW4iOnRydWUsInJvb21MaXN0IjpmYWxzZSwicm9vbVJlY29yZCI6ZmFsc2V9LCJzaXAiOnsiYWRtaW4iOmZhbHNlLCJjYWxsIjpmYWxzZX0sIm5hbWUiOiJtYWlzc2FtIGJhbGF3bnkiLCJtZXRhZGF0YSI6IiIsInNoYTI1NiI6IiIsImtpbmQiOiIiLCJhdHRyaWJ1dGVzIjp7ImltYWdlVXJsIjpudWxsLCJsa1VzZXJUeXBlIjoiMCJ9LCJyb29tQ29uZmlnIjp7fX0.Ep0qCJgL0YJnHl7PZkATmt4gugjGUF5oU-vSM4iTgGo";
var manager_url = "coretik-be.coretech-mena.com";
