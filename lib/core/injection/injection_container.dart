      
import 'package:livekit_manager/features/user/bloc/user_cubit/user_cubit.dart';
import 'package:livekit_manager/features/user/bloc/users_cubit/users_cubit.dart';


import 'package:livekit_manager/features/home/bloc/home_cubit/home_cubit.dart';
import 'package:livekit_manager/features/home/bloc/homes_cubit/homes_cubit.dart';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
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