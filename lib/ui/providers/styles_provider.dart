import 'package:flutter/material.dart';

class StylesProvider with ChangeNotifier {
  // Create an unique instance of the class //
  StylesProvider._privateConstructor();
  static final StylesProvider instance = StylesProvider._privateConstructor();

  @override
  void dispose() { }

  // All the variables values //
  bool isDarkMode_ = false;

  // Updaters //
  bool get isDarkMode => isDarkMode_;
  set isDarkMode(bool value) {
    isDarkMode_ = value;
    notifyListeners();
  }
}



