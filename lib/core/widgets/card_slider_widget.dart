import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/round_image_widget.dart';
import 'package:lk_assistant/core/strings/app_color_manager.dart';

class CardSlider extends StatelessWidget {
  const CardSlider({super.key, this.margin, required this.images});

  final EdgeInsets? margin;
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<IndicatorSliderWidgetState>();

    return Column(
      children: [
        CarouselSlider(
          items:
              images.map((e) {
                return RoundImageWidget(url: e, fit: BoxFit.cover, height: 1.0.sh, width: 1.0.sw);
              }).toList(),
          options: CarouselOptions(
            enableInfiniteScroll: false,
            autoPlayInterval: const Duration(seconds: 10),
            autoPlay: true,
            viewportFraction: 1,
            onPageChanged: (i, reason) => key.currentState!.changePage(i),
          ),
        ),
        16.0.verticalSpace,
        IndicatorSliderWidget(key: key, length: images.length),
      ],
    );
  }
}

class IndicatorSliderWidget extends StatefulWidget {
  const IndicatorSliderWidget({super.key, required this.length});

  final int length;

  @override
  State<IndicatorSliderWidget> createState() => IndicatorSliderWidgetState();
}

class IndicatorSliderWidgetState extends State<IndicatorSliderWidget> {
  late int selected;

  void changePage(int i) {
    setState(() => selected = i);
  }

  @override
  void initState() {
    selected = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 7.0.spMin,
      child: ListView.separated(
        itemCount: widget.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          return AnimatedContainer(
            width: 7.r,
            height: 7.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColorManager.mainColor.withValues(alpha: selected == i ? 1 : 0.2),
            ),
            duration: const Duration(milliseconds: 150),
          );
        },
        separatorBuilder: (context, i) => 5.0.horizontalSpace,
      ),
    );
  }
}
