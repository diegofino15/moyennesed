import 'package:moyennesed/core/objects/grade.dart';
import 'package:moyennesed/core/objects/subject.dart';


class Period {
  // Identifiers //
  late String code;
  late String title;
  late bool isFinished;

  // Data //
  List<Grade> grades = [];
  Map<String, Subject> subjects = {};
  double average = 0.0;
  double classAverage = 0.0;
  bool isEffective = true;

  // Init from EcoleDirecte //
  void fromED(Map<String, dynamic> jsonInfos) {
    code = jsonInfos["codePeriode"] ?? "";
    title = jsonInfos["periode"] ?? "Pas de titre";
    isFinished = jsonInfos["cloture"] ?? false;

    for (var value in ((jsonInfos["ensembleMatieres"] ?? {})["disciplines"] ?? [])) {
      Subject subject = Subject();
      subject.fromED(value);
      if (!subject.isSub) { subjects.addAll({subject.mainCode: subject}); }
      else {
        Subject? mainSubject = subjects[subject.mainCode];
        mainSubject?.addSubSubject(subject);
      }
    }
  }

  // Init from cache //
  void fromCache(Map<String, dynamic> cacheInfos) {
    code = cacheInfos["code"] ?? "";
    title = cacheInfos["title"] ?? "Pas de titre";
    isFinished = cacheInfos["isFinished"] ?? false;

    for (var value in (cacheInfos["grades"] ?? [])) {
      Grade grade = Grade();
      grade.fromCache(value);
      grades.add(grade);
    }

    (cacheInfos["subjects"] ?? {}).forEach((key, value) {
      Subject subject = Subject();
      subject.fromCache(value);
      subjects.addAll({key: subject});
    });

    average = cacheInfos["average"] ?? 0.0;
    classAverage = cacheInfos["classAverage"] ?? 0.0;
    isEffective = cacheInfos["isEffective"] ?? true;
  }

  // Save into cache format //
  Map<String, dynamic> toCache() {
    List<Map<String, dynamic>> cacheGrades = [];
    for (var value in grades) { cacheGrades.add(value.toCache()); }

    Map<String, dynamic> cacheSubjects = {};
    subjects.forEach((key, value) => { cacheSubjects.addAll({key: value.toCache()}) });
    
    return {
      "code": code,
      "title": title,
      "isFinished": isFinished,
      "grades": cacheGrades,
      "subjects": cacheSubjects,
      "average": average,
      "classAverage": classAverage,
      "isEffective": isEffective,
    };
  }

  // Functions //
  void addGrade(Grade grade) {
    Subject? gradeMainSubject = subjects[grade.subjectCode];
    if (gradeMainSubject != null) {
      late Subject? gradeSubject;
      if (grade.subSubjectCode.isNotEmpty) {
        gradeSubject = gradeMainSubject.subSubjects[grade.subSubjectCode];
      } else { gradeSubject = gradeMainSubject; }

      if (gradeSubject != null) {
        gradeSubject.addGrade(grade);
      }
    }
    grades.add(grade);
  }

  void calculateAverage() {
    double sum = 0.0;
    double sumClass = 0.0;
    double coef = 0.0;

    for (Subject subject in subjects.values) {
      subject.calculateAverage();
      if (subject.isEffective) {
        sum += subject.average * subject.coefficient;
        sumClass += subject.classAverage * subject.coefficient;
        coef += subject.coefficient;
      }
    }

    average = coef != 0 ? sum / coef : 0.0;
    average = (average * 100.0).round() / 100.0;
    classAverage = coef != 0 ? sumClass / coef : 0.0;
    classAverage = (classAverage * 100.0).round() / 100.0;
    if (coef == 0.0) { isEffective = false; }
  }

  // Helpers //
  String get showableAverage => isEffective ? average.toString().replaceAll(".", ",") : "--";
  String get showableClassAverage => isEffective ? classAverage.toString().replaceAll(".", ",") : "--";
}



