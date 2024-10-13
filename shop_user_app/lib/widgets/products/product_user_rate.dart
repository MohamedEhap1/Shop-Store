import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:shop_user_app/models/product_model.dart';
import 'package:shop_user_app/models/user_model.dart';
import 'package:shop_user_app/provider/connection_provider.dart';
import 'package:shop_user_app/provider/rating_provider.dart';
import 'package:shop_user_app/provider/user_provider.dart';
import 'package:shop_user_app/services/my_app_methods.dart';
import 'package:shop_user_app/widgets/products/custom_user_rate_widget.dart';
import 'package:shop_user_app/widgets/title.dart';
import 'package:toasty_box/toast_service.dart';

class ProductUserRate extends StatefulWidget {
  const ProductUserRate({
    super.key,
    required this.currentProduct,
  });
  final ProductModel currentProduct;

  @override
  State<ProductUserRate> createState() => _ProductUserRateState();
}

class _ProductUserRateState extends State<ProductUserRate> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel? userModel;
  Future<void> fetchUserInfo() async {
    if (user == null) {
      return;
    }
    final userProvider = Provider.of<UserProvider>(context);
    try {
      userModel = await userProvider.fetchUserInfo();
      setState(() {});
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        MyAppMethods.customSnackBar(
          context: context,
          message: 'An error has been occurred $e',
          seconds: 3,
        );
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    final rateProvider = Provider.of<RatingProvider>(context);
    return (userModel?.userId != null &&
            rateProvider.checkRateOrNot(
                currentProduct: widget.currentProduct,
                userId: userModel!.userId))
        ? Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: TitleText(text: "You are already rated this product"),
              ),
              const SizedBox(
                height: 15,
              ),
              CustomUserRateWidget(
                userImage: rateProvider.getUserRate(
                    currentProduct: widget.currentProduct)['userImage'],
                userName: rateProvider.getUserRate(
                    currentProduct: widget.currentProduct)['userName'],
                userComment: rateProvider.getUserRate(
                    currentProduct: widget.currentProduct)['comment'],
                userRating: double.parse(
                  rateProvider
                      .getUserRate(
                          currentProduct: widget.currentProduct)['rating']
                      .toString(),
                ),
              ),
            ],
          )
        : GestureDetector(
            onTap: () async {
              await showDialog(
                context: context,
                builder: (context) {
                  return RatingDialog(
                    initialRating: 1.0,
                    // your app's name?
                    title: const Text(
                      'Rating Dialog',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // encourage your user to leave a high rating?
                    message: const Text(
                      'Tap a star to set your rating. Add more description here if you want.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
                    // your app's logo?
                    image: Image.asset(
                      "assets/images/app_icon.png",
                      height: 100,
                      width: 100,
                    ),
                    submitButtonText: 'Submit',
                    commentHint: 'Write your comment',
                    onCancelled: () {},
                    onSubmitted: (response) async {
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
                      rateProvider.addRate(
                        rating: response.rating.toInt(),
                        comment: response.comment,
                        currentProduct: widget.currentProduct,
                        context: context,
                        userId: userModel!.userId,
                        userImage: userModel!.userImage,
                        userName: userModel!.userName,
                      );
                      // await addRate(
                      //   rating: response.rating.toInt(),
                      //   comment: response.comment,
                      // );
                      await rateProvider.updateProductRating(
                          widget.currentProduct.productId,
                          response.rating.toInt());
                      // await updateProductRating(
                      //     productId, response.rating.toInt());
                      if (response.rating < 3.0) {
                        // send their comments to your email or anywhere you wish
                        // ask the user to contact you instead of leaving a bad review
                      } else {
                        // _rateAndReviewApp();
                      }
                    },
                  );
                },
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const TitleText(text: "Tap To Rate : "),
                StarRating(
                  rating: 0.0,
                  allowHalfRating: false,
                ),
              ],
            ),
          );
  }
}
