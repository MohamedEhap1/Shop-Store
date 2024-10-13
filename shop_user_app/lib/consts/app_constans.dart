import 'package:shop_user_app/models/category_model.dart';
import 'package:shop_user_app/services/assets_manager.dart';

class AppConstans {
  static String productImage =
      "https://th.bing.com/th/id/OIP.ZDo4Imi9R2QqDKOynhyNOwAAAA?rs=1&pid=ImgDetMain";
  static List<String> bannerImages = [
    AssetsManager.banner1,
    AssetsManager.banner2,
  ];

  static List<CategoryModel> categoriesList = [
    CategoryModel(
        id: AssetsManager.mobiles,
        image: AssetsManager.mobiles,
        name: "Phones"),
    CategoryModel(
        id: AssetsManager.pc, image: AssetsManager.pc, name: "Laptops"),
    CategoryModel(
        id: AssetsManager.electronics,
        image: AssetsManager.electronics,
        name: "Electronics"),
    CategoryModel(
        id: AssetsManager.watch, image: AssetsManager.watch, name: "Watches"),
    CategoryModel(
        id: AssetsManager.fashions,
        image: AssetsManager.fashions,
        name: "Clothes"),
    CategoryModel(
        id: AssetsManager.shoes, image: AssetsManager.shoes, name: "Shoes"),
    CategoryModel(
        id: AssetsManager.book, image: AssetsManager.book, name: "Books"),
    CategoryModel(
        id: AssetsManager.cosmetics,
        image: AssetsManager.cosmetics,
        name: "Cosmetics"),
  ];
//! page routes
  static const wishListRoot = "/WishListScreen";
  static const productDetailsRoot = "/ProductDetails";
  static const viewedRecentlyRoot = "/viewedRecentlyScreen";
  static const loginScreenRoot = "/LoginScreen";
  static const registerScreenRoot = "/RegisterScreen";
  static const rootScreenRoot = "/HomePage";
  static const orderScreenRoot = "/OrderScreen";
  static const forgetPasswordRoot = "/ForgetPasswordScreen";
  static const searchScreenRoot = "/SearchScreen";
}
