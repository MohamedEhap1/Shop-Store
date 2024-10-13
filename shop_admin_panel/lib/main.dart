import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_admin_panel/consts/app_constans.dart';
import 'package:shop_admin_panel/consts/theme_data.dart';
import 'package:shop_admin_panel/firebase_options.dart';
import 'package:shop_admin_panel/providers/product_provider.dart';
import 'package:shop_admin_panel/providers/theme_provider.dart';
import 'package:shop_admin_panel/screens/dashboard_screen.dart';
import 'package:shop_admin_panel/screens/edit_upload_product.dart';
import 'package:shop_admin_panel/screens/order/order_screen.dart';
import 'package:shop_admin_panel/screens/search_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase before runApp
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder:
            (BuildContext context, ThemeProvider themeProvider, Widget? child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Shop Admin Panel",
            theme: Styles.themeData(
              isDarkTheme: themeProvider.getIsDarkTheme,
              context: context,
            ),
            home: const DashboardScreen(),
            routes: {
              AppConstans.searchScreenRoot: (context) => const SearchScreen(),
              AppConstans.orderScreenRoot: (context) => const OrderScreen(),
              AppConstans.editUploadProductRoot: (context) =>
                  const EditUploadProduct(),
            },
          );
        },
      ),
    );
  }
}
