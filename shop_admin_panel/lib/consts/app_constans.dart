import 'package:flutter/material.dart';

class AppConstans {
  static String productImage =
      "https://th.bing.com/th/id/OIP.ZDo4Imi9R2QqDKOynhyNOwAAAA?rs=1&pid=ImgDetMain";

  // static List<CategoryModel> categoriesList = [
  //   CategoryModel(
  //       id: AssetsManager.mobiles,
  //       image: AssetsManager.mobiles,
  //       name: "Phones"),
  //   CategoryModel(
  //       id: AssetsManager.pc, image: AssetsManager.pc, name: "Laptops"),
  //   CategoryModel(
  //       id: AssetsManager.electronics,
  //       image: AssetsManager.electronics,
  //       name: "Electronics"),
  //   CategoryModel(
  //       id: AssetsManager.watch, image: AssetsManager.watch, name: "Watches"),
  //   CategoryModel(
  //       id: AssetsManager.fashions,
  //       image: AssetsManager.fashions,
  //       name: "Clothes"),
  //   CategoryModel(
  //       id: AssetsManager.shoes, image: AssetsManager.shoes, name: "Shoes"),
  //   CategoryModel(
  //       id: AssetsManager.book, image: AssetsManager.book, name: "Books"),
  //   CategoryModel(
  //       id: AssetsManager.cosmetics,
  //       image: AssetsManager.cosmetics,
  //       name: "Cosmetics"),
  // ];
  //!Category List
  static List<String> categoryList = [
    "Phones",
    "Laptops",
    "Electronics",
    "Watches",
    "Clothes",
    "Shoes",
    "Books",
    "Cosmetics",
  ];
  static List<DropdownMenuItem<String>>? get categoriesDropDownList {
    List<DropdownMenuItem<String>>? menuItems =
        List<DropdownMenuItem<String>>.generate(categoryList.length, (index) {
      return DropdownMenuItem(
        value: categoryList[index],
        child: Text(categoryList[index]),
      );
    });
    return menuItems;
  }

//! page routes
  static const searchScreenRoot = "/SearchScreen";
  static const orderScreenRoot = "/OrderScreen";
  static const editUploadProductRoot = "/EditUploadProductScreen";
}
