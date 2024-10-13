import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_user_app/models/viewed_recently.dart';
import 'package:shop_user_app/services/my_app_methods.dart';
import 'package:uuid/uuid.dart';

class ViewedRecentlyProvider with ChangeNotifier {
  final Map<String, ViewedRecentlyModel> _viewedRecentlyItems = {};
  Map<String, ViewedRecentlyModel> get getViewedRecentlyItems =>
      _viewedRecentlyItems;
  bool isProductInViewedRecentlyList({required String productId}) {
    return _viewedRecentlyItems.containsKey(productId);
  }

  final userDB = FirebaseFirestore.instance.collection('users');
  final auth = FirebaseAuth.instance;

  void addToViewedRecently({required String productId}) {
    _viewedRecentlyItems.putIfAbsent(
      productId,
      () => ViewedRecentlyModel(
        viewedRecentlyId: const Uuid().v4(),
        productId: productId,
      ),
    );

    notifyListeners();
  }

//! add viewedRecently to FireStore
  Future<void> addToViewedRecentlyFirebase({
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
    final viewedRecentlyId = const Uuid().v4();
    try {
      await userDB.doc(uid).update({
        'viewedRecently': FieldValue.arrayUnion([
          {
            'viewedRecentlyId': viewedRecentlyId,
            'productId': productId,
          }
          //!flutterToast
        ]),
      });
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await fetchViewedRecently(context: context);
      });
    } catch (e) {
      rethrow;
    }
  }

//!fetch all product viewed recently from fireStore
  Future<void> fetchViewedRecently({required BuildContext context}) async {
    final User? user = auth.currentUser;
    if (user == null) {
      _viewedRecentlyItems.clear();
      return;
    }
    try {
      final userDoc = await userDB.doc(user.uid).get();
      final data = userDoc.data();
      if (data == null || !data.containsKey("viewedRecently")) {
        return;
      }
      final len = userDoc.get("viewedRecently").length;
      for (int index = 0; index < len; index++) {
        _viewedRecentlyItems
            .putIfAbsent(userDoc.get("viewedRecently")[index]['productId'], () {
          return ViewedRecentlyModel(
            viewedRecentlyId: userDoc.get("viewedRecently")[index]
                ['viewedRecentlyId'],
            productId: userDoc.get("viewedRecently")[index]['productId'],
          );
        });
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

//! remove all element in viewedRecently List at fireStore
  Future<void> clearViewedRecentlyFromFirebase() async {
    final User? user = auth.currentUser;
    try {
      if (user == null) {
        _viewedRecentlyItems.clear();
        return;
      }
      await userDB.doc(user.uid).update({
        'viewedRecently': [],
      });
      _viewedRecentlyItems.clear();
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  // void removeOneItem({required String productId}) {
  //   _viewedRecentlyItems.remove(productId);
  //   notifyListeners();
  // }

  void clearViewedRecently() {
    _viewedRecentlyItems.clear();
    notifyListeners();
  }
}
