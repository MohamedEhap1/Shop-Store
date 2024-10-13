import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_user_app/models/cart_model.dart';
import 'package:shop_user_app/models/product_model.dart';
import 'package:shop_user_app/provider/product_provider.dart';
import 'package:shop_user_app/services/my_app_methods.dart';
import 'package:uuid/uuid.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartModel> _cartItems = {};
  Map<String, CartModel> get getCartItems => _cartItems;
  bool isProductInCart({required String productId}) {
    return _cartItems.containsKey(productId);
  }

  final userDB = FirebaseFirestore.instance.collection('users');
  final auth = FirebaseAuth.instance;
  //! add cart to FireStore
  Future<void> addCartToFirebase({
    required String productId,
    required int qty,
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
    final cartId = const Uuid().v4();
    try {
      await userDB.doc(uid).update({
        'userCart': FieldValue.arrayUnion([
          {
            'cartId': cartId,
            'productId': productId,
            'quantity': qty,
          }
          //!flutterToast
        ]),
      });
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await fetchCart(context: context);
      });
    } catch (e) {
      rethrow;
    }
  }

  //! update quantity in FireStore
  Future<void> updateQuantityFireStore(
      {required String cartId,
      required String productId,
      required int qty,
      required BuildContext context,
      required String op}) async {
    final User? user = auth.currentUser;
    if (user == null) {
      MyAppMethods.customAlertDialog(
        isError: true,
        context,
        contentText: "Please login",
      );
      return;
    }
    try {
      final uid = user.uid;
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        // List<Map<String, dynamic>> userCart = userDoc['userCart'];
        int oldQty = 0;
        for (var element in userDoc['userCart']) {
          if (element['cartId'] == cartId) {
            oldQty = element['quantity'];
            break;
          }
        }
        // Extract quantities from the userCart array
        // userCart.map<int>((item) {
        //   return item['quantity'] as int; // Get the quantity value
        // }).toList();
        int currentQty = oldQty;
        if (op == '+') {
          if (currentQty < qty) {
            currentQty++;
          }
        } else if (op == '-') {
          if (currentQty != 0) {
            currentQty--;
          }
        }
        if (oldQty != 0 && currentQty != 0) {
          await userDB.doc(uid).update({
            'userCart': FieldValue.arrayRemove([
              {
                'cartId': cartId,
                'productId': productId,
                'quantity': oldQty,
              }
              //!flutterToast
            ]),
          });
          await userDB.doc(uid).update({
            'userCart': FieldValue.arrayUnion([
              {
                'cartId': cartId,
                'productId': productId,
                'quantity': currentQty,
              }
              //!flutterToast
            ]),
          });
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await fetchCart(context: context);
          });
        }
      }
    } catch (e) {
      MyAppMethods.customAlertDialog(
        context,
        contentText: e.toString(),
      );
    }
  }

//!fetch all product carts from fireStore
  Future<void> fetchCart({required BuildContext context}) async {
    final User? user = auth.currentUser;
    if (user == null) {
      _cartItems.clear();
      return;
    }
    try {
      final userDoc = await userDB.doc(user.uid).get();
      final data = userDoc.data();
      if (data == null || !data.containsKey("userCart")) {
        return;
      }
      final len = userDoc.get("userCart").length;
      _cartItems.clear();
      for (int index = 0; index < len; index++) {
        _cartItems.putIfAbsent(userDoc.get("userCart")[index]['productId'], () {
          return CartModel(
            cartId: userDoc.get("userCart")[index]['cartId'],
            productId: userDoc.get("userCart")[index]['productId'],
            quantity: userDoc.get("userCart")[index]['quantity'],
          );
        });
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

//! remove all element in cart List at fireStore
  Future<void> clearCartFromFirebase() async {
    final User? user = auth.currentUser;
    try {
      if (user == null) {
        _cartItems.clear();
        return;
      }
      await userDB.doc(user.uid).update({
        'userCart': [],
      });
      _cartItems.clear();
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

//! remove item form cart list at fireStore
  Future<void> removeCartItemFromFireStore({
    required context,
    required cartId,
    required productId,
    required qty,
  }) async {
    final User? user = auth.currentUser;
    try {
      if (user == null) {
        _cartItems.clear();
        return;
      }
      await userDB.doc(user.uid).update({
        'userCart': FieldValue.arrayRemove([
          {
            'cartId': cartId,
            'productId': productId,
            'quantity': qty,
          }
          //!flutterToast
        ]),
      });

      _cartItems.remove(productId);
      await fetchCart(context: context);
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  void addProductCart({required String productId}) {
    _cartItems.putIfAbsent(
      productId,
      () => CartModel(
        cartId: const Uuid().v4(),
        productId: productId,
        quantity: 1,
      ),
    );
    notifyListeners();
  }

  void updateQuantity({required String productId, required int quantity}) {
    _cartItems.update(
      productId,
      (item) => CartModel(
        cartId: item.cartId,
        productId: productId,
        quantity: quantity > 1 ? quantity : 1,
      ),
    );
    notifyListeners();
  }

  double getTotal({required ProductProvider productProvider}) {
    double total = 0.0;
    _cartItems.forEach((key, value) {
      final ProductModel? getCurrentProduct =
          productProvider.findByProvider(value.productId);
      if (getCurrentProduct != null) {
        total += double.parse(getCurrentProduct.productPrice) * value.quantity;
      }
    });
    return total;
  }

//! get quantity for each user cart
  int getQuantity({required String cartId}) {
    int qty = 1;
    _cartItems.forEach((key, value) {
      if (value.cartId == cartId) {
        qty = value.quantity;
      }
    });
    return qty;
  }

//!get total quantity
  int getTotalQuantity() {
    int total = 0;
    _cartItems.forEach((key, value) {
      total += value.quantity;
    });
    return total;
    //   final User? user = auth.currentUser;
    //   if (user == null) {
    //     MyAppMethods.customAlertDialog(
    //       isError: true,
    //       context,
    //       contentText: "Please login",
    //     );
    //     return 0;
    //   }
    //   try {
    //     final uid = user.uid;
    //     DocumentSnapshot userDoc =
    //         await FirebaseFirestore.instance.collection('users').doc(uid).get();

    //     if (userDoc.exists) {
    //       List<dynamic> userCart = userDoc['userCart'];

    //       // Extract quantities from the userCart array
    //       int currentQty = userCart.map<int>((item) {
    //         return item['quantity'] as int; // Get the quantity value
    //       }).toList()[0];

    //       WidgetsBinding.instance.addPostFrameCallback((_) async {
    //         await fetchCart(context: context);
    //       });
    //       return currentQty;
    //     }
    //   } catch (e) {
    //     rethrow;
    //   }
    //   notifyListeners();
    //   return 0;
    // }

    // void removeOneItem({required String productId}) {
    //   _cartItems.remove(productId);
    //   notifyListeners();
  }

//! remove all items form List
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
