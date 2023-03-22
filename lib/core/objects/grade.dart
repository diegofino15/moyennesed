import 'package:moyennesed/core/infos.dart';

// This class represents a grade //
class Grade {
  late String title;
  late String subjectCode;
  late String subjectName;

  late DateTime date;
  late DateTime dateEntered;

  late String valueStr;
  late String valueOnStr;
  late String classValueStr;
  late bool isEffective;

  double? value;
  double? valueOn;
  double? classValue;

  late double coefficient;

  void init(Map jsonInfos) {
    title = jsonInfos["devoir"];
    subjectCode = jsonInfos["codeMatiere"];
    subjectName = jsonInfos["libelleMatiere"];

    date = DateTime.parse(jsonInfos["date"]);
    dateEntered = DateTime.parse(jsonInfos["dateSaisie"]);

    valueStr = jsonInfos["valeur"].trim();
    valueOnStr = jsonInfos["noteSur"].trim();
    classValueStr = jsonInfos["moyenneClasse"] ?? "";
    isEffective = !jsonInfos["enLettre"] || jsonInfos["nonSignificatif"];

    if (isEffective) {
      double? valueDouble = double.tryParse(valueStr.replaceAll(",", "."));
      double? classValueDouble = double.tryParse(classValueStr.replaceAll(",", "."));
      valueOn = double.tryParse(valueOnStr.replaceAll(",", "."));

      value = (valueDouble ?? 0.0) / (valueOn ?? 1.0) * 20.0;
      classValue = (classValueDouble ?? 0.0) / (valueOn ?? 1.0) * 20.0;
    }

    coefficient = jsonInfos["coef"].toDouble();
    if (coefficient == 0.0) {
      if (ModifiableInfos.guessGradeCoefficient) {
        coefficient = 1.0;
        ModifiableInfos.gradeCoefficients.forEach((key, value) {
          if (title.toLowerCase().contains(key)) { coefficient = value; }
        });
      } else {
        coefficient = 1.0;
      }
    }
  }

  void fromCache(Map jsonInfos) {
    title = jsonInfos["title"];
    subjectCode = jsonInfos["subjectCode"];
    subjectName = jsonInfos["subjectName"];
    date = DateTime.parse(jsonInfos["date"]);
    dateEntered = DateTime.parse(jsonInfos["dateEntered"]);
    valueStr = jsonInfos["valueStr"];
    valueOnStr = jsonInfos["valueOnStr"];
    classValueStr = jsonInfos["classValueStr"];
    isEffective = jsonInfos["isEffective"];
    value = jsonInfos["value"];
    valueOn = jsonInfos["valueOn"];
    classValue = jsonInfos["classValue"];
    coefficient = jsonInfos["coefficient"];
  }

  // UI //
  String get showableValue => isEffective ? (valueOn ?? 20.0) == 20.0 ? valueStr : "$valueStr/$valueOnStr" : valueStr;
  String get showableClassValue => isEffective ? (valueOn ?? 20.0) == 20.0 ? classValueStr : "$classValueStr/$valueOnStr" : "--";

  // Cache //
  Map toJson() {
    return {
      "title": title,
      "subjectCode": subjectCode,
      "subjectName": subjectName,
      "date": date.toString(),
      "dateEntered": dateEntered.toString(),
      "valueStr": valueStr,
      "valueOnStr": valueOnStr,
      "classValueStr": classValueStr,
      "isEffective": isEffective,
      "value": value ?? 0.0,
      "valueOn": valueOn ?? 20.0,
      "classValue": classValue ?? 0.0,
      "coefficient": coefficient
    };
  }
}



