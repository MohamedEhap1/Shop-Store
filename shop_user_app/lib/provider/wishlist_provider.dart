import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_user_app/models/wish_list_model.dart';
import 'package:shop_user_app/services/my_app_methods.dart';
import 'package:uuid/uuid.dart';

class WishListProvider with ChangeNotifier {
  final Map<String, WishlistModel> _wishListItems = {};
  Map<String, WishlistModel> get getWishListItems => _wishListItems;

  final userDB = FirebaseFirestore.instance.collection('users');
  final auth = FirebaseAuth.instance;

  bool isProductInWishList({required String productId}) {
    return _wishListItems.containsKey(productId);
  }

  void addORRemoveFromWishList({required String productId}) {
    if (_wishListItems.containsKey(productId)) {
      _wishListItems.remove(productId);
    } else {
      _wishListItems.putIfAbsent(
        productId,
        () => WishlistModel(
          id: const Uuid().v4(),
          productId: productId,
        ),
      );
    }
    notifyListeners();
  }

//! add wishlist to FireStore
  Future<void> addWishListToFirebase({
    required String productId,
    required BuildContext context,
  }) async {
    final User? user = auth.currentUser;
    if (user == null) {
      MyAppMethods.customAlertDialog(
        isError: true,
        context,
        contentText: "Please login",
      );
      return;
    }
    final uid = user.uid;
    final wishListId = const Uuid().v4();
    try {
      await userDB.doc(uid).update({
        'userWish': FieldValue.arrayUnion([
          {
            'id': wishListId,
            'productId': productId,
          }
          //!flutterToast
        ]),
      });
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await fetchWishList(context: context);
      });
    } catch (e) {
      rethrow;
    }
  }

//!fetch all product wishlist from fireStore
  Future<void> fetchWishList({required BuildContext context}) async {
    final User? user = auth.currentUser;
    if (user == null) {
      _wishListItems.clear();
      return;
    }
    try {
      final userDoc = await userDB.doc(user.uid).get();
      final data = userDoc.data();
      if (data == null || !data.containsKey("userWish")) {
        return;
      }
      final len = userDoc.get("userWish").length;
      for (int index = 0; index < len; index++) {
        _wishListItems.putIfAbsent(userDoc.get("userWish")[index]['productId'],
            () {
          return WishlistModel(
            id: userDoc.get("userWish")[index]['id'],
            productId: userDoc.get("userWish")[index]['productId'],
          );
        });
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

//! remove all element in wishlist List at fireStore
  Future<void> clearWishListFromFirebase() async {
    final User? user = auth.currentUser;
    try {
      if (user == null) {
        _wishListItems.clear();
        return;
      }
      await userDB.doc(user.uid).update({
        'userWish': [],
      });
      _wishListItems.clear();
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

//! remove item form wishlist list at fireStore
  Future<void> removeWishListItemFromFireStore({
    required context,
    required id,
    required productId,
  }) async {
    final User? user = auth.currentUser;
    try {
      if (user == null) {
        _wishListItems.clear();
        return;
      }
      await userDB.doc(user.uid).update({
        'userWish': FieldValue.arrayRemove([
          {
            'id': id,
            'productId': productId,
          }
          //!flutterToast
        ]),
      });

      _wishListItems.remove(productId);
      await fetchWishList(context: context);
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }
  // void removeOneItem({required String productId}) {
  //   _wishListItems.remove(productId);
  //   notifyListeners();
  // }

  void clearWishList() {
    _wishListItems.clear();
    notifyListeners();
  }
}
