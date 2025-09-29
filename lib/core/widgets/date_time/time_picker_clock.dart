// import 'package:drawable_text/drawable_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:livekit_manager/core/extensions/extensions.dart';
// import 'package:livekit_manager/core/strings/app_color_manager.dart';
// import 'package:livekit_manager/core/widgets/my_button.dart';
// import 'package:livekit_manager/core/widgets/my_text_form_widget.dart';
//
//
// class TimePickerClock extends StatefulWidget {
//   const TimePickerClock({super.key, this.inBedTime, this.outBedTime, this.onSelect});
//
//   final PickedTime? inBedTime;
//   final PickedTime? outBedTime;
//   final Function(PickedTime start, PickedTime end)? onSelect;
//
//   @override
//   State<TimePickerClock> createState() => _TimePickerClockState();
// }
//
// class _TimePickerClockState extends State<TimePickerClock> {
//   ClockIncrementTimeFormat clockIncrementTimeFormat = ClockIncrementTimeFormat.fiveMin;
//   late PickedTime startTime;
//   late PickedTime endTime;
//
//   late PickedTime intervalTime;
//   late TextEditingController controller;
//   late TextEditingController controller1;
//
//   void pickTime(bool isStart) {
//     showTimePicker(
//       context: context,
//       initialTime: TimeOfDay(hour: isStart ? startTime.h : endTime.h, minute: isStart ? startTime.m : endTime.m),
//     ).then(
//       (pickedTime) {
//         if (pickedTime == null) return;
//         if (isStart) {
//           startTime = PickedTime(h: pickedTime.hour, m: pickedTime.minute);
//         } else {
//           endTime = PickedTime(h: pickedTime.hour, m: pickedTime.minute);
//         }
//
//         _updateLabels(startTime, endTime, false);
//         widget.onSelect?.call(startTime, endTime);
//       },
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     startTime = widget.inBedTime ?? PickedTime(h: 0, m: 0);
//     endTime = widget.outBedTime ?? PickedTime(h: 1, m: 0);
//     controller = TextEditingController(text: startTime.formatTime);
//     controller1 = TextEditingController(text: endTime.formatTime);
//     intervalTime = formatIntervalTime(init: startTime, end: endTime);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         TimePicker(
//           height: 260.0.r,
//           width: 260.0.r,
//           initTime: startTime,
//           endTime: endTime,
//           onSelectionChange: _updateLabels,
//           onSelectionEnd: (start, end, isDisableRange) {
//             widget.onSelect?.call(start, end);
//           },
//           primarySectors: ClockTimeFormat.twentyFourHours.value,
//           secondarySectors: ClockTimeFormat.twentyFourHours.value * 2,
//           decoration: TimePickerDecoration(
//             baseColor: AppColorManager.mainColorDark,
//             // pickerBaseCirclePadding: 15.0,
//             sweepDecoration: TimePickerSweepDecoration(
//               pickerStrokeWidth: 30.0,
//               pickerColor: AppColorManager.secondColor.withValues(alpha: 0.5),
//               showConnector: true,
//             ),
//             initHandlerDecoration: TimePickerHandlerDecoration(
//               color: AppColorManager.mainColor,
//               shape: BoxShape.circle,
//               radius: 12.0,
//               icon: Icon(
//                 Icons.not_started_outlined,
//                 size: 20.0,
//                 color: AppColorManager.secondColor,
//               ),
//             ),
//             endHandlerDecoration: TimePickerHandlerDecoration(
//               color: AppColorManager.mainColor,
//               shape: BoxShape.circle,
//               radius: 12.0,
//               icon: Icon(
//                 Icons.power_settings_new_outlined,
//                 size: 20.0,
//                 color: AppColorManager.secondColor,
//               ),
//             ),
//             primarySectorsDecoration: TimePickerSectorDecoration(
//               width: 1.0,
//               size: 4.0,
//               color: AppColorManager.secondColor,
//               radiusPadding: 25.0,
//             ),
//             secondarySectorsDecoration: TimePickerSectorDecoration(
//               width: 1.0,
//               color: AppColorManager.white,
//               size: 2.0,
//               radiusPadding: 25.0,
//             ),
//             clockNumberDecoration: TimePickerClockNumberDecoration(
//               defaultTextColor: Colors.white30,
//               defaultFontSize: 12.0,
//               scaleFactor: 1.5,
//               clockIncrementTimeFormat: ClockIncrementTimeFormat.thirtyMin,
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(62.0),
//             child: Center(
//               child: DrawableText(
//                 text: intervalTime.formatTimeHM,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//         10.0.verticalSpace,
//         Row(
//           children: [
//             Expanded(
//               child: InkWell(
//                 onTap: () => pickTime(true),
//                 child: _timeWidget(
//                   'start',
//                   controller,
//                 ),
//               ),
//             ),
//             10.0.horizontalSpace,
//             Expanded(
//               child: InkWell(
//                 onTap: () => pickTime(false),
//                 child: _timeWidget(
//                   'end',
//                   controller1,
//                 ),
//               ),
//             ),
//             10.0.horizontalSpace,
//             Expanded(
//               child: MyButton(
//                 onTap: () {
//                   startTime = PickedTime(h: 0, m: 0);
//                   endTime = PickedTime(h: 23, m: 59);
//                   _updateLabels(startTime, endTime, false);
//                   widget.onSelect?.call(startTime, endTime);
//                 },
//                 text: 'set all day',
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _timeWidget(String title, TextEditingController controller) {
//     return IgnorePointer(
//       ignoring: true,
//       child: MyTextFormWidget(
//         label: title,
//         controller: controller,
//         enable: false,
//       ),
//     );
//   }
//
//   void _updateLabels(PickedTime init, PickedTime end, bool? isDisableRange) {
//     startTime = init;
//     endTime = end;
//     intervalTime = formatIntervalTime(init: startTime, end: endTime);
//     controller.text = startTime.formatTime;
//     controller1.text = endTime.formatTime;
//     setState(() {});
//   }
// }
