import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shop_user_app/provider/cart_provider.dart';
import 'package:shop_user_app/provider/connection_provider.dart';
import 'package:shop_user_app/provider/product_provider.dart';
import 'package:shop_user_app/provider/user_provider.dart';
import 'package:shop_user_app/services/assets_manager.dart';
import 'package:shop_user_app/services/my_app_methods.dart';
import 'package:shop_user_app/widgets/cart/cart_bottom_checkout.dart';
import 'package:shop_user_app/widgets/cart/cart_widget.dart';
import 'package:shop_user_app/widgets/custom_shimmer_app_name.dart';
import 'package:shop_user_app/widgets/cart/empty_cart.dart';
import 'package:toasty_box/toast_service.dart';
import 'package:uuid/uuid.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final connectivityService =
        Provider.of<ConnectivityService>(context, listen: false);
    return cartProvider.getCartItems.isEmpty
        ? EmptyPageWidget(
            size: size,
            title: "Whoops!",
            subTitle1: "Your Cart Is Empty",
            subTitle2:
                "Looks like you didn't add anything yet to your cart\ngo a head and start shopping now",
            buttonText: "Shop Now",
            imagePath: AssetsManager.shoppingBasket,
          )
        : Scaffold(
            bottomSheet: CartBottomCheckout(
              checkOutFun: () async {
                await placeOrder(
                  cartProvider: cartProvider,
                  productProvider: productProvider,
                  userProvider: userProvider,
                );
              },
            ),
            appBar: AppBar(
              leading: Image.asset(AssetsManager.shoppingCart),
              title: CustomShimmerAppName(
                fontSize: 20,
                text: 'Cart (${cartProvider.getCartItems.length})',
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
                        contentText: "Remove All", onPressed: () async {
                      await cartProvider.clearCartFromFirebase();
                    });
                  },
                  icon: const Icon(
                    Icons.delete_forever,
                  ),
                )
              ],
            ),
            body: ModalProgressHUD(
              inAsyncCall: isLoading,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: cartProvider.getCartItems.length,
                        itemBuilder: (context, index) {
                          return ChangeNotifierProvider.value(
                              value: cartProvider.getCartItems.values
                                  .toList()
                                  .reversed
                                  .toList()[index], //as it map
                              child: const CartWidget());
                        }),
                  ),
                  const SizedBox(
                    height: kBottomNavigationBarHeight + 25,
                  ),
                ],
              ),
            ),
          );
  }

  Future<void> placeOrder({
    required CartProvider cartProvider,
    required ProductProvider productProvider,
    required UserProvider userProvider,
  }) async {
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user == null) {
      return;
    }
    final uid = user.uid;
    try {
      setState(() {
        isLoading = true;
      });
      cartProvider.getCartItems.forEach((key, value) async {
        final getCurrentProduct =
            productProvider.findByProvider(value.productId);
        final orderId = const Uuid().v4();
        await FirebaseFirestore.instance.collection("orders").doc(orderId).set({
          'orderId': orderId,
          'userId': uid,
          'productId': value.productId,
          'productTitle': getCurrentProduct!.productTitle,
          'price':
              double.parse(getCurrentProduct.productPrice) * value.quantity,
          'totalPrice': cartProvider.getTotal(productProvider: productProvider),
          'userName': userProvider.getUserModel!.userName,
          'imageUrl': getCurrentProduct.productImage,
          'quantity': value.quantity,
          'orderDate': Timestamp.now(),
        });
      });
      await cartProvider.clearCartFromFirebase();
      cartProvider.clearCart();
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        MyAppMethods.customAlertDialog(
          context,
          contentText: e.toString(),
        );
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
