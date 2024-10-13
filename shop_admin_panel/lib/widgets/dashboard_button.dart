import 'package:flutter/material.dart';
import 'package:shop_admin_panel/widgets/subtitle.dart';

class DashboardButton extends StatelessWidget {
  const DashboardButton(
      {super.key, required this.image, required this.text, this.onTap});
  final String image;
  final String text;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              height: 65,
              width: 65,
            ),
            const SizedBox(
              height: 15,
            ),
            SubtitleText(
              text: text,
              fontSize: 18,
            ),
          ],
        ),
      ),
    );
  }
}
