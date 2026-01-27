// import 'package:drawable_text/drawable_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:image_multi_type/image_multi_type.dart';
// import 'package:livekit_manager/core/api_manager/api_service.dart';
// import 'package:livekit_manager/core/widgets/app_bar/app_bar_widget.dart';
// import 'package:livekit_manager/core/widgets/refresh_widget/refresh_widget.dart';
//
// import 'package:m_cubit/m_cubit.dart';
//
// import '../../../../core/app/app_provider.dart';
// import '../../../../core/strings/app_color_manager.dart';
// import '../../../../core/util/my_style.dart';
// import '../../../../router/go_router.dart';
//
// import '../../../lesson/bloc/active_session_cubit/active_session_cubit.dart';
// import '../../../staff_record/bloc/staff_details_cubit/staff_details_cubit.dart';
//
// var subjectsIcons = [
//   Icons.menu_book,
//   Icons.calculate,
//   Icons.science,
//   Icons.public,
//   Icons.auto_stories,
//   Icons.palette,
//   Icons.sports_soccer,
// ];
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ActiveSessionCubit, ActiveSessionInitial>(
//       builder: (context, state) {
//         return Scaffold(
//           appBar: AppBarWidget(
//             titleText: 'الجلسات',
//           ),
//           body: RefreshWidget(
//             onRefresh: () async {
//               context.read<ActiveSessionCubit>().getData(
//                 staffId: AppProvider.getStaff.staffRecordId,
//                 newData: true,
//               );
//             },
//             isLoading: state.loading,
//             child: SingleChildScrollView(
//               padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
//               child: Column(
//                 children: [
//                   _Live(),
//
//                   20.verticalSpace,
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
// class _Live extends StatelessWidget {
//   const _Live({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<StaffDetailsCubit, StaffDetailsInitial>(
//       builder: (context, state) {
//         if (state.loading || state.result.staffRecordId.isEmpty) {
//           return MyStyle.loadingWidget();
//         }
//
//         return BlocBuilder<ActiveSessionCubit, ActiveSessionInitial>(
//           builder: (context, state) {
//             if (state.loading) {
//               return MyStyle.loadingWidget(a
//             }
//
//             return state.result.onlineLessonToken.isBlank
//                 ? Container(
//                     margin: EdgeInsets.only(bottom: 20.h),
//                     padding: EdgeInsets.all(16.w),
//                     decoration: BoxDecoration(
//                       color: AppColorManager.secondColor,
//                       borderRadius: BorderRadius.circular(12.0).r,
//                     ),
//                     child: DrawableText(text: 'لا يوجد جلسات حاليا!!'),
//                   )
//                 : Container(
//                     margin: EdgeInsets.only(bottom: 20.h),
//                     padding: EdgeInsets.all(16.w),
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)],
//                         begin: Alignment.centerLeft,
//                         end: Alignment.centerRight,
//                       ),
//                       borderRadius: BorderRadius.circular(12.0).r,
//                       boxShadow: [
//                         BoxShadow(
//                           color: const Color(0xFFFF416C).withValues(alpha: 0.3),
//                           blurRadius: 15,
//                           offset: const Offset(0, 8),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             Container(
//                               width: 45.w,
//                               height: 45.w,
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withValues(alpha: 0.2),
//                                 shape: BoxShape.circle,
//                               ),
//                             ),
//                             Icon(Icons.live_tv_rounded, color: Colors.white, size: 24.w),
//                           ],
//                         ),
//                         SizedBox(width: 15.w),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               DrawableText(
//                                 text: "جلسة مباشرة الآن",
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16.sp,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               DrawableText(
//                                 text: "اضغط للدخول إلى الحصة التفاعلية",
//                                 style: TextStyle(
//                                   color: Colors.white.withValues(alpha: 0.9),
//                                   fontSize: 12.sp,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         ElevatedButton(
//                           onPressed: () {
//                             context.pushNamed(
//                               RouteName.home,
//                               queryParameters: {
//                                 'token': state.result.onlineLessonToken,
//                                 'link': state.result.onlineLessonUrl,
//                                 'lessonId': state.result.lessonId,
//                                 'lessonName': state.result.lessonTitle,
//                               },
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.white,
//                             foregroundColor: const Color(0xFFFF416C),
//                             elevation: 0,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12.r),
//                             ),
//                             padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
//                           ),
//                           child: DrawableText(
//                             text: "دخول",
//                             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//           },
//         );
//       },
//     );
//   }
// }
