import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_user_app/models/product_model.dart';
import 'package:toasty_box/toast_service.dart';

class RatingProvider with ChangeNotifier {
  //! get total current rating
  int getCounterRating({required ProductModel currentProduct}) {
    return currentProduct.productRating['counterOneStars'] +
        currentProduct.productRating['counterTwoStars'] +
        currentProduct.productRating['counterThreeStars'] +
        currentProduct.productRating['counterFourStars'] +
        currentProduct.productRating['counterFiveStars'];
  }

  //! average rating
  double averageRating({required ProductModel currentProduct}) {
    if (getCounterRating(currentProduct: currentProduct) == 0) {
      return 0;
    }
    return (currentProduct.productRating['counterOneStars'] +
            currentProduct.productRating['counterTwoStars'] * 2 +
            currentProduct.productRating['counterThreeStars'] * 3 +
            currentProduct.productRating['counterFourStars'] * 4 +
            currentProduct.productRating['counterFiveStars'] * 5) /
        double.parse(getCounterRating(currentProduct: currentProduct)
            .toDouble()
            .toStringAsFixed(2));
  }

  // List usersRate = getCurrentProduct!.usersRating;
//! check user rate or not
  bool checkRateOrNot(
      {required ProductModel currentProduct, required String userId}) {
    bool rateCheck = false;
    for (var userRateInfo in currentProduct.usersRating) {
      if (userRateInfo['userId'] == userId) {
        rateCheck = true;
        break;
      }
    }
    return rateCheck;
  }

//! get user rate
  Map getUserRate({required ProductModel currentProduct}) {
    final user = FirebaseAuth.instance.currentUser;

    Map userRatingMap = {};
    for (var userRateInfo in currentProduct.usersRating) {
      if (userRateInfo['userId'] == user!.uid) {
        userRatingMap = userRateInfo;
        break;
      }
    }
    return userRatingMap;
  }

//! get all user rate
  List getAllUsersRate({required ProductModel currentProduct}) {
    List usersRatingList = currentProduct.usersRating;
    return usersRatingList;
  }

//! add rate to firebase
  Future<void> addRate(
      {required int rating,
      required String comment,
      required ProductModel currentProduct,
      required BuildContext context,
      required String userId,
      required String userImage,
      required String userName}) async {
    if (!checkRateOrNot(currentProduct: currentProduct, userId: userId)) {
      // User has not rated yet, create a new rating map
      try {
        await FirebaseFirestore.instance
            .collection('products')
            .doc(currentProduct.productId)
            .update({
          'usersRating': FieldValue.arrayUnion(
            [
              {
                'userId': userId,
                'userImage': userImage,
                'userName': userName,
                'comment': comment,
                'rating': rating,
              },
            ],
          ),
        });
        await ToastService.showToast(
          backgroundColor: Colors.white,
          context,
          message: "😍 Thanks for your rating 😍",
          messageStyle: const TextStyle(color: Colors.black, fontSize: 18),
        );
      } catch (e) {
        await ToastService.showToast(
          backgroundColor: Colors.red,
          context,
          leading: const Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
          message: "Error in add rating",
        );
      }
    }
  }

//!update of total rating firebase
  Future<void> updateProductRating(String productId, int rating) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('products').doc(productId);

    // Determine which counter to increment based on the rating
    String counterField;
    switch (rating) {
      case 5:
        counterField = 'ratingOfProduct.counterFiveStars';
        break;
      case 4:
        counterField = 'ratingOfProduct.counterFourStars';
        break;
      case 3:
        counterField = 'ratingOfProduct.counterThreeStars';
        break;
      case 2:
        counterField = 'ratingOfProduct.counterTwoStars';
        break;
      case 1:
        counterField = 'ratingOfProduct.counterOneStars';
        break;
      default:
        throw Exception('Invalid rating: $rating');
    }

    // Update the specific counter for the selected rating
    await docRef.update({
      counterField: FieldValue.increment(1),
    }).then((_) {
      print('Counter for $rating star updated successfully!');
    }).catchError((error) {
      print('Failed to update counter: $error');
    });
  }
}
