import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_user_app/consts/app_constans.dart';
import 'package:shop_user_app/models/product_model.dart';
import 'package:shop_user_app/provider/cart_provider.dart';
import 'package:shop_user_app/provider/connection_provider.dart';
import 'package:shop_user_app/provider/viewed_recently_provider.dart';
import 'package:shop_user_app/services/my_app_methods.dart';
import 'package:shop_user_app/widgets/products/heart_button.dart';
import 'package:shop_user_app/widgets/title.dart';
import 'package:toasty_box/toast_service.dart';

class LatestArrivalProduct extends StatelessWidget {
  const LatestArrivalProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final productModel = Provider.of<ProductModel>(context);
    final viewedRecentlyProvider = Provider.of<ViewedRecentlyProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {
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
          if (!viewedRecentlyProvider.isProductInViewedRecentlyList(
              productId: productModel.productId)) {
            await viewedRecentlyProvider.addToViewedRecentlyFirebase(
                productId: productModel.productId, context: context);
          }

          await Navigator.pushNamed(context, AppConstans.productDetailsRoot,
              arguments: productModel.productId);
        },
        child: SizedBox(
          width: size.width * 0.45,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: FancyShimmerImage(
                    imageUrl: productModel.productImage,
                    height: size.height * 0.15,
                    width: size.height * 0.15,
                  ),
                ),
              ),
              const SizedBox(
                width: 7,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productModel.productTitle,
                      maxLines: 2,
                      style: const TextStyle(overflow: TextOverflow.ellipsis),
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                          HeartButtonWidget(
                            productId: productModel.productId,
                          ),
                          IconButton(
                            onPressed: () async {
                              final connectivityService =
                                  Provider.of<ConnectivityService>(context,
                                      listen: false);
                              if (!connectivityService.isConnected) {
                                await ToastService.showToast(
                                  backgroundColor: Colors.red,
                                  leading: const Icon(Icons.wifi_off_sharp),
                                  context,
                                  message: "No internet connection",
                                );
                                return;
                              }
                              if (cartProvider.isProductInCart(
                                  productId: productModel.productId)) {
                                return;
                              }
                              // cartProvider.addProductCart(
                              //     productId: getCurrentProduct.productId);
                              try {
                                await cartProvider.addCartToFirebase(
                                  productId: productModel.productId,
                                  qty: 1,
                                  context: context,
                                );
                              } catch (e) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) async {
                                  MyAppMethods.customAlertDialog(
                                      isError: true,
                                      context,
                                      contentText: e.toString(),
                                      onPressed: () {});
                                });
                              }
                            },
                            icon: cartProvider.isProductInCart(
                                    productId: productModel.productId)
                                ? const Icon(
                                    Icons.check,
                                    size: 18,
                                  )
                                : const Icon(
                                    Icons.add_shopping_cart_rounded,
                                    size: 18,
                                  ),
                          ),
                        ],
                      ),
                    ),
                    FittedBox(
                      child: TitleText(
                        text: "${productModel.productPrice}\$",
                        color: Colors.blue,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
