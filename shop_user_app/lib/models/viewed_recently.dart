import 'package:flutter/material.dart';

class ViewedRecentlyModel with ChangeNotifier {
  final String viewedRecentlyId;
  final String productId;

  ViewedRecentlyModel({
    required this.viewedRecentlyId,
    required this.productId,
  });
}
