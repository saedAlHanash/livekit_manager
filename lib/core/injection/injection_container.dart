import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:livekit_manager/features/home/bloc/home_cubit/home_cubit.dart';
import 'package:livekit_manager/features/home/bloc/homes_cubit/homes_cubit.dart';
import 'package:livekit_manager/features/room/bloc/room_cubit/room_cubit.dart';
import 'package:livekit_manager/features/setting/bloc/setting_cubit/setting_cubit.dart';
import 'package:livekit_manager/features/setting/bloc/settings_cubit/settings_cubit.dart';
import 'package:livekit_manager/features/user/bloc/user_cubit/user_cubit.dart';
import 'package:livekit_manager/features/user/bloc/users_cubit/users_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/bloc/logged_user_cubit/logged_user_cubit.dart';
import '../../features/auth/bloc/login_cubit/login_cubit.dart';
import '../../features/lesson/bloc/active_session_cubit/active_session_cubit.dart';
import '../../features/room/bloc/user_control_cubit/user_control_cubit.dart';
import '../../features/staff_record/bloc/staff_details_cubit/staff_details_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => LoginCubit());
  sl.registerFactory(() => LoggedUserCubit());
  sl.registerFactory(() => ActiveSessionCubit());
  sl.registerFactory(() => StaffDetailsCubit());
  //region setting
  sl.registerFactory(() => SettingCubit());
  sl.registerFactory(() => SettingsCubit());
  //endregion

  //region room
  sl.registerFactory(() => RoomCubit());
  sl.registerFactory(() => UserControlCubit());
  //endregion

  //region user
  sl.registerFactory(() => UserCubit());
  sl.registerFactory(() => UsersCubit());
  //endregion

  //region home
  sl.registerFactory(() => HomeCubit());
  sl.registerFactory(() => HomesCubit());
  //endregion

  //region Core

  sl.registerLazySingleton(() => GlobalKey<NavigatorState>());

  //endregion

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
