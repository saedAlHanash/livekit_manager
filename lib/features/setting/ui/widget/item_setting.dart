
import 'package:flutter/material.dart';

import '../../../../core/widgets/app_list_card.dart';
import '../../data/response/setting_response.dart';

class ItemSetting extends StatelessWidget {
  const ItemSetting({super.key, required this.setting});

  final Setting setting;

  @override
  Widget build(BuildContext context) {
    return AppListCard(
      title: setting.id.isEmpty ? 'إعداد بدون معرف' : 'إعداد ${setting.id}',
      subtitle: 'خيارات الجلسة والتحكم',
      icon: Icons.tune_outlined,
    );
  }
}

