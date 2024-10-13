import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shimmer/shimmer.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key, required this.onPressed});
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.blue,
      ),
      onPressed: onPressed,
      label: const Text(
        "Sign in with google",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      icon: Shimmer.fromColors(
        direction: ShimmerDirection.ltr,
        period: const Duration(seconds: 3),
        baseColor: const Color.fromARGB(255, 115, 11, 4),
        highlightColor: const Color.fromARGB(255, 244, 10, 22),
        child: const Icon(
          Ionicons.logo_google,
        ),
      ),
    );
  }
}
