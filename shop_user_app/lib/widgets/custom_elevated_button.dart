import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.text,
    this.padding = 20,
    this.elevation = 5,
    this.backgroundColor = Colors.red,
    this.textColor = Colors.white,
    this.fontSize = 20,
    this.shape = const CircleBorder(),
  });
  final String text;
  final double padding;
  final double elevation;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final OutlinedBorder shape;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: EdgeInsets.all(padding),
        elevation: elevation,
        shape: shape,
      ),
      onPressed: () {},
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize, color: textColor),
      ),
    );
  }
}
