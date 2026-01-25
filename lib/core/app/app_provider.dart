import 'package:flutter/cupertino.dart';

import '../../features/staff_record/data/response/staff_record_response.dart';
import 'app_widget.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m_cubit/m_cubit.dart';
import '../../features/auth/bloc/logout/logout_cubit.dart';
import '../../features/auth/data/response/login_response.dart';
import '../../generated/l10n.dart';
import '../../router/go_router.dart';
import '../strings/enum_manager.dart';
import '../util/shared_preferences.dart';
import '../util/snack_bar_message.dart';
import 'app_widget.dart';

class AppProvider {
  //region Getters

  static bool get isDarkMode => ctx != null ? Theme.of(ctx!).brightness == Brightness.dark : false;

  static String get supperFilter => '${AppSharedPreference.getMyId}${AppSharedPreference.getLocal}';

  static int get getRemaining => AppSharedPreference.getResendDateTime.difference(DateTime.now()).inSeconds;

  static User get loginUser {
    final json = CachingService.getFromBucketJsonSync(key: BucketNames.loginUser);

    return User.fromJson(json);
  }

  static bool get isLogin => AppSharedPreference.getToken.isNotEmpty;

  static StaffDetails get getStaff => StaffDetails.fromJson(
    CachingService.getFromBucketJsonSync(key: BucketNames.staffRecord),
  );

  static bool get isNotLogin => !isLogin;

  //endregion

  //region Auth Methods

  static Future<void> login({required LoginResponse response}) async {
    await AppSharedPreference.cashToken(response.token);
    await AppSharedPreference.cashMyId(response.user.id);
    await setUser(response.user);
    CachingService.setSupperFilter(supperFilter);
  }

  static Future<void> setUser(User user) async {
    await CachingService.addInBucketJson(key: BucketNames.loginUser, jsonEncode: jsonEncode(user));
    CachingService.setSupperFilter(supperFilter);
  }

  static Future<void> logout({bool withDialog = false}) async {
    if (ctx == null) return;
    if (withDialog) {
      NoteMessage.showCheckDialog(
        ctx!,
        text: S.of(ctx!).logout,
        textButton: S().yes,
        image: Icons.logout,
        onConfirm: () async {
          await ctx!.read<LogoutCubit>().logout();
          await AppSharedPreference.logout();
          await AppSharedPreference.reload();

          ctx!.goNamed(RouteName.splash);
        },
      );
    } else {
      await AppSharedPreference.logout();
      await AppSharedPreference.reload();
      while (ctx!.canPop()) {
        ctx!.pop();
      }
      ctx!.go(RouteName.login);
    }
  }

  //endregion

  //region StartPage
  static StartPage get getStartPage {
    if (AppProvider.isLogin) {
      return StartPage.home;
    }
    return AppSharedPreference.getStartPage;
  }

  //endregion

  //region UI Helpers
  static void unFocus({BuildContext? context}) {
    final currentFocus = FocusScope.of(context ?? ctx!);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  //endregion

  static Future<void> setStaffRecord(StaffDetails model) async {
    await CachingService.addInBucketJson(
      key: BucketNames.staffRecord,
      jsonEncode: jsonEncode(model),
    );
  }
}

class BucketNames {
  static final staffRecord = 'staffRecord';
  static final loginUser = 'user';

  static List<String> get all => [staffRecord, loginUser];
}
