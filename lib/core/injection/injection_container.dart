import 'package:lk_assistant/features/setting/bloc/setting_cubit/setting_cubit.dart';
import 'package:lk_assistant/features/setting/bloc/settings_cubit/settings_cubit.dart';

import 'package:lk_assistant/features/room/bloc/room_cubit/room_cubit.dart';
import 'package:lk_assistant/features/room/bloc/rooms_cubit/rooms_cubit.dart';

import 'package:lk_assistant/features/user/bloc/user_cubit/user_cubit.dart';
import 'package:lk_assistant/features/user/bloc/users_cubit/users_cubit.dart';

import 'package:lk_assistant/features/home/bloc/home_cubit/home_cubit.dart';
import 'package:lk_assistant/features/home/bloc/homes_cubit/homes_cubit.dart';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //region setting
  sl.registerFactory(() => SettingCubit());
  sl.registerFactory(() => SettingsCubit());
  //endregion

  //region room
  sl.registerFactory(() => RoomCubit());
  sl.registerFactory(() => RoomsCubit());
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
