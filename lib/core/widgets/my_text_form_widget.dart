import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:m_cubit/m_cubit.dart';

class MyTextFormWidget extends StatefulWidget {
  const MyTextFormWidget({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.maxLines,
    this.obscureText,
    this.textAlign,
    this.maxLength,
    this.onChanged,
    this.controller,
    this.keyBordType,
    this.enable,
    this.initialValue,
    this.textDirection,
    this.validator,
    this.iconWidget,
    this.iconWidgetLift,
    this.onChangedFocus,
    this.onTap,
    this.isRequired = false,
    this.autofillHints,
    this.titleLabel,
    this.inputFormatters,
  });

  final bool? enable;
  final String? label;
  final String? titleLabel;
  final String? hint;
  final String? helperText;
  final dynamic iconWidget;
  final dynamic iconWidgetLift;
  final int? maxLines;
  final int? maxLength;
  final bool? obscureText;
  final bool isRequired;
  final TextAlign? textAlign;
  final Function(String)? onChanged;
  final Function(bool)? onChangedFocus;
  final Function()? onTap;

  final List<String>? autofillHints;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? keyBordType;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final TextDirection? textDirection;

  @override
  State<MyTextFormWidget> createState() => _MyTextFormWidgetState();
}

class _MyTextFormWidgetState extends State<MyTextFormWidget> {
  FocusNode? focusNode;
  var obscureText = false;

  @override
  void initState() {
    obscureText = widget.obscureText ?? false;
    focusNode = FocusNode()..addListener(() => widget.onChangedFocus?.call(focusNode!.hasFocus));
    super.initState();
  }

  Widget? get prefixIcon => widget.iconWidget == null
      ? null
      : ImageMultiType(
          url: widget.iconWidget,
          height: 24.0.dg,
          width: 24.0.dg,
        );

  Widget? get suffixIcon => (widget.obscureText ?? false)
      ? IconButton(
          splashRadius: 0.01,
          onPressed: () => setState(() => obscureText = !obscureText),
              icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
        )
      : widget.iconWidgetLift == null
          ? null
          : ImageMultiType(
              url: widget.iconWidgetLift,
              height: 24.0.dg,
              width: 24.0.dg,
            );

  Widget get title => widget.titleLabel.isBlank
      ? 0.0.verticalSpace
      : DrawableText(
          text: widget.titleLabel!.capitalizeFirst,
          size: 14.sp,
          matchParent: true,
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0).r,
          drawableEnd: widget.isRequired ? const DrawableText(text: ' *', color: Colors.red) : null,
        );

  InputDecoration get decoration {
    return InputDecoration(
      counter: 0.0.verticalSpace,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      helperText: widget.helperText,
      label: widget.label.isBlank ? null : DrawableText(text: widget.label!),
      hintText: widget.hint,
      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        title,
        TextFormField(
          decoration: decoration,
          obscureText: obscureText,
          autofillHints: widget.autofillHints,
          onTap: () => widget.onTap?.call(),
          validator: widget.validator,
          maxLines: widget.maxLines ?? 1,
          readOnly: !(widget.enable ?? true),
          initialValue: widget.initialValue,
          textAlign: widget.textAlign ?? TextAlign.start,
          onChanged: widget.onChanged,
          inputFormatters: widget.inputFormatters,
          focusNode: focusNode,
          textDirection: widget.textDirection,
          maxLength: widget.maxLength,
          controller: widget.controller,
          keyboardType: widget.keyBordType,
        ),
      ],
    );
  }
}

class DecimalPercentageInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.replaceAll('%', ''); // أزل % أولاً

    // فقط أرقام ونقطة
    final filteredText = text.replaceAll(RegExp(r'[^0-9.]'), '');

    // تحقق من وجود أكثر من نقطة
    if ('.'.allMatches(filteredText).length > 1) {
      return oldValue;
    }

    // منع تنسيقات خاطئة مثل 00.1
    if (filteredText.startsWith('00') && !filteredText.startsWith('0.')) {
      return oldValue;
    }

    final value = double.tryParse(filteredText) ?? 0;

    // لا تسمح بقيمة أكبر من 100
    if (value > 100) {
      return oldValue;
    }

    final result = '$filteredText%';

    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length - 1), // المؤشر قبل %
    );
  }
}

class MaxValueInputFormatter extends TextInputFormatter {
  final num max;

  MaxValueInputFormatter(this.max);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (text.isEmpty) return newValue;

    final value = num.tryParse(text);
    if (value == null) return oldValue;

    final parts = text.split('.');
    if (parts.length > 1 && parts[1].length > 2) {
      return oldValue;
    }

    if (value > max) {
      return oldValue;
    }

    return newValue;
  }
}
