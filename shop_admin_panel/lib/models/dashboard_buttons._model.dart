import 'package:flutter/material.dart';
import 'package:shop_admin_panel/consts/app_constans.dart';
import 'package:shop_admin_panel/services/assets_manager.dart';

class DashboardButtonsModel {
  final String image;
  final String text;
  final void Function()? onTap;

  DashboardButtonsModel({
    required this.image,
    required this.text,
    required this.onTap,
  });

  static List<DashboardButtonsModel> dashboardButtonsList(
          BuildContext context) =>
      [
        DashboardButtonsModel(
          image: AssetsManager.cloud,
          text: "Add a new product",
          onTap: () async {
            await Navigator.pushNamed(
                context, AppConstans.editUploadProductRoot);
          },
        ),
        DashboardButtonsModel(
          image: AssetsManager.shoppingCart,
          text: "Inspect all products",
          onTap: () async {
            await Navigator.pushNamed(context, AppConstans.searchScreenRoot);
          },
        ),
        DashboardButtonsModel(
          image: AssetsManager.orderDashboard,
          text: "View orders",
          onTap: () async {
            await Navigator.pushNamed(context, AppConstans.orderScreenRoot);
          },
        ),
      ];
}
