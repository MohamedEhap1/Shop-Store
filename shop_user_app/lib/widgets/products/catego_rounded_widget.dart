import 'package:flutter/material.dart';
import 'package:shop_user_app/consts/app_constans.dart';
import 'package:shop_user_app/widgets/subtitle.dart';

class CategoryRoundedWidget extends StatelessWidget {
  const CategoryRoundedWidget({
    super.key,
    required this.image,
    required this.name,
  });
  final String image, name;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.pushNamed(
          context,
          AppConstans.searchScreenRoot,
          arguments: name,
        );
      },
      child: Column(
        children: [
          Image.asset(
            image,
            height: 50,
            width: 50,
          ),
          const SizedBox(
            height: 15,
          ),
          Flexible(
            child: SubtitleText(
              text: name,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
