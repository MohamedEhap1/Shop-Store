import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const themekey = "THemeStatus";
  bool _darkTheme = false;
  bool get getIsDarkTheme => _darkTheme;
  ThemeProvider() {
    getTheme();
  }
  Future<void> setTheme({required bool themeValue}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(themekey, themeValue);
    _darkTheme = themeValue;
    notifyListeners(); //listen to changes
  }

  Future<bool> getTheme() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _darkTheme = pref.getBool(themekey) ?? false;
    notifyListeners();
    return _darkTheme;
  }
}
