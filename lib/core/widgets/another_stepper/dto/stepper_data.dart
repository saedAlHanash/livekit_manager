import 'package:flutter/material.dart';

class StepperData {
  /// title for the stepper
  final Widget title;

  /// subtitle for the stepper
  final Widget subtitle;

  final Widget? iconWidget;
  final Color? color;

  /// Use the constructor of [StepperData] to pass the data needed.
  StepperData(
      {this.iconWidget,
      required this.title,
      required this.subtitle,
      this.color});
}

class StepperText {
  /// text for the stepper
  final String text;

  /// textStyle for stepper
  final TextStyle? textStyle;

  StepperText(this.text, {this.textStyle});
}
