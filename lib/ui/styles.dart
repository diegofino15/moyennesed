import 'dart:math';
import 'package:flutter/material.dart';

class Styles {
  // Global scale //
  static void setScale(BuildContext context) { scale = min(1.0, MediaQuery.of(context).size.width / 430.0 * 1.05); }
  static double scale = 1.0;

  // Global TextStyles //
  static TextStyle displayNumberTextStyle = TextStyle(
    fontSize: 35.0 * scale,
    fontWeight: FontWeight.bold,
    fontFamily: "Bitter",
  );
  static TextStyle titleTextStyle = TextStyle(
    fontSize: 22.0 * scale,
    fontWeight: FontWeight.bold,
    fontFamily: "Montserrat",
  );
  static TextStyle title2TextStyle = TextStyle(
    fontSize: 20.0 * scale,
    fontWeight: FontWeight.bold,
    fontFamily: "Montserrat",
  );
  static TextStyle subtitleTextStyle = TextStyle(
    fontSize: 18.0 * scale,
    fontWeight: FontWeight.bold,
    fontFamily: "Montserrat",
  );
  static TextStyle subtitle2TextStyle = TextStyle(
    fontSize: 17.0 * scale,
    fontFamily: "Montserrat",
  );
  static TextStyle subtitle2_54TextStyle = TextStyle(
    fontSize: 17.0 * scale,
    fontFamily: "Montserrat",
    color: Colors.black54,
  );
  static TextStyle subtitle3TextStyle = TextStyle(
    fontSize: 16.0 * scale,
    fontFamily: "Montserrat",
    color: Colors.black54,
  );
  static TextStyle popupTextStyle = TextStyle(
    fontSize: 15.0 * scale,
    fontFamily: "Montserrat",
    color: Colors.black54,
  );
  static TextStyle subjectTitleTextStyle = TextStyle(
    fontSize: 14.0 * Styles.scale,
    fontFamily: "Montserrat",
  );
  static TextStyle gradeOnCardTextStyle = TextStyle(
    fontSize: 12.0 * Styles.scale,
    fontFamily: "Bitter",
    fontWeight: FontWeight.bold,
  );

  // Subject colors //
  static const List<List<Color>> subjectColors = [
    [Color(0xFFff6242), Color(0xFFFFA590)], // Red
    [Color(0xFF5BAEB7), Color(0xFFA5DEF2)], // Blue
    [Color(0xFFFCCF55), Color(0xFFFDDF8E)], // Yellow
    [Color(0xFF658354), Color(0xFFA3C585)], // Green
    [Color(0xFFA17BB9), Color(0xFFC09ADB)], // Purple
    [Color(0xFFC58940), Color(0xFFE5BA73)], // Brown
    [Color.fromARGB(255, 170, 142, 133), Color(0xFFD7C0AE)], // Gray
  ];
  static Map<dynamic, dynamic> attribuatedSubjectColors = {};
  static int currentColorIndex = 0;
  static Color getSubjectColor(String subjectCode) {
    if (!attribuatedSubjectColors.containsKey(subjectCode)) {
      attribuatedSubjectColors.addAll({subjectCode: currentColorIndex});

      currentColorIndex += 1;
      if (currentColorIndex == subjectColors.length) {
        currentColorIndex = 0;
      }
    }

    return subjectColors[attribuatedSubjectColors[subjectCode]!][0];
  }
  static Color getSecondarySubjectColor(String subjectCode) {
    if (!attribuatedSubjectColors.containsKey(subjectCode)) {
      attribuatedSubjectColors.addAll({subjectCode: currentColorIndex});

      currentColorIndex += 1;
      if (currentColorIndex == subjectColors.length) {
        currentColorIndex = 0;
      }
    }

    return subjectColors[attribuatedSubjectColors[subjectCode]!][1];
  }

  // Utils //
  static const List<String> daysNames = [
    "",
    "Lundi",
    "Mardi",
    "Mercredi",
    "Jeudi",
    "Vendredi",
    "Samedi",
    "Dimanche"
  ];
  static const List<String> monthsNames = [
    "",
    "Janvier",
    "Février",
    "Mars",
    "Avril",
    "Mai",
    "Juin",
    "Juillet",
    "Aout",
    "Septembre",
    "Octobre",
    "Novembre",
    "Décembre"
  ];
  static String formatDate(DateTime date) {
    return "${daysNames[date.weekday]} ${date.day} ${monthsNames[date.month]}";
  }
  static String getStrippedString(String string) {
    var withDia = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž-&_.';
    var withoutDia = 'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz    '; 
    for (int i = 0; i < withDia.length; i++) {      
      string = string.replaceAll(withDia[i], withoutDia[i]);
    }
    return string;
  }
}


