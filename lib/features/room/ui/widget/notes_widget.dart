import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/my_card_widget.dart';
import '../../../../generated/l10n.dart';

class NotesWidget extends StatelessWidget {
  const NotesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MyCardWidget(
      padding: EdgeInsets.all(15.0).r,
      child: Column(
        children: [
          DrawableText(
            text: S.of(context).notes,
            matchParent: true,
          )
        ],
      ),
    );
  }
}
