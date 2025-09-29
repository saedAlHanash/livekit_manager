import 'package:flutter/cupertino.dart';

import 'app_widget.dart';

class AppProvider {
  //region UI Helpers
  static void unFocus({BuildContext? context}) {
    final currentFocus = FocusScope.of(context ?? ctx!);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

//endregion
}
