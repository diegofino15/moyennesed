import 'package:flutter/material.dart';
import 'package:moyennesed/ui/global_provider.dart';

class Styles {
  static const Map<String, List<Color>> colors = {
    "background": [
      Color(0xFFececec),
      Color(0xFF0D1117),
    ],
    "widgetBackground": [
      Color(0xFFf6f6f6),
      Color(0xFF21262D),
    ],
    "mainText": [
      Colors.black,
      Colors.white
    ],
    "subtitleText": [
      Colors.black54,
      Colors.white60
    ],
  };
  static Color getColor(String key) => GlobalProvider.instance.isDarkMode ? colors[key]![1] : colors[key]![0];

  // Main background color of the app //
  static Color get backgroundColor => getColor("background");

  // Main widget background color //
  static Color get mainWidgetBackgroundColor => getColor("widgetBackground");

  // Colors for each subject //
  static const List<List<Color>> subjectColors = [
    [Color(0xFFff6242), Color(0xFFFFA590)], // Red
    [Color(0xFF5BAEB7), Color(0xFFA5DEF2)], // Blue
    [Color(0xFFFCCF55), Color(0xFFFDDF8E)], // Yellow
    [Color(0xFF658354), Color(0xFFA3C585)], // Green
    [Color(0xFFA17BB9), Color(0xFFC09ADB)], // Purple
  ];
  static Map<dynamic, dynamic> attribuatedSubjectColors = {};
  static int currentColorIndex = 0;
  static Color getSubjectColor(String subjectCode, int colorIndex) {
    if (!attribuatedSubjectColors.containsKey(subjectCode)) {
      attribuatedSubjectColors.addAll({subjectCode: currentColorIndex});

      currentColorIndex += 1;
      if (currentColorIndex == subjectColors.length) {
        currentColorIndex = 0;
      }
    }

    return subjectColors[attribuatedSubjectColors[subjectCode]!][colorIndex];
  }

  // Global scale used in the app //
  static double scale_ = 1.0;
  static double setScale(context) => scale_ = MediaQuery.of(context).size.width / 430.0 * 1.05;

  // All the TextStyles used in the app //
  static TextStyle get pageTitleTextStyle => TextStyle(
    fontSize: 20.0 * scale_,
    fontWeight: FontWeight.bold,
    fontFamily: "Bitter",
    color: getColor("mainText")
  );

  static TextStyle get sectionTitleTextStyle => TextStyle(
    fontSize: 18.0 * scale_,
    fontWeight: FontWeight.w600,
    fontFamily: "Montserrat",
    color: getColor("mainText")
  );

  static TextStyle get itemTitleTextStyle => TextStyle(
    fontSize: 17.0 * scale_,
    fontWeight: FontWeight.w600,
    fontFamily: "Montserrat",
    color: getColor("mainText")
  );

  static TextStyle get itemTextStyle => TextStyle(
    fontSize: 15.0 * scale_,
    fontFamily: "Montserrat",
    color: getColor("subtitleText")
  );

  static TextStyle get numberTextStyle => TextStyle(
    fontSize: 32.0 * scale_,
    fontFamily: "Bitter",
    fontWeight: FontWeight.bold,
    color: getColor("mainText"),
  );
}




