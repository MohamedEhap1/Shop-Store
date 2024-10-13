import 'dart:developer';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rating_summary/rating_summary.dart';
import 'package:shop_user_app/provider/cart_provider.dart';
import 'package:shop_user_app/provider/connection_provider.dart';
import 'package:shop_user_app/provider/product_provider.dart';
import 'package:shop_user_app/provider/rating_provider.dart';
import 'package:shop_user_app/widgets/products/custom_user_rate_widget.dart';
import 'package:shop_user_app/widgets/products/product_user_rate.dart';
import 'package:shop_user_app/services/my_app_methods.dart';
import 'package:shop_user_app/widgets/custom_shimmer_app_name.dart';
import 'package:shop_user_app/widgets/products/heart_button.dart';
import 'package:shop_user_app/widgets/subtitle.dart';
import 'package:shop_user_app/widgets/title.dart';
import 'package:toasty_box/toast_service.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final ValueNotifier<bool> showMore = ValueNotifier(false);

  Future<void> fetchFun() async {
    final productProvider = Provider.of<ProductProvider>(context);
    try {
      Future.wait({
        productProvider.fetchProducts(),
      });
      Future.wait({});
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchFun();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final cartProvider = Provider.of<CartProvider>(context);

    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final getCurrentProduct = productProvider.findByProvider(productId);
    final rateProvider = Provider.of<RatingProvider>(context);

    return Scaffold(
      //! AppBar
      appBar: AppBar(
        centerTitle: true,
        title: const CustomShimmerAppName(
          fontSize: 20,
          text: 'Shop Store',
          baseColor: Colors.purple,
          highlightColor: Colors.blue,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FancyShimmerImage(
              imageUrl: getCurrentProduct!.productImage,
              height: size.height * 0.3,
              width: double.infinity,
              boxFit: BoxFit.contain,
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          getCurrentProduct.productTitle,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      SubtitleText(
                        text: "${getCurrentProduct.productPrice} \$",
                        fontSize: 20,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        HeartButtonWidget(
                          productId: getCurrentProduct.productId,
                          color: Colors.lightBlue,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: kBottomNavigationBarHeight - 10,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightBlue,
                              ),
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
                                    productId: getCurrentProduct.productId)) {
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
                                        onPressed: () {
                                      Navigator.pop(context);
                                    });
                                  });
                                }
                              },
                              label: Text(
                                cartProvider.isProductInCart(
                                        productId: getCurrentProduct.productId)
                                    ? "Added to cart"
                                    : "Add to cart",
                                style: const TextStyle(color: Colors.white),
                              ),
                              icon: cartProvider.isProductInCart(
                                      productId: getCurrentProduct.productId)
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    )
                                  : const Icon(
                                      Icons.add_shopping_cart,
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TitleText(text: "About this item"),
                      SubtitleText(
                          text: "in ${getCurrentProduct.productCategory}"),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SubtitleText(
                    text: getCurrentProduct.productDescription,
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  ProductUserRate(
                    currentProduct: getCurrentProduct,
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  //! rating
                  RatingSummary(
                    counter: rateProvider.getCounterRating(
                        currentProduct: getCurrentProduct),
                    average: (rateProvider.averageRating(
                        currentProduct: getCurrentProduct)),
                    showAverage: true,
                    counterFiveStars:
                        getCurrentProduct.productRating['counterFiveStars'],
                    counterFourStars:
                        getCurrentProduct.productRating['counterFourStars'],
                    counterThreeStars:
                        getCurrentProduct.productRating['counterThreeStars'],
                    counterTwoStars:
                        getCurrentProduct.productRating['counterTwoStars'],
                    counterOneStars:
                        getCurrentProduct.productRating['counterOneStars'],
                  ),
                  const SizedBox(
                    height: 15,
                  ),

                  Align(
                    alignment: Alignment.topLeft,
                    child: TitleText(
                      text:
                          "Total Ratings (${rateProvider.getAllUsersRate(currentProduct: getCurrentProduct).length})",
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: showMore,
              builder: (context, showMore, child) {
                if (!showMore &&
                    rateProvider
                            .getAllUsersRate(
                              currentProduct: getCurrentProduct,
                            )
                            .length >
                        3) {
                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return CustomUserRateWidget(
                        canEdit: false,
                        userImage: rateProvider.getAllUsersRate(
                          currentProduct: getCurrentProduct,
                        )[index]['userImage'],
                        userName: rateProvider.getAllUsersRate(
                          currentProduct: getCurrentProduct,
                        )[index]['userName'],
                        userComment: rateProvider.getAllUsersRate(
                          currentProduct: getCurrentProduct,
                        )[index]['comment'],
                        userRating: double.parse(
                          rateProvider
                              .getAllUsersRate(
                                currentProduct: getCurrentProduct,
                              )[index]['rating']
                              .toString(),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        color: Colors.grey,
                      );
                    },
                  );
                } else {
                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: rateProvider
                        .getAllUsersRate(
                          currentProduct: getCurrentProduct,
                        )
                        .length,
                    itemBuilder: (context, index) {
                      return CustomUserRateWidget(
                        canEdit: false,
                        userImage: rateProvider.getAllUsersRate(
                          currentProduct: getCurrentProduct,
                        )[index]['userImage'],
                        userName: rateProvider.getAllUsersRate(
                          currentProduct: getCurrentProduct,
                        )[index]['userName'],
                        userComment: rateProvider.getAllUsersRate(
                          currentProduct: getCurrentProduct,
                        )[index]['comment'],
                        userRating: double.parse(
                          rateProvider
                              .getAllUsersRate(
                                currentProduct: getCurrentProduct,
                              )[index]['rating']
                              .toString(),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        indent: 70,
                        endIndent: 70,
                        color: Colors.grey,
                      );
                    },
                  );
                }
              },
            ),
            ValueListenableBuilder<bool>(
              valueListenable: showMore,
              builder: (context, value, child) {
                return Visibility(
                  visible: rateProvider
                          .getAllUsersRate(
                            currentProduct: getCurrentProduct,
                          )
                          .length >
                      3,
                  replacement: const SizedBox.shrink(),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      )),
                      backgroundColor: Colors.lightBlue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      showMore.value = !showMore.value;
                    },
                    icon: value
                        ? const Icon(Icons.arrow_drop_up)
                        : const Icon(Icons.arrow_drop_down),
                    label: value
                        ? const Text("Show less")
                        : const Text("Show More"),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
