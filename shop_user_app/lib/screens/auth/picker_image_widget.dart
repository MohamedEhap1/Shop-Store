import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickerImageWidget extends StatelessWidget {
  const PickerImageWidget(
      {super.key, required this.pickerImage, required this.function});
  final XFile? pickerImage;
  final Function function;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: pickerImage == null
                ? Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).cardColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  )
                : Image.file(
                    File(pickerImage!.path),
                    fit: BoxFit.fill,
                  ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Material(
            borderRadius: BorderRadius.circular(16),
            color: Colors.lightBlue,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                function();
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.photo_camera_back_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
