import 'package:flutter/material.dart';
import 'package:shop_user_app/widgets/custom_elevated_button.dart';
import 'package:shop_user_app/widgets/subtitle.dart';
import 'package:shop_user_app/widgets/title.dart';

class EmptyPageWidget extends StatelessWidget {
  const EmptyPageWidget({
    super.key,
    required this.size,
    required this.title,
    required this.subTitle1,
    required this.subTitle2,
    required this.buttonText,
    required this.imagePath,
  });

  final Size size;
  final String title, subTitle1, subTitle2, buttonText, imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(top: 50),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              imagePath,
              height: size.height * .30,
              width: double.infinity,
            ),
            TitleText(
              text: title,
              fontSize: 40,
              color: Colors.red,
            ),
            const SizedBox(
              height: 20,
            ),
            SubtitleText(
              text: subTitle1,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: SubtitleText(
                text: subTitle2,
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomElevatedButton(
              text: buttonText,
              shape: const LinearBorder(),
            )
          ],
        ),
      ),
    ));
  }
}
