import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_user_app/models/all_order_model.dart';

class AllOrderProvider with ChangeNotifier {
  final List<AllOrderModel> orders = [];
  List<AllOrderModel> get getOrder => orders;
  //! fetch all products
  Future<List<AllOrderModel>> fetchOrder() async {
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    var userId = user!.uid;
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .get()
          .then((ordersSnapShot) {
        orders.clear();
        for (var element in ordersSnapShot.docs) {
          orders.insert(
              0,
              AllOrderModel(
                orderId: element.get('orderId'),
                userId: userId,
                productId: element.get("productId"),
                productTitle: element.get('productTitle'),
                userName: element.get('userName'),
                price: element.get('price').toString(),
                imageUrl: element.get('imageUrl'),
                quantity: element.get('quantity').toString(),
                orderDate: element.get('orderDate'),
              ));
        }
      });
      return orders;
    } catch (e) {
      rethrow;
    }
  }
}
