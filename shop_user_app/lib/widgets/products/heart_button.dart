import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:shop_user_app/provider/connection_provider.dart';
import 'package:shop_user_app/provider/wishlist_provider.dart';
import 'package:shop_user_app/services/my_app_methods.dart';
import 'package:toasty_box/toast_service.dart';

class HeartButtonWidget extends StatelessWidget {
  const HeartButtonWidget({
    super.key,
    this.size = 22,
    this.color = Colors.transparent,
    required this.productId,
  });
  final double size;
  final Color? color;
  final String productId;
  @override
  Widget build(BuildContext context) {
    final wishListProvider = Provider.of<WishListProvider>(context);

    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        style: IconButton.styleFrom(
          shape: const CircleBorder(),
        ),
        onPressed: () async {
          final connectivityService =
              Provider.of<ConnectivityService>(context, listen: false);
          if (!connectivityService.isConnected) {
            await ToastService.showToast(
              backgroundColor: Colors.red,
              leading: const Icon(Icons.wifi_off_sharp),
              context,
              message: "No internet connection",
            );
            return;
          }
          try {
            wishListProvider.isProductInWishList(productId: productId)
                ? await wishListProvider.removeWishListItemFromFireStore(
                    context: context,
                    id: wishListProvider.getWishListItems[productId]!.id,
                    productId: productId)
                : await wishListProvider.addWishListToFirebase(
                    productId: productId,
                    context: context,
                  );

            await wishListProvider.fetchWishList(context: context);
          } catch (e) {
            MyAppMethods.customAlertDialog(context, contentText: e.toString());
          }
        },
        icon: wishListProvider.isProductInWishList(productId: productId)
            ? Icon(
                IconlyBold.heart,
                size: size,
                color: Colors.red,
              )
            : Icon(IconlyLight.heart, size: size),
      ),
    );
  }
}
