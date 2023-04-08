import 'package:moyennesed/core/infos.dart';
import 'package:moyennesed/core/objects/grade.dart';

// This class represents a subject that the student has //
class Subject {
  late String code;
  late String name;
  late String professorName;

  List<Grade> grades = <Grade>[];

  double average = 0.0;
  double classAverage = 0.0;
  bool hasCalculatedAverage_ = false;
  
  double coefficient = 1.0;

  void init(Map jsonInfos) {
    code = jsonInfos["codeMatiere"] ?? "";
    name = (jsonInfos["discipline"] ?? "Pas de matière").trim();

    if ((jsonInfos["professeurs"] ?? []).isNotEmpty) {
      professorName = ((jsonInfos["professeurs"][0] ?? [])["nom"] ?? "Pas de professeur").trim();
    } else {
      professorName = "Pas de professeur";
    }

    coefficient = (jsonInfos["coef"] ?? "0").toDouble();
    if (coefficient == 0.0) {
      if (ModifiableInfos.useSubjectCoefficients) {
        coefficient = ModifiableInfos.subjectCoefficients[code] ?? 1.0;
      } else {
        coefficient = 1.0;
      }
    }
  }

  void fromCache(Map jsonInfos) {
    code = jsonInfos["code"];
    name = jsonInfos["name"];
    professorName = jsonInfos["professorName"];
    average = jsonInfos["average"];
    classAverage = jsonInfos["classAverage"];
    hasCalculatedAverage_ = jsonInfos["hasCalculatedAverage"];
    for (Map gradeObj in jsonInfos["grades"]) {
      Grade grade = Grade();
      grade.fromCache(gradeObj);
      grades.add(grade);
    }
    coefficient = jsonInfos["coefficient"];
  }

  void addGrade(Grade grade) {
    grades.add(grade);
  }

  double getAverage() {
    if (hasCalculatedAverage_) { return average; }

    double sum = 0.0;
    double sumClass = 0.0;
    double coef = 0.0;
    for (Grade grade in grades) {
      if (grade.isEffective) {
        sum += (grade.value ?? 0.0) * grade.coefficient;
        sumClass += (grade.classValue ?? 0.0) * grade.coefficient;
        coef += grade.coefficient;
      }
    }

    average = coef != 0.0 ? sum / coef : 0.0;
    classAverage = coef != 0.0 ? sumClass / coef : 0.0;

    hasCalculatedAverage_ = true;
    return average;
  }

  double getClassAverage() {
    if (hasCalculatedAverage_) { return classAverage; }

    getAverage();
    return classAverage;
  }

  // Cache //
  Map toJson() {
    List jsonGrades = [];
    for (Grade grade in grades) {
      jsonGrades.add(grade.toJson());
    }
    
    return {
      "code": code,
      "name": name,
      "professorName": professorName,
      "average": average,
      "classAverage": classAverage,
      "hasCalculatedAverage": hasCalculatedAverage_,
      "coefficient": coefficient,
      "grades": jsonGrades
    };
  }
}