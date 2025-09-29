import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../dto/stepper_data.dart';
import 'common/dot_provider.dart';

class VerticalStepperItem extends StatelessWidget {
  /// Stepper Item to show vertical stepper
  const VerticalStepperItem(
      {super.key,
      required this.item,
      required this.index,
      required this.totalLength,
      required this.gap,
      required this.activeIndex,
      required this.isInverted,
      required this.barWidth,
      required this.iconHeight,
      required this.iconWidth});

  /// Stepper item of type [StepperData] to inflate stepper with data
  final StepperData item;

  /// Index at which the item is present
  final int index;

  /// Total length of the list provided
  final int totalLength;

  /// Active index which needs to be highlighted and before that
  final int activeIndex;

  /// Gap between the items in the stepper
  final double gap;

  /// Inverts the stepper with text that is being used
  final bool isInverted;

  /// Bar width/thickness
  final double barWidth;

  /// Height of [StepperData.iconWidget]
  final double iconHeight;

  /// Width of [StepperData.iconWidget]
  final double iconWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          children: [
            if (index != 0)
              Container(
                color:(index < activeIndex ? item.color : item.color),
                width: barWidth,
                height: gap * 2,
              ),

            DotProvider(
              activeIndex: activeIndex,
              index: index,
              item: item,
              totalLength: totalLength,
              iconHeight: iconHeight,
              iconWidth: iconWidth,
            ),

          ],
        ),
        15.0.horizontalSpace,
        Expanded(
            child: Column(
          children: [
            item.title,
            item.subtitle,
          ],
        ))
      ],
    );
  }
}
