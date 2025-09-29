//
// import 'package:drawable_text/drawable_text.dart';
// import 'package:livekit_manager/core/extensions/extensions.dart';
// import 'package:livekit_manager/core/widgets/text/title_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:m_cubit/util.dart';
//
// import '../../../generated/assets.dart';
// import '../../../generated/l10n.dart';
// import '../my_text_form_widget.dart';
//
// class DateTimeWidget extends StatefulWidget {
//   const DateTimeWidget({
//     super.key,
//     required this.onChange,
//     this.firstDate,
//     this.lastDate,
//     this.initial,
//     this.hint,
//   });
//
//   final String? hint;
//   final DateTime? Function()? initial;
//   final DateTime? Function()? firstDate;
//   final DateTime? Function()? lastDate;
//
//   final Function(DateTime? d) onChange;
//
//   @override
//   State<DateTimeWidget> createState() => _DateTimeWidgetState();
// }
//
// class _DateTimeWidgetState extends State<DateTimeWidget> {
//   DateTime time = DateTime.now().copyWith(hour: 0, minute: 0, second: 0);
//   TextEditingController? dController;
//
//   TextEditingController? tController;
//
//   void showTime() async {
//     await Navigator.of(context).push(
//       showPicker(
//         context: context,
//         is24HrFormat: false,
//         cancelText: S.of(context).cancel,
//         okText: S.of(context).done,
//         value: Time(hour: DateTime.now().hour, minute: DateTime.now().minute),
//         onChange: (p0) {
//           time = time.copyWith(hour: p0.hour, minute: p0.minute);
//         },
//       ),
//     );
//
//     tController?.text = time.formatTimeShow;
//     widget.onChange.call(time);
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     dController = TextEditingController(text: widget.initial?.call()?.formatDate);
//     tController = TextEditingController(text: widget.initial?.call()?.formatTimeShow);
//     return Column(
//       children: [
//         if (!widget.hint.isBlank)
//           DrawableText(
//             text: (widget.hint ?? '').capitalizeFirst,
//             size: 14.0.sp,
//             fontWeight: FontWeight.w500,
//             matchParent: true,
//             // padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 3.0).r,
//           ),
//         Row(
//           children: [
//             Expanded(
//               flex: 2,
//               child: MyTextFormWidget(
//                 controller: dController,
//                 enable: false,
//                 onTap: () async {
//                   showDatePicker(
//                     context: context,
//                     initialDate: widget.initial?.call(),
//                     firstDate: widget.firstDate?.call() ?? DateTime.now(),
//                     lastDate: widget.lastDate?.call() ?? DateTime(2030),
//                   ).then((pick) {
//                     if (pick == null) return;
//                     time = time.copyWith(day: pick.day, month: pick.month, year: pick.year);
//
//                     dController?.text = time.formatDateToRequest;
//                     showTime();
//                   });
//                 },
//                 icon: Assets.iconsCalendar,
//               ),
//             ),
//             10.0.horizontalSpace,
//             Expanded(
//               child: MyTextFormWidget(
//                 controller: tController,
//                 enable: false,
//                 onTap: showTime,
//                 icon: Assets.iconsClock,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
//
// class DateWidget extends StatefulWidget {
//   const DateWidget({
//     super.key,
//     required this.onChange,
//     this.firstDate,
//     this.lastDate,
//     this.initial,
//     this.hint,
//   });
//
//   final String? hint;
//   final DateTime? Function()? initial;
//   final DateTime? Function()? firstDate;
//   final DateTime? Function()? lastDate;
//
//   final Function(DateTime? d) onChange;
//
//   @override
//   State<DateWidget> createState() => _DateWidgetState();
// }
//
// class _DateWidgetState extends State<DateWidget> {
//   TextEditingController? dController;
//
//   @override
//   Widget build(BuildContext context) {
//     dController = TextEditingController(text: widget.initial?.call()?.formatDate);
//     return Column(
//       children: [
//         if (!widget.hint.isBlank) TitleText(widget.hint!),
//         MyTextFormWidget(
//           controller: dController,
//           enable: false,
//           onTap: () async {
//             showDatePicker(
//               context: context,
//               initialDate: widget.initial?.call(),
//               firstDate: widget.firstDate?.call() ?? DateTime.now(),
//               lastDate: widget.lastDate?.call() ?? DateTime(2030),
//             ).then((pick) {
//               if (pick == null) return;
//               dController?.text = pick.formatDateToRequest;
//               widget.onChange.call(pick);
//             });
//           },
//           icon: Assets.iconsCalendar,
//         ),
//       ],
//     );
//   }
// }
