// import 'package:livekit_manager/core/strings/app_color_manager.dart';
//
// import 'package:livekit_manager/core/util/my_style.dart';
//
//
// import 'package:drawable_text/drawable_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:persistent_bottom_nav_bar_v2/models/tab-view.widget.dart';
//
// import '../../../../generated/assets.dart';
// import 'package:image_multi_type/image_multi_type.dart';
//
// import '../util/my_style.dart';
//
// class BottomNavigator extends StatefulWidget {
//   const BottomNavigator({super.key, required this.onChange});
//
//   final Function(int) onChange;
//
//   @override
//   State<BottomNavigator> createState() => BottomNavigatorState();
// }
//
// class BottomNavigatorState extends State<BottomNavigator> {
//   var selectedIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 54.0.h,
//       width: 1.0.sw,
//       clipBehavior: Clip.hardEdge,
//       decoration: BoxDecoration(
//         border: MyStyle.appBorderAll,
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(26.0.r),
//         ),
//       ),
//       child: BottomNavyBar(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         selectedIndex: selectedIndex,
//         itemCornerRadius: 30.0.r,
//         onItemSelected: (value) {
//           setState(() => selectedIndex = value);
//           widget.onChange(value);
//         },
//         backgroundColor: AppColorManager.f6,
//         showElevation: true,
//         items: [
//           BottomNavyBarItem(
//             icon: ImageMultiType(url: Assets.iconsHome),
//             title: DrawableText(text: 'home', size: 14.0.sp),
//             activeColor: AppColorManager.mainColor,
//             inactiveColor: AppColorManager.mainColor,
//           ),
//           BottomNavyBarItem(
//             icon: ImageMultiType(url: Assets.iconsHome),
//             title: DrawableText(text: 'courses', size: 14.0.sp),
//             activeColor: AppColorManager.mainColor,
//             inactiveColor: AppColorManager.mainColor,
//           ),
//           BottomNavyBarItem(
//             icon: ImageMultiType(url: Assets.iconsHome),
//             title: DrawableText(text: 'liaisons', size: 14.0.sp),
//             activeColor: AppColorManager.mainColor,
//             inactiveColor: AppColorManager.mainColor,
//           ),
//           BottomNavyBarItem(
//             icon: ImageMultiType(url: Assets.iconsHome),
//             title: DrawableText(text: 'profile', size: 14.0.sp),
//             activeColor: AppColorManager.mainColor,
//             inactiveColor: AppColorManager.mainColor,
//           ),
//         ],
//       ),
//     );
//   }
// }
