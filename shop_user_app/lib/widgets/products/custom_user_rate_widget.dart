import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:shop_user_app/widgets/subtitle.dart';
import 'package:shop_user_app/widgets/title.dart';

class CustomUserRateWidget extends StatelessWidget {
  const CustomUserRateWidget({
    super.key,
    required this.userImage,
    required this.userName,
    required this.userComment,
    required this.userRating,
    this.canEdit = true,
  });
  final String userImage, userName, userComment;
  final double userRating;
  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                  userImage,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Column(
                children: [
                  TitleText(text: userName),
                  StarRating(
                    rating: userRating,
                    allowHalfRating: false,
                  ),
                ],
              ),
              const Spacer(),
              if (canEdit)
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert_rounded),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
            child: SubtitleText(
              text: userComment,
            ),
          ),
        ],
      ),
    );
  }
}
