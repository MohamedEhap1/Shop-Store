import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityService with ChangeNotifier {
  bool _isConnected = false;

  ConnectivityService() {
    // Check initial connectivity
    checkInitialConnection();

    // Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((result) {
      _isConnected = (result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi));
      notifyListeners(); // Notify listeners when connectivity changes
    });
  }

  Future<void> checkInitialConnection() async {
    final result = await Connectivity().checkConnectivity();
    _isConnected = (result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi));
    notifyListeners(); // Notify listeners of the initial state
  }

  bool get isConnected => _isConnected;
}
