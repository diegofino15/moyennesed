import 'package:moyennesed/core/infos.dart';

// This class represents a grade //
class Grade {
  bool isGrade = true;

  late String title;
  late String subjectCode;
  late String subjectName;

  late DateTime date;
  late DateTime dateEntered;

  late String valueStr;
  late String valueOnStr;
  late String classValueStr;
  late bool isEffective;

  double value = 0.0;
  double valueOn = 20.0;
  double classValue = 0.0;

  late double coefficient;

  void init(Map jsonInfos) {
    title = jsonInfos["devoir"] ?? "";
    
    if ((jsonInfos["codeSousMatiere"] ?? "") != "") {
      subjectCode = "${jsonInfos["codeMatiere"] ?? ""}-${jsonInfos["codeSousMatiere"]}";
    } else {
      subjectCode = jsonInfos["codeMatiere"] ?? "";
    }

    subjectName = jsonInfos["libelleMatiere"] ?? "Pas de matière";

    date = DateTime.tryParse(jsonInfos["date"]) ?? DateTime.now();
    dateEntered = DateTime.tryParse(jsonInfos["dateSaisie"]) ?? DateTime.now();

    valueStr = (jsonInfos["valeur"] ?? "").trim();
    valueOnStr = (jsonInfos["noteSur"] ?? "").trim();
    classValueStr = jsonInfos["moyenneClasse"] ?? "";
    isEffective = !(jsonInfos["enLettre"] ?? false) || (jsonInfos["nonSignificatif"] ?? false);

    if (isEffective) {
      double? valueDouble = double.tryParse(valueStr.replaceAll(",", "."));
      double? classValueDouble = double.tryParse(classValueStr.replaceAll(",", "."));
      valueOn = double.tryParse(valueOnStr.replaceAll(",", ".")) ?? 20.0;

      if (valueOn == 0.0) {
        valueStr = "-";
        valueOnStr = "-";
        valueOn = 1.0;
        isEffective = false;
      }

      value = (valueDouble ?? 0.0) / valueOn * 20.0;
      classValue = (classValueDouble ?? 0.0) / valueOn * 20.0;
    }

    coefficient = double.tryParse("${jsonInfos["coef"]}") ?? 0.0;

    if (coefficient == 0.0) {
      coefficient = 1.0;
      if (ModifiableInfos.guessGradeCoefficient) {
        ModifiableInfos.gradeCoefficients.forEach((key, value) {
          if (title.toLowerCase().contains(key)) { coefficient = value; }
        });
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
  String get showableValue => isEffective ? valueOn == 20.0 ? valueStr : "$valueStr/$valueOnStr" : valueStr;
  String get showableClassValue => isEffective ? valueOn == 20.0 ? classValueStr : "$classValueStr/$valueOnStr" : "--";

  // Cache //
  Map<String, dynamic> toJson() {
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
      "value": value,
      "valueOn": valueOn,
      "classValue": classValue,
      "coefficient": coefficient
    };
  }
}



