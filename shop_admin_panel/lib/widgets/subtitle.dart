import 'package:flutter/material.dart';

class SubtitleText extends StatelessWidget {
  const SubtitleText({
    super.key,
    required this.text,
    this.fontStyle = FontStyle.normal,
    this.fontSize = 16,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.textDecoration = TextDecoration.none,
  });
  final String text;
  final FontStyle fontStyle;
  final double fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextDecoration textDecoration;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontStyle: fontStyle,
        decoration: textDecoration,
      ),
    );
  }
}
