import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  // Create an unique instance of the class //
  LoginProvider._privateConstructor();
  static final LoginProvider instance = LoginProvider._privateConstructor();

  @override
  void dispose() { }

  // All the variables values //
  bool isUserLoggedIn_ = false;
  bool gotNetworkConnection_ = true;

  bool isConnected_ = false;
  bool isConnecting_ = false;

  // Updaters //
  bool get isUserLoggedIn => isUserLoggedIn_;
  set isUserLoggedIn(bool value) {
    isUserLoggedIn_ = value;
    notifyListeners();
  }

  bool get gotNetworkConnection => gotNetworkConnection_;
  set gotNetworkConnection(bool value) {
    gotNetworkConnection_ = value;
    notifyListeners();
  }

  bool get isConnected => isConnected_;
  set isConnected(bool value) {
    isConnected_ = value;
    notifyListeners();
  }
  
  bool get isConnecting => isConnecting_;
  set isConnecting(bool value) {
    isConnecting_ = value;
    notifyListeners();
  }
}



