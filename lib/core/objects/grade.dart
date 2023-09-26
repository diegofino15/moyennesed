import 'package:moyennesed/core/app_data.dart';


class Grade {
  // Identifiers //
  late int id;
  late String title;
  late String periodCode;
  late String subjectTitle;
  late String subjectCode;
  late String subSubjectCode;
  late DateTime date;
  late DateTime dateEntered;

  // Data //
  late bool isEffective;
  late bool isString;
  late String valueStr;
  late String classValueStr;
  late String valueOnStr;
  double value = 0.0;
  double classValue = 0.0;
  double valueOn = 20.0;
  late double coefficient;
  
  // Init from EcoleDirecte //
  void fromED(Map<String, dynamic> jsonInfos) {
    id = jsonInfos["id"] ?? 0;
    title = jsonInfos["devoir"] ?? "";
    periodCode = (jsonInfos["codePeriode"] ?? "A001").substring(0, 4);
    subjectTitle = jsonInfos["libelleMatiere"] ?? "";
    subjectCode = jsonInfos["codeMatiere"] ?? "";
    subSubjectCode = jsonInfos["codeSousMatiere"] ?? "";
    date = DateTime.tryParse(jsonInfos["date"]) ?? DateTime.now();
    dateEntered = DateTime.tryParse(jsonInfos["dateSaisie"]) ?? DateTime.now();

    isString = jsonInfos["enLettre"] ?? false;
    isEffective = !(jsonInfos["nonSignificatif"] ?? false);
    valueStr = (jsonInfos["valeur"] ?? "-").trim();
    classValueStr = jsonInfos["moyenneClasse"] ?? "-";
    valueOnStr = jsonInfos["noteSur"] ?? "20";

    if (!isString) {
      try {
        valueOn = double.tryParse(valueOnStr.replaceAll(",", ".")) ?? 20.0;
        value = double.tryParse(valueStr.replaceAll(",", "."))! / valueOn * 20.0;
        classValue = (double.tryParse(classValueStr.replaceAll(",", ".")) ?? 0.0) / valueOn * 20.0;
      } catch (e) {
        isEffective = false;
      }
    }

    String coefficientStr = "${jsonInfos["coef"]}";
    coefficient = double.tryParse(coefficientStr) ?? 0.0;
    if (coefficient == 0.0 || AppData.instance.guessGradeCoefficients) {
      coefficient = 1.0;
      if (AppData.instance.guessGradeCoefficients) {
        AppData.instance.gradeCoefficients.forEach((key, value) {
          if (title.toLowerCase().split(" ").contains(key)) { coefficient = value; }
        });
      }
    }
  }

  // Init from cache //
  void fromCache(Map<String, dynamic> cacheInfos) {
    id = cacheInfos["id"] ?? 0;
    title = cacheInfos["title"] ?? "";
    periodCode = cacheInfos["periodCode"] ?? "";
    subjectTitle = cacheInfos["subjectTitle"] ?? "";
    subjectCode = cacheInfos["subjectCode"] ?? "";
    subSubjectCode = cacheInfos["subSubjectCode"] ?? "";
    date = DateTime.tryParse(cacheInfos["date"]) ?? DateTime.now();
    dateEntered = DateTime.tryParse(cacheInfos["dateEntered"]) ?? DateTime.now();
    
    isEffective = cacheInfos["isEffective"] ?? true;
    isString = cacheInfos["isString"] ?? false;
    valueStr = cacheInfos["valueStr"] ?? "-";
    classValueStr = cacheInfos["classValueStr"] ?? "-";
    valueOnStr = cacheInfos["valueOnStr"] ?? "-";
    value = cacheInfos["value"] ?? 0.0;
    classValue = cacheInfos["classValue"] ?? 0.0;
    valueOn = cacheInfos["valueOn"] ?? 20.0;
    coefficient = cacheInfos["coefficient"] ?? 1.0;
  }

  // Save into cache format //
  Map<String, dynamic> toCache() {
    return {
      "id": id,
      "title": title,
      "periodCode": periodCode,
      "subjectTitle": subjectTitle,
      "subjectCode": subjectCode,
      "subSubjectCode": subSubjectCode,
      "date": date.toString(),
      "dateEntered": dateEntered.toString(),
      "isEffective": isEffective,
      "isString": isString,
      "valueStr": valueStr,
      "classValueStr": classValueStr,
      "valueOnStr": valueOnStr,
      "value": value,
      "classValue": classValue,
      "valueOn": valueOn,
      "coefficient": coefficient,
    };
  }

  // Helpers //
  String get showValue {
    
    return "";
  }

  String get showableValue => !isString ? valueOn == 20.0 ? valueStr : "$valueStr/$valueOnStr" : valueStr.isNotEmpty ? valueStr : "N/A";
  String get showableClassValue => !isString ? valueOn == 20.0 ? classValueStr : "$classValueStr/$valueOnStr" : classValueStr.isNotEmpty ? classValueStr : "N/A";
}