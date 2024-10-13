import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:shop_user_app/widgets/subtitle.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.imagePath,
    required this.text,
    this.onTap,
  });
  final String imagePath, text;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Image.asset(
        imagePath,
        height: 30,
      ),
      title: SubtitleText(text: text),
      trailing: const Icon(IconlyLight.arrowRight2),
    );
  }
}
