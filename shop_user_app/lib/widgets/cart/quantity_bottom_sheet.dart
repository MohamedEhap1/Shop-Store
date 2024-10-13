import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_user_app/widgets/subtitle.dart';

class QuantityBottomSheet extends StatelessWidget {
  const QuantityBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 6,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
                // shrinkWrap: true,
                // physics: const NeverScrollableScrollPhysics(),
                physics: const BouncingScrollPhysics(),
                itemCount: 30,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      log(index.toString()); //! start form zero index
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Center(
                        child: SubtitleText(
                          fontSize: 20,
                          text: "${index + 1}",
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
