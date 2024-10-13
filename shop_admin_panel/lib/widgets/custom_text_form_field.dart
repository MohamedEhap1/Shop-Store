import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.keyValue,
    required this.minLines,
    required this.maxLines,
    required this.hintText,
    this.keyboardType,
    this.maxLength,
    this.validator,
    this.inputFormatters,
    this.prefix,
    this.textCapitalization = TextCapitalization.none,
    this.onTap,
  });
  final TextEditingController controller;
  final String keyValue;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int minLines;
  final int maxLines;
  final String hintText;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefix;
  final TextCapitalization textCapitalization;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      key: ValueKey(keyValue),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      minLines: minLines,
      maxLines: maxLines,
      textCapitalization: textCapitalization,
      decoration: InputDecoration(
        hintText: hintText,
        prefix: prefix,
      ),
      validator: validator,
      onTap: onTap,
    );
  }
}
