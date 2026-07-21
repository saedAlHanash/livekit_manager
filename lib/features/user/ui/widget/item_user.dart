
import 'package:flutter/material.dart';

import '../../../../core/widgets/app_list_card.dart';
import '../../data/response/user_response.dart';

class ItemUser extends StatelessWidget {
  const ItemUser({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return AppListCard(
      title: user.name.isEmpty ? 'مستخدم بدون اسم' : user.name,
      subtitle: user.id.isEmpty ? 'لا يوجد رقم سجل' : 'رقم السجل: ${user.id}',
      icon: Icons.person_outline,
    );
  }
}

