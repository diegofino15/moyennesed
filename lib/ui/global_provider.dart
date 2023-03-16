import 'package:flutter/material.dart';

class GlobalProvider with ChangeNotifier {
  // Create an unique instance of the class //
  GlobalProvider._privateConstructor();
  static final GlobalProvider instance = GlobalProvider._privateConstructor();

  @override
  // ignore: must_call_super
  void dispose() { }

  // All the variables values //
  bool isUserLoggedIn_ = false;
  bool gotNetworkConnection_ = true;

  bool isConnected_ = false;
  bool isConnecting_ = false;

  bool gotGrades_ = false;
  bool isGettingGrades_ = false;

  int currentPeriodIndex_ = 1;
  String get currentPeriodCode => "A00$currentPeriodIndex";

  bool isDarkMode_ = false;

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

  bool get gotGrades => gotGrades_;
  set gotGrades(bool value) {
    gotGrades_ = value;
    notifyListeners();
  }

  bool get isGettingGrades => isGettingGrades_;
  set isGettingGrades(bool value) {
    isGettingGrades_ = value;
    notifyListeners();
  }

  int get currentPeriodIndex => currentPeriodIndex_;
  set currentPeriodIndex(int value) {
    currentPeriodIndex_ = value;
    notifyListeners();
  }

  bool get isDarkMode => isDarkMode_;
  set isDarkMode(bool value) {
    isDarkMode_ = value;
    notifyListeners();
  }
}



