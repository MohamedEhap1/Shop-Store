import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  const TitleText({
    super.key,
    required this.text,
    this.fontStyle = FontStyle.normal,
    this.fontSize = 20,
    this.color,
    this.maxLines,
  });
  final String text;
  final FontStyle fontStyle;
  final double fontSize;
  final Color? color;
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color,
        fontStyle: fontStyle,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
