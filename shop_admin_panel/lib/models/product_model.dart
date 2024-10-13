import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductModel with ChangeNotifier {
  final String productId,
      productTitle,
      productPrice,
      productImage,
      productCategory,
      productDescription,
      productQuantity;
  Timestamp? createAt;
  final Map<String, dynamic> productRating;
  final List usersRating;
  ProductModel({
    required this.productId,
    required this.productTitle,
    required this.productPrice,
    required this.productImage,
    required this.productCategory,
    required this.productDescription,
    required this.productQuantity,
    required this.usersRating,
    required this.productRating,
    this.createAt,
  });
  factory ProductModel.fromFireStore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      productId: data['productId'], //doc.get['productId']
      productTitle: data['productTitle'],
      productPrice: data['productPrice'],
      productImage: data['productImage'],
      productCategory: data['productCategory'],
      productDescription: data['productDescription'],
      productQuantity: data['productQuantity'],
      productRating: data['ratingOfProduct'],
      usersRating: data['usersRating'],
      createAt: data['createdAt'],
    );
  }
}
