import 'package:moyennesed/core/app_data.dart';
import 'package:moyennesed/core/objects/grade.dart';


class Subject {
  // Identifiers //
  late int id;
  late String title;
  late String mainCode;
  late String subCode;
  late bool isSub;
  
  // Data //
  List teachers = [];
  List<Grade> grades = [];
  double average = 0.0;
  double classAverage = 0.0;
  double coefficient = 1.0;
  bool isEffective = true;
  
  // Special //
  Map<String, Subject> subSubjects = {};

  // Init from EcoleDirecte //
  void fromED(Map<String, dynamic> jsonInfos) {
    id = jsonInfos["id"] ?? 0;
    title = jsonInfos["discipline"] ?? "Pas de nom";
    mainCode = jsonInfos["codeMatiere"] ?? "";
    subCode = jsonInfos["codeSousMatiere"] ?? "";
    isSub = jsonInfos["sousMatiere"] ?? false;

    for (var value in (jsonInfos["professeurs"] ?? [])) { teachers.add(value["nom"] ?? "Pas de professeur"); }
    coefficient = (jsonInfos["coef"] ?? 0).toDouble();
    if (coefficient == 0.0) {
      coefficient = 1.0;
      if (AppData.instance.guessSubjectCoefficients) {
        coefficient = AppData.instance.subjectCoefficients[mainCode] ?? 1.0;
      }
    }
  }

  // Init from cache //
  void fromCache(Map<String, dynamic> cacheInfos) {
    id = cacheInfos["id"] ?? 0;
    title = cacheInfos["title"] ?? "Pas de nom";
    mainCode = cacheInfos["mainCode"] ?? "";
    subCode = cacheInfos["subCode"] ?? "";
    isSub = cacheInfos["isSub"] ?? false;

    teachers = cacheInfos["teachers"] ?? [];
    for (var value in (cacheInfos["grades"] ?? [])) {
      Grade grade = Grade();
      grade.fromCache(value);
      grades.add(grade);
    }
    average = cacheInfos["average"] ?? 0.0;
    classAverage = cacheInfos["classAverage"] ?? 0.0;
    coefficient = cacheInfos["coefficient"] ?? 1.0;

    (cacheInfos["subSubjects"] ?? []).forEach((key, value) {
      Subject subject = Subject();
      subject.fromCache(value);
      subSubjects.addAll({key: subject});
    });
  }

  // Save into cache format //
  Map<String, dynamic> toCache() {
    Map<String, dynamic> cacheSubSubjects = {};
    subSubjects.forEach((key, value) => { cacheSubSubjects.addAll({key: value.toCache()}) });

    List<Map<String, dynamic>> cacheGrades = [];
    for (var value in grades) { cacheGrades.add(value.toCache()); }
    
    return {
      "id": id,
      "title": title,
      "mainCode": mainCode,
      "subCode": subCode,
      "isSub": isSub,
      "teachers": teachers,
      "grades": cacheGrades,
      "average": average,
      "classAverage": classAverage,
      "coefficient": coefficient,
      "subSubjects": cacheSubSubjects,
    };
  }

  // Functions //
  void addSubSubject(Subject subSubject) { subSubjects.addAll({subSubject.subCode: subSubject}); }
  void addGrade(Grade grade) { grades.add(grade); }

  void calculateAverage() {
    double sum = 0.0;
    double sumClass = 0.0;
    double coef = 0.0;

    for (Grade grade in grades) {
      if (grade.isEffective) {
        sum += grade.value * grade.coefficient;
        sumClass += grade.classValue * grade.coefficient;
        coef += grade.coefficient;
      }
    }

    for (Subject subject in subSubjects.values) {
      subject.calculateAverage();
      if (subject.isEffective) {
        sum += subject.average * subject.coefficient;
        sumClass += subject.classAverage * subject.coefficient;
        coef += subject.coefficient;
      }
    }
    average = coef != 0 ? sum / coef : 0.0;
    classAverage = coef != 0 ? sumClass / coef : 0.0;
    if (coef == 0.0) { isEffective = false; }
  }

  // Helpers //
  String get showableAverage => isEffective ? ((average * 100).round() / 100.0).toString().replaceAll(".", ",") : "--";
  String get showableClassAverage => isEffective ? ((classAverage * 100).round() / 100.0).toString().replaceAll(".", ",") : "--";
}

