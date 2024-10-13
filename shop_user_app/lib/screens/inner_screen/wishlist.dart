import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_user_app/provider/connection_provider.dart';
import 'package:shop_user_app/provider/wishlist_provider.dart';
import 'package:shop_user_app/services/assets_manager.dart';
import 'package:shop_user_app/services/my_app_methods.dart';
import 'package:shop_user_app/widgets/custom_shimmer_app_name.dart';
import 'package:shop_user_app/widgets/cart/empty_cart.dart';
import 'package:shop_user_app/widgets/products/product_widget.dart';
import 'package:toasty_box/toast_service.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final wishListProvider = Provider.of<WishListProvider>(context);
    final connectivityService =
        Provider.of<ConnectivityService>(context, listen: false);
    return wishListProvider.getWishListItems.isEmpty
        ? EmptyPageWidget(
            size: size,
            title: "Whoops!",
            subTitle1: "Your WishList Is Empty",
            subTitle2:
                "Looks like you didn't add anything yet to your wishlist\ngo a head and start shopping now",
            buttonText: "Shop Now",
            imagePath: AssetsManager.bagWish,
          )
        : Scaffold(
            appBar: AppBar(
              title: CustomShimmerAppName(
                fontSize: 20,
                text: 'Wishlist (${wishListProvider.getWishListItems.length})',
                baseColor: Colors.purple,
                highlightColor: Colors.blue,
              ),
              actions: [
                IconButton(
                  onPressed: () async {
                    if (!connectivityService.isConnected) {
                      await ToastService.showToast(
                        backgroundColor: Colors.red,
                        leading: const Icon(Icons.wifi_off_sharp),
                        context,
                        message: "No internet connection",
                      );
                      return;
                    }
                    MyAppMethods.customAlertDialog(context,
                        contentText:
                            "Are you sure you want to remove All items?",
                        onPressed: () async {
                      await wishListProvider.clearWishListFromFirebase();
                      wishListProvider.clearWishList();
                    });
                  },
                  icon: const Icon(
                    Icons.delete_forever,
                  ),
                )
              ],
            ),
            body: DynamicHeightGridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: wishListProvider.getWishListItems.length,
                crossAxisCount: 2, //2 column of widget
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                builder: (context, index) {
                  return ProductWidget(
                    productId: wishListProvider.getWishListItems.values
                        .toList()[index]
                        .productId,
                  );
                }),
          );
  }
}
