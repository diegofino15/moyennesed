import 'package:moyennesed/core/objects/grade.dart';
import 'package:moyennesed/core/objects/subject.dart';

// This class represents a period of the year //
class Period {
  late int index;
  late String code;
  late bool isFinished;

  late String name;

  final List<Grade> grades = <Grade>[];
  final Map<String, Subject> subjects = <String, Subject>{};

  double generalAverage = 0.0;
  double generalClassAverage = 0.0;
  bool hasCalculatedGeneralAverage_ = false;

  void init(Map jsonInfos) {
    code = jsonInfos["codePeriode"] ?? "A001";
    index = int.tryParse(code.substring(3, 4)) ?? 1;
    isFinished = jsonInfos["cloture"] ?? false;

    name = jsonInfos["periode"] ?? "1er trimestre";

    for (Map subjectMap in ((jsonInfos["ensembleMatieres"] ?? [])["disciplines"] ?? [])) {
      addSubject(subjectMap);
    }
  }

  void fromCache(Map jsonInfos) {
    index = jsonInfos["index"];
    code = jsonInfos["code"];
    isFinished = jsonInfos["isFinished"];
    name = jsonInfos["name"];
    for (Map gradeObj in jsonInfos["grades"]) {
      Grade grade = Grade();
      grade.fromCache(gradeObj);
      grades.add(grade);
    }
    for (Map subjectObj in jsonInfos["subjects"].values) {
      Subject subject = Subject();
      subject.fromCache(subjectObj);
      subjects.addAll({subject.code: subject});
    }
    generalAverage = jsonInfos["generalAverage"];
    generalClassAverage = jsonInfos["generalClassAverage"];
    hasCalculatedGeneralAverage_ = jsonInfos["hasCalculatedGeneralAverage"];
  }

  Subject addSubject(Map jsonInfos) {
    Subject subject = Subject();
    subject.init(jsonInfos);
    if (subject.isSubSubject) {
      subjects.addAll({"${subject.code}-${subject.subCode}": subject});
    } else {
      subjects.addAll({subject.code: subject});
    }
    return subject;
  }

  Grade addGrade(Map jsonInfos) {
    Grade grade = Grade();
    grade.init(jsonInfos);
    if (!grade.isGrade) { return grade; }
    
    grades.add(grade);

    Subject? gradeSubject = subjects[grade.subjectCode];
    gradeSubject ??= addSubject({
      "codeMatiere": grade.subjectCode,
      "discipline": jsonInfos["libelleMatiere"] ?? "Nom non trouvé",
      "professeurs": [],
      "coef": 0.0,
    });
    gradeSubject.addGrade(grade);
    return grade;
  }

  double getAverage() {
    if (hasCalculatedGeneralAverage_) { return generalAverage; }

    double sum = 0.0;
    double sumClass = 0.0;
    double coef = 0.0;
    for (Subject subject in subjects.values) {
      if (subject.getAverage() != 0.0) {
        sum += subject.average * subject.coefficient;
        sumClass += subject.classAverage * subject.coefficient;
        coef += subject.coefficient;
      }
    }

    generalAverage = coef != 0 ? sum / coef : 0.0;
    generalClassAverage = coef != 0 ? sumClass / coef : 0.0;

    hasCalculatedGeneralAverage_ = true;
    return generalAverage;
  }

  double getClassAverage() {
    if (hasCalculatedGeneralAverage_) { return generalClassAverage; }

    getAverage();

    return generalClassAverage;
  }

  void sortGrades() { grades.sort((a, b) => a.dateEntered.compareTo(b.dateEntered)); }

  // Cache //
  Map toJson() {
    Map jsonSubjects = {};
    for (Subject subject in subjects.values) {
      jsonSubjects.addAll({subject.code: subject.toJson()});
    }

    List jsonGrades = [];
    for (Grade grade in grades) {
      jsonGrades.add(grade.toJson());
    }

    return {
      "index": index,
      "code": code,
      "isFinished": isFinished,
      "name": name,
      "grades": jsonGrades,
      "subjects": jsonSubjects,
      "generalAverage": generalAverage,
      "generalClassAverage": generalClassAverage,
      "hasCalculatedGeneralAverage": hasCalculatedGeneralAverage_
    };
  }
}