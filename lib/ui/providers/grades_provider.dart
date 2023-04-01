import 'package:flutter/material.dart';

class GradesProvider with ChangeNotifier {
  // Create an unique instance of the class //
  GradesProvider._privateConstructor();
  static final GradesProvider instance = GradesProvider._privateConstructor();

  @override
  void dispose() { }

  bool gotGrades_ = false;
  bool isGettingGrades_ = false;

  int currentPeriodIndex_ = 1;
  String get currentPeriodCode => "A00$currentPeriodIndex";

  // Updaters //
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
}



