
import 'package:flutter/material.dart';

import '../../../../core/widgets/app_list_card.dart';
import '../../data/response/user_response.dart';

class ItemUser extends StatelessWidget {
  const ItemUser({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return AppListCard(
      title: user.studentName.isEmpty ? 'مستخدم بدون اسم' : user.studentName,
      subtitle: user.studentRecordId.isEmpty ? 'لا يوجد رقم سجل' : 'رقم السجل: ${user.studentRecordId}',
      icon: Icons.person_outline,
    );
  }
}

