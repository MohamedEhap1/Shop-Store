import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:shop_user_app/provider/cart_provider.dart';
import 'package:shop_user_app/provider/connection_provider.dart';
import 'package:shop_user_app/provider/product_provider.dart';
import 'package:shop_user_app/provider/user_provider.dart';
import 'package:shop_user_app/provider/viewed_recently_provider.dart';
import 'package:shop_user_app/provider/wishlist_provider.dart';
import 'package:shop_user_app/screens/cart_screen.dart';
import 'package:shop_user_app/screens/home_screen.dart';
import 'package:shop_user_app/screens/profile_screen.dart';
import 'package:shop_user_app/screens/search_screen.dart';
import 'package:shop_user_app/widgets/subtitle.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  late PageController controller;
  int currentScreen = 0;
  bool isLoadingProd = true;
  List<Widget> screens = const [
    HomeScreen(),
    SearchScreen(),
    CartScreen(),
    ProfileScreen(),
  ];
  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: currentScreen);
  }

  Future<void> fetchFun() async {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final connectionProvider =
        Provider.of<ConnectivityService>(context, listen: false);
    final wishListProvider =
        Provider.of<WishListProvider>(context, listen: false);
    final viewedRecentlyProvider =
        Provider.of<ViewedRecentlyProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      Future.wait({
        productProvider.fetchProducts(),
        connectionProvider.checkInitialConnection(),
        userProvider.fetchUserInfo(),
      });
      Future.wait({
        cartProvider.fetchCart(context: context),
        wishListProvider.fetchWishList(context: context),
        viewedRecentlyProvider.fetchViewedRecently(context: context),
      });
    } catch (e) {
      log(e.toString());
    } finally {
      isLoadingProd = false;
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    if (isLoadingProd) {
      fetchFun();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      body: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 2,
        height: kBottomNavigationBarHeight,
        selectedIndex: currentScreen,
        onDestinationSelected: (index) {
          setState(() {
            currentScreen = index;
            controller.jumpToPage(currentScreen);
          });
        },
        destinations: [
          const NavigationDestination(
            selectedIcon: Icon(IconlyBold.home),
            icon: Icon(IconlyLight.home),
            label: "Home",
          ),
          const NavigationDestination(
            selectedIcon: Icon(IconlyBold.search),
            icon: Icon(IconlyLight.search),
            label: "Search",
          ),
          Badge(
            isLabelVisible: cartProvider.getCartItems.isEmpty ? false : true,
            offset: const Offset(-40, -5),
            backgroundColor: Colors.red,
            textColor: Colors.white,
            label: SubtitleText(text: "${cartProvider.getCartItems.length}"),
            child: const NavigationDestination(
              selectedIcon: Icon(IconlyBold.chart),
              icon: Icon(IconlyLight.bag2),
              label: "Cart",
            ),
          ),
          const NavigationDestination(
            selectedIcon: Icon(IconlyBold.profile),
            icon: Icon(IconlyLight.profile),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
