import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_user_app/consts/app_constans.dart';
import 'package:shop_user_app/consts/theme_data.dart';
import 'package:shop_user_app/firebase_options.dart';
import 'package:shop_user_app/provider/all_order_provider.dart';
import 'package:shop_user_app/provider/cart_provider.dart';
import 'package:shop_user_app/provider/connection_provider.dart';
import 'package:shop_user_app/provider/product_provider.dart';
import 'package:shop_user_app/provider/rating_provider.dart';
import 'package:shop_user_app/provider/theme_provider.dart';
import 'package:shop_user_app/provider/user_provider.dart';
import 'package:shop_user_app/provider/viewed_recently_provider.dart';
import 'package:shop_user_app/provider/wishlist_provider.dart';
import 'package:shop_user_app/screens/auth/forget_password.dart';
import 'package:shop_user_app/screens/auth/login_screen.dart';
import 'package:shop_user_app/screens/auth/register_screen.dart';
import 'package:shop_user_app/screens/inner_screen/orders/order_screen.dart';
import 'package:shop_user_app/screens/inner_screen/product_details.dart';
import 'package:shop_user_app/screens/inner_screen/viewed_recently.dart';
import 'package:shop_user_app/screens/inner_screen/wishlist.dart';
import 'package:shop_user_app/screens/search_screen.dart';
import 'package:shop_user_app/screens/root_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    DevicePreview(
      backgroundColor: Colors.black,
      enabled: !kReleaseMode,
      builder: (BuildContext context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishListProvider()),
        ChangeNotifierProvider(create: (_) => ViewedRecentlyProvider()),
        ChangeNotifierProvider(create: (_) => AllOrderProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityService()),
        ChangeNotifierProvider(create: (_) => RatingProvider()),
      ],
      child: Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          title: "Shop App",
          theme: Styles.themeData(
              isDarkTheme: themeProvider.getIsDarkTheme, context: context),
          home: FirebaseAuth.instance.currentUser == null
              ? const LoginScreen()
              : const RootScreen(),
          routes: {
            AppConstans.loginScreenRoot: (context) => const LoginScreen(),
            AppConstans.searchScreenRoot: (context) => const SearchScreen(),
            AppConstans.rootScreenRoot: (context) => const RootScreen(),
            AppConstans.productDetailsRoot: (context) => const ProductDetails(),
            AppConstans.wishListRoot: (context) => const WishlistScreen(),
            AppConstans.viewedRecentlyRoot: (context) =>
                const ViewedRecentlyScreen(),
            AppConstans.registerScreenRoot: (context) => const RegisterScreen(),
            AppConstans.orderScreenRoot: (context) => const OrderScreen(),
            AppConstans.forgetPasswordRoot: (context) =>
                const ForgetPasswordScreen(),
          },
        );
      }),
    );
  }
}
