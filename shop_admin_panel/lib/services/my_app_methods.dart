import 'package:flutter/material.dart';
import 'package:shop_admin_panel/services/assets_manager.dart';
import 'package:shop_admin_panel/widgets/subtitle.dart';
import 'package:shop_admin_panel/widgets/title.dart';

class MyAppMethods {
  static Future<void> customAlertDialog(
    BuildContext context, {
    required String contentText,
    required void Function()? onPressed,
    bool isError = false,
  }) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          icon: Image.asset(
            isError ? AssetsManager.error : AssetsManager.warning,
            height: 60,
            width: 60,
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TitleText(
                text: contentText,
                maxLines: 2,
                fontSize: 15,
              )
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            Visibility(
              visible: !isError,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const SubtitleText(
                  text: "Cancel",
                  color: Colors.red,
                ),
              ),
            ),
            TextButton(
              onPressed: onPressed,
              child: const SubtitleText(
                text: "Ok",
                color: Colors.green,
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> imagePickerDialog({
    required BuildContext context,
    required Function camera,
    required Function gallery,
    required Function remove,
  }) async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext cxt) {
          return AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: const Center(child: TitleText(text: "Choose option")),
            content: SingleChildScrollView(
              child: ListBody(
                //like column
                children: [
                  TextButton.icon(
                    onPressed: () {
                      camera();
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera"),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      gallery();
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.image),
                    label: const Text("Gallery"),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      remove();
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.remove_circle),
                    label: const Text("Remove"),
                  ),
                ],
              ),
            ),
          );
        });
  }

  static void customSnackBar({
    required BuildContext context,
    required String message,
    required int seconds,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: seconds),
        showCloseIcon: true,
        closeIconColor: Colors.blue,
        content: Text(
          message,
        ),
      ),
    );
  }
}
