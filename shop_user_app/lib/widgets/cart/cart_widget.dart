import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_user_app/models/cart_model.dart';
import 'package:shop_user_app/provider/cart_provider.dart';
import 'package:shop_user_app/provider/connection_provider.dart';
import 'package:shop_user_app/provider/product_provider.dart';
import 'package:shop_user_app/services/my_app_methods.dart';
import 'package:shop_user_app/widgets/products/heart_button.dart';
import 'package:shop_user_app/widgets/subtitle.dart';
import 'package:shop_user_app/widgets/title.dart';
import 'package:toasty_box/toast_service.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cartModelProvider = Provider.of<CartModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrentProduct =
        productProvider.findByProvider(cartModelProvider.productId);
    final connectivityService =
        Provider.of<ConnectivityService>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return getCurrentProduct == null
        ? const SizedBox.shrink()
        : FittedBox(
            child: IntrinsicWidth(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: FancyShimmerImage(
                        imageUrl: getCurrentProduct.productImage,
                        height: size.height * 0.25, //! half of height
                        width: size.height * 0.2,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IntrinsicWidth(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                  width: size.width * 0.6,
                                  child: TitleText(
                                    text: getCurrentProduct.productTitle,
                                  )),
                              Column(
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        MyAppMethods.customAlertDialog(context,
                                            contentText:
                                                "Are you sure you want Remove this item ?",
                                            onPressed: () async {
                                          if (!connectivityService
                                              .isConnected) {
                                            await ToastService.showToast(
                                              backgroundColor: Colors.red,
                                              leading: const Icon(
                                                  Icons.wifi_off_sharp),
                                              context,
                                              message: "No internet connection",
                                            );
                                            return;
                                          }
                                          await cartProvider
                                              .removeCartItemFromFireStore(
                                            context: context,
                                            cartId: cartModelProvider.cartId,
                                            productId:
                                                getCurrentProduct.productId,
                                            qty: cartModelProvider.quantity,
                                          );
                                        });
                                      },
                                      icon: const Icon(Icons.clear)),
                                  HeartButtonWidget(
                                    productId: getCurrentProduct.productId,
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            children: [
                              SubtitleText(
                                text: "${getCurrentProduct.productPrice}\$",
                                fontSize: 20,
                                color: Colors.blue,
                              ),
                              // OutlinedButton.icon(
                              //   style:
                              //       Theme.of(context).outlinedButtonTheme.style,
                              //   onPressed: () {
                              //     showModalBottomSheet(
                              //         backgroundColor: Theme.of(context)
                              //             .scaffoldBackgroundColor,
                              //         shape: const RoundedRectangleBorder(
                              //           borderRadius: BorderRadius.only(
                              //               topLeft: Radius.circular(16),
                              //               topRight: Radius.circular(16)),
                              //         ),
                              //         context: context,
                              //         builder: (context) {
                              //           return const QuantityBottomSheet();
                              //         });
                              //   },
                              //   icon: const Icon(IconlyLight.arrowDown),
                              //   label: Text(
                              //       "Qty : ${getCurrentProduct.productQuantity}"),
                              // )
                              const Spacer(
                                flex: 5,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  // int qty = (int.parse(
                                  //       getCurrentProduct.productQuantity,
                                  //     ) -
                                  //     1);
                                  // cartProvider.updateQuantity(
                                  //   productId: cartModelProvider.productId,
                                  //   quantity: qty,
                                  // );
                                  if (!connectivityService.isConnected) {
                                    await ToastService.showToast(
                                      backgroundColor: Colors.red,
                                      leading: const Icon(Icons.wifi_off_sharp),
                                      context,
                                      message: "No internet connection",
                                    );
                                    return;
                                  }

                                  await cartProvider.updateQuantityFireStore(
                                    cartId: cartModelProvider.cartId,
                                    productId: getCurrentProduct.productId,
                                    qty: int.parse(
                                        getCurrentProduct.productQuantity),
                                    context: context,
                                    op: '-',
                                  );
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 9),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        style: BorderStyle.solid,
                                        color: Colors.red,
                                      )),
                                  child: const TitleText(
                                      text: "-", color: Colors.red),
                                ),
                              ),
                              const Spacer(
                                flex: 1,
                              ),
                              SubtitleText(
                                text: cartProvider
                                    .getQuantity(
                                        cartId: cartModelProvider.cartId)
                                    .toString(),
                              ),
                              const Spacer(
                                flex: 1,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    // int qty = (int.parse(
                                    //       getCurrentProduct.productQuantity,
                                    //     ) +
                                    //     1);
                                    // cartProvider.updateQuantity(
                                    //   productId: cartModelProvider.productId,
                                    //   quantity: qty,
                                    // );
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
                                    await cartProvider.updateQuantityFireStore(
                                      cartId: cartModelProvider.cartId,
                                      productId: getCurrentProduct.productId,
                                      qty: int.parse(
                                          getCurrentProduct.productQuantity),
                                      context: context,
                                      op: '+',
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 9),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          style: BorderStyle.solid,
                                          color: Colors.blue,
                                        )),
                                    child: const TitleText(
                                      text: "+",
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
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
