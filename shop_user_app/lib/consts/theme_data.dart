import 'package:flutter/material.dart';
import 'package:shop_user_app/consts/app_color.dart';

class Styles {
  static ThemeData themeData(
      {required bool isDarkTheme, required BuildContext context}) {
    return ThemeData(
      scaffoldBackgroundColor: isDarkTheme
          ? AppColor.darkScaffoldColor
          : AppColor.lightScaffoldColor,
      cardColor: isDarkTheme ? AppColor.lightCardColor : AppColor.darkCardColor,
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        side: BorderSide(
          width: 1,
          style: BorderStyle.solid,
          color: isDarkTheme ? AppColor.lightCardColor : AppColor.darkCardColor,
        ),
        foregroundColor: isDarkTheme ? Colors.white : Colors.black,
      )),
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
            color: isDarkTheme ? Colors.white : Colors.black,
          ),
          backgroundColor: isDarkTheme
              ? AppColor.darkScaffoldColor
              : AppColor.lightScaffoldColor,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: 18,
            color: isDarkTheme ? Colors.white : Colors.black,
          )),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        contentPadding: const EdgeInsets.all(10),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1,
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1,
            // color: isDarkTheme ? Colors.white : Colors.black,
            color: Colors.blue,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.error,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.error,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
