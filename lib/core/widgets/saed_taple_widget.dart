import 'package:collection/collection.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_manager/core/api_manager/api_service.dart';

import '../strings/app_color_manager.dart';

class SaedTableWidget extends StatelessWidget {
  const SaedTableWidget({
    super.key,
    required this.title,
    required this.data,
    this.weights,
    this.onTapItem,
    this.height,
    this.onTapHeader,
    this.headerDecoration,
  });

  final double? height;
  final Iterable<dynamic> title;
  final List<int>? weights;
  final Iterable<List<dynamic>> data;
  final Function(int i)? onTapItem;
  final Function()? onTapHeader;
  final BoxDecoration? headerDecoration;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0).h,
            decoration: headerDecoration ??
                BoxDecoration(
                  color: Theme.of(context).primaryColorDark,
                ),
            child: TitleWidget(
              title: title,
              weights: weights,
            ),
          ),
          Expanded(
            flex: height == null ? 0 : 1,
            child: ListView(
              shrinkWrap: true,
              physics: height == null ? const NeverScrollableScrollPhysics() : null,
              children: data.mapIndexed((i, e) {
                return InkWell(
                  onTap: () {
                    loggerObject.w(onTapItem == null);
                    onTapItem?.call(i);
                  },
                  child: CellWidget(
                    e: e,
                    weights: weights,
                    color: i % 2 != 0 ? Theme.of(context).cardColor : Theme.of(context).scaffoldBackgroundColor,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class CellWidget extends StatelessWidget {
  const CellWidget({super.key, required this.e, this.weights, required this.color});

  final Iterable e;
  final List<int>? weights;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      height: 45.0.h,
      margin: EdgeInsets.symmetric(vertical: 2.0).r,
      padding: EdgeInsets.symmetric(vertical: 5.0).r,
      child: Row(
        children: e.mapIndexed(
          (i, e) {
            final widget = e is String
                ? Directionality(
                    textDirection: TextDirection.ltr,
                    child: DrawableText(
                      size: 12.0.sp,
                      matchParent: true,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      text: e.isEmpty ? '-' : e,
                    ),
                  )
                : e is Widget
                    ? e
                    : Container(
                        height: 10,
                        color: Colors.red,
                      );

            return Expanded(
              flex: (i >= (weights?.length ?? 0)) ? 1 : weights![i],
              child: widget,
            );
          },
        ).toList(),
      ),
    );
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key, required this.title, this.weights});

  final Iterable title;
  final List<int>? weights;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: title.mapIndexed(
        (i, e) {
          final widget = e is String
              ? DrawableText(
                  matchParent: true,
                  textAlign: TextAlign.center,
                  size: 12.0.sp,
                  color: AppColorManager.secondColor,
                  fontWeight: FontWeight.w800,
                  text: e,
                )
              : title is Widget
                  ? title as Widget
                  : Container(
                      color: Colors.red,
                      height: 10,
                    );

          return Expanded(
            flex: (i >= (weights?.length ?? 0)) ? 1 : weights![i],
            child: widget,
          );
        },
      ).toList(),
    );
  }
}
