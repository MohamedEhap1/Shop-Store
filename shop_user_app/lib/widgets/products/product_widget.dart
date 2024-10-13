import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_user_app/consts/app_color.dart';
import 'package:shop_user_app/consts/app_constans.dart';
import 'package:shop_user_app/provider/cart_provider.dart';
import 'package:shop_user_app/provider/connection_provider.dart';
import 'package:shop_user_app/provider/product_provider.dart';
import 'package:shop_user_app/provider/rating_provider.dart';
import 'package:shop_user_app/provider/viewed_recently_provider.dart';
import 'package:shop_user_app/services/my_app_methods.dart';
import 'package:shop_user_app/widgets/products/heart_button.dart';
import 'package:shop_user_app/widgets/subtitle.dart';
import 'package:shop_user_app/widgets/title.dart';
import 'package:toasty_box/toast_service.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({
    super.key,
    required this.productId,
  });
  final String productId;
  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    // final productModelProvider = Provider.of<ProductModel>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final getCurrentProduct = productProvider.findByProvider(widget.productId);
    final viewedRecentlyProvider = Provider.of<ViewedRecentlyProvider>(context);
    final ratingProvider = Provider.of<RatingProvider>(context);
    Size size = MediaQuery.of(context).size;
    return getCurrentProduct == null
        ? const SizedBox.shrink()
        : InkWell(
            borderRadius: BorderRadius.circular(15),
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
                  productId: widget.productId)) {
                await viewedRecentlyProvider.addToViewedRecentlyFirebase(
                    productId: widget.productId, context: context);
              }
              if (!mounted) return;

              await Navigator.pushNamed(
                context,
                AppConstans.productDetailsRoot,
                arguments: widget.productId,
              );
            },
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: FancyShimmerImage(
                          imageUrl: getCurrentProduct.productImage,
                          height: size.height * 0.32,
                          width: double.infinity,
                          boxFit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Flexible(
                            flex: 4,
                            child: TitleText(
                              fontSize: 18,
                              text: getCurrentProduct.productTitle,
                              maxLines: 2,
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: HeartButtonWidget(
                              productId: getCurrentProduct.productId,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 4,
                              child: SubtitleText(
                                text: "${getCurrentProduct.productPrice} \$",
                                fontSize: 18,
                                color: Colors.blue,
                              ),
                            ),
                            Flexible(
                              child: Material(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.lightBlue,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () async {
                                    final connectivityService =
                                        Provider.of<ConnectivityService>(
                                            context,
                                            listen: false);
                                    if (!connectivityService.isConnected) {
                                      await ToastService.showToast(
                                        backgroundColor: Colors.red,
                                        leading:
                                            const Icon(Icons.wifi_off_sharp),
                                        context,
                                        message: "No internet connection",
                                      );
                                      return;
                                    }
                                    if (cartProvider.isProductInCart(
                                        productId:
                                            getCurrentProduct.productId)) {
                                      return;
                                    }
                                    // cartProvider.addProductCart(
                                    //     productId: getCurrentProduct.productId);
                                    try {
                                      await cartProvider.addCartToFirebase(
                                        productId: getCurrentProduct.productId,
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
                                        );
                                      });
                                    }
                                  },
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: cartProvider.isProductInCart(
                                              productId:
                                                  getCurrentProduct.productId)
                                          ? const Icon(
                                              Icons.check,
                                              size: 20,
                                            )
                                          : const Icon(
                                              Icons.add_shopping_cart_rounded,
                                              size: 20,
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor ==
                                    AppColor.darkScaffoldColor
                                ? Colors.white
                                : Colors.black,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            topRight: Radius.circular(15),
                          ),
                        ),
                      ),
                      icon: const Icon(
                        Icons.star_rate_rounded,
                        color: Colors.amber,
                        size: 24,
                      ),
                      onPressed: () {},
                      label: Text(
                        ratingProvider
                            .averageRating(
                              currentProduct: getCurrentProduct,
                            )
                            .toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(context).scaffoldBackgroundColor ==
                                  AppColor.darkScaffoldColor
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
