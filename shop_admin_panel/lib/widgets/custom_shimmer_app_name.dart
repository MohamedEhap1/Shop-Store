import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shop_admin_panel/widgets/title.dart';

class CustomShimmerAppName extends StatelessWidget {
  const CustomShimmerAppName({
    super.key,
    required this.text,
    required this.baseColor,
    required this.highlightColor,
    this.fontSize = 30,
  });
  final String text;
  final Color baseColor;
  final Color highlightColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      direction: ShimmerDirection.ltr,
      period: const Duration(seconds: 3),
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: TitleText(
        text: text,
        fontSize: fontSize,
      ),
    );
  }
}
