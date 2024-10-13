import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_user_app/provider/cart_provider.dart';
import 'package:shop_user_app/provider/connection_provider.dart';
import 'package:shop_user_app/provider/product_provider.dart';
import 'package:shop_user_app/widgets/subtitle.dart';
import 'package:shop_user_app/widgets/title.dart';
import 'package:toasty_box/toast_service.dart';

class CartBottomCheckout extends StatelessWidget {
  const CartBottomCheckout({super.key, required this.checkOutFun});
  final Function checkOutFun;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final connectivityService =
        Provider.of<ConnectivityService>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: const Border(
          top: BorderSide(width: 1, color: Colors.grey),
        ),
      ),
      child: SizedBox(
        height: kBottomNavigationBarHeight + 30,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                        //! small the text to suit the size
                        child: TitleText(
                            text:
                                "Total (${cartProvider.getCartItems.length} Product/${cartProvider.getTotalQuantity()} Items)")),
                    SubtitleText(
                      text:
                          "${cartProvider.getTotal(productProvider: productProvider)}\$",
                      color: Colors.blue,
                    )
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: const LinearBorder(),
                ),
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
                  await checkOutFun();
                },
                child: const Text("Checkout"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
