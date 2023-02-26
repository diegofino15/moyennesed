import 'package:moyennesed/core/handlers/file_handler.dart';
import 'package:moyennesed/core/objects/period.dart';

// All the known informations about the student //
class StudentInfos {
  static int id = 0;

  static String firstName = "";
  static String lastName = "";
  static String get fullName => "$firstName $lastName";

  static String level = "";
  static String gender = "";
  
  static String email = "";
  static String phone = "";

  static void saveLoginData(Map loginData) {
    id = loginData["id"];

    firstName = loginData["prenom"];
    lastName = loginData["nom"];

    level = loginData["profile"]["classe"]["libelle"];
    gender = loginData["profile"]["sexe"];
    
    email = loginData["modules"][5]["params"]["mailPerso"];
    phone = loginData["profile"]["telPortable"].replaceAll("-", " ");
  }
}

// All the calculated informations like grades and averages //
class GlobalInfos {
  static final Map<String, Period> periods = <String, Period>{};
  static Period addPeriod(Map jsonInfos) {
    Period period = Period();
    period.init(jsonInfos);
    periods.addAll({period.code: period});
    return period;
  }
}

// The informations modifiable by the user //
class ModifiableInfos {
  static bool useSubjectCoefficients = true;
  static bool guessGradeCoefficient = true;
  
  static Map<String, double> subjectCoefficients = <String, double>{
    "FRANC": 3.0,
    "HI-GE": 3.0,
    "AGL1": 3.0,
    "ESP2": 2.0,
    "ALL2": 2.0,
    "SES": 2.0,
    "MATHS": 3.0,
    "PH-CH": 2.0,
    "SVT": 2.0,
    "SNTEC": 1.0,
    "EPS": 2.0,
  };

  // Function to locally save these informations //
  static Future<void> save() async {
    await FileHandler.instance.changeInfos({
      "guess_grade_coef": guessGradeCoefficient,
      "use_subject_coef": useSubjectCoefficients
    });
  }
}

