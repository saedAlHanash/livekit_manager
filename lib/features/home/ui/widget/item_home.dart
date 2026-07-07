
import 'package:flutter/material.dart';

import '../../../../core/widgets/app_list_card.dart';
import '../../data/response/home_response.dart';

class ItemHome extends StatelessWidget {
  const ItemHome({super.key, required this.home});

  final Home home;

  @override
  Widget build(BuildContext context) {
    return AppListCard(
      title: home.id.isEmpty ? 'جلسة بدون معرف' : 'جلسة ${home.id}',
      subtitle: 'اضغط لعرض تفاصيل الجلسة',
      icon: Icons.video_camera_front_outlined,
    );
  }
}

