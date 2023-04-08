import 'dart:math';

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

  static void saveLoginData(Map loginData) {
    id = loginData["id"];

    firstName = loginData["prenom"] ?? "";
    lastName = loginData["nom"] ?? "";

    dynamic profile = loginData["profile"] ?? [];
    dynamic classLevel = profile["classe"] ?? [];

    level = classLevel["libelle"] ?? "";
    gender = profile["sexe"] ?? "M";
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

  static bool guessGradeCoefficient = true;
  static const Map<String, double> gradeCoefficients = {
    "ds": 2.0,
    "dst": 2.0,
    "dm": 0.5,
  };

  // Function to locally save these informations //
  static Future<void> save() async {
    await FileHandler.instance.changeInfos({
      "guessGradeCoef": guessGradeCoefficient,
      "useSubjectCoef": useSubjectCoefficients
    });
  }
}

// DEMO ACCOUNT
class DemoAccount {
  static const Map<String, dynamic> demoAccountInfos = {
    "username": "demo",
    "password": "1234",

    "id": 0,
    "prenom": "DEMO",
    "nom": "ACCOUNT",
    "profile": {
      "classe": {
        "libelle": "Demo level"
      },
      "sexe": "M",
      "telPortable": "00-00-00-00-00"
    },
    "modules": {
      5: {
        "params": {
          "mailPerso": "demoaccount@laroche.org"
        }
      }
    }
  };
  
  static List<dynamic> generateRandomGrades() {
    int gradeNumber = 80;

    List<dynamic> demoAccountGrades = [];
    for (int i = 0; i < gradeNumber; i++) {
      String devoir = "Demo grade n°$i";
      String codePeriode = "A00${Random().nextInt(3) + 1}";
      String codeMatiere = ModifiableInfos.subjectCoefficients.keys.elementAt(Random().nextInt(ModifiableInfos.subjectCoefficients.length));
      String noteSur = Random().nextInt(2) == 0 ? "20" : "10";
      String valeur = ((8.0 + Random().nextInt(13)) / 20.0 * double.parse(noteSur)).toString();
      DateTime date = DateTime.now();
      DateTime dateSaisie = DateTime.now();
      String moyenneClasse = ((8.0 + Random().nextInt(13)) / 20.0 * double.parse(noteSur)).toString();

      demoAccountGrades.add({
        "devoir": devoir,
        "codePeriode": codePeriode,
        "codeMatiere": codeMatiere,
        "libelleMatiere": "",
        "enLettre": false,
        "coef": 0,
        "noteSur": noteSur,
        "valeur": valeur.replaceAll(".", ","),
        "nonSignificatif": false,
        "date": date.toString(),
        "dateSaisie": dateSaisie.toString(),
        "moyenneClasse": moyenneClasse.replaceAll(".", ",")
      });
    }

    return demoAccountGrades;
  }
  static Map<String, dynamic> get demoAccountGrades => {
    "periodes": [
      {
        "codePeriode": "A001",
        "periode": "1er Trimestre",
        "cloture": true,
        "ensembleMatieres": {
          "nomPP": "Un professeur quelconque",
          "disciplines": [
              {
                  "codeMatiere": "FRANC",
                  "discipline": "FRANCAIS",
                  "coef": 0,
                  "professeurs": [
                      {
                          "id": 0,
                          "nom": "Un professeur quelconque"
                      },
                  ]
              },
              {
                  "codeMatiere": "HI-GE",
                  "discipline": "HISTOIRE-GEOGRAPHIE",
                  "coef": 0,
                  "professeurs": [
                      {
                          "id": 1,
                          "nom": "Un professeur quelconque"
                      }
                  ]
              },
              {
                  "codeMatiere": "AGL1",
                  "discipline": "ANGLAIS LV1",
                  "coef": 0,
                  "professeurs": [
                      {
                          "id": 214,
                          "nom": "Un professeur quelconque"
                      }
                  ]
              },
              {
                  "codeMatiere": "ESP2",
                  "discipline": "ESPAGNOL LV2",
                  "coef": 0,
                  "professeurs": [
                      {
                          "id": 318,
                          "nom": "Un professeur quelconque"
                      }
                  ]
              },
              {
                  "codeMatiere": "SES",
                  "discipline": "SC. ECONO.& SOCIALES",
                  "coef": 0,
                  "professeurs": [
                      {
                          "id": 320,
                          "nom": "Un professeur quelconque"
                      }
                  ]
              },
              {
                  "codeMatiere": "MATHS",
                  "discipline": "MATHEMATIQUES",
                  "coef": 0,
                  "professeurs": [
                      {
                          "id": 59,
                          "nom": "Un professeur quelconque"
                      }
                  ]
              },
              {
                  "codeMatiere": "PH-CH",
                  "discipline": "PHYSIQUE-CHIMIE",
                  "coef": 0,
                  "professeurs": [
                      {
                          "id": 86,
                          "nom": "Un professeur quelconque"
                      }
                  ]
              },
              {
                  "codeMatiere": "SVT",
                  "discipline": "SCIENCES VIE & TERRE",
                  "coef": 0,
                  "professeurs": [
                      {
                          "id": 60,
                          "nom": "Un professeur quelconque"
                      }
                  ]
              },
              {
                  "codeMatiere": "SNTEC",
                  "discipline": "SC.NUMERIQ.TECHNOL.",
                  "coef": 0,
                  "professeurs": [
                      {
                          "id": 59,
                          "nom": "Un professeur quelconque"
                      }
                  ]
              },
              {
                  "codeMatiere": "EPS",
                  "discipline": "ED.PHYSIQUE & SPORT.",
                  "coef": 0,
                  "professeurs": [
                      {
                          "id": 97,
                          "nom": "Un professeur quelconque"
                      }
                  ]
              },
              {
                  "codeMatiere": "LCALA",
                  "discipline": "LCA LATIN",
                  "coef": 0,
                  "professeurs": [
                      {
                          "id": 25,
                          "nom": "Un professeur quelconque"
                      }
                  ]
              }
          ]
        }
      },
      {
        "codePeriode": "A002",
        "periode": "2e Trimestre",
        "cloture": false,
        "ensembleMatieres": {
          "nomPP": "Un professeur quelconque",
          "disciplines": [
              {
                  "codeMatiere": "FRANC",
                  "discipline": "FRANCAIS",
                  "coef": 0,
                  "professeurs": [
                      {
                          "id": 0,
                          "nom": "Un professeur quelconque"
                      },
                  ]
              },
              {
                  "codeMatiere": "HI-GE",
                  "discipline": "HISTOIRE-GEOGRAPHIE",
                  "coef": 0,
                  "professeurs": [
                      {
                          "id": 1,
                          "nom": "Un professeur quelconque"
                      }
                  ]
              },
              {
                  "codeMatiere": "AGL1",
                  "discipline": "ANGLAIS LV1",
                  "coef": 0,
                  "professeurs": [
                      {
                          "id": 214,
                          "nom": "Un professeur quelconque"
                      }
                  ]
              },
              {
                  "codeMatiere": "ESP2",
                  "discipline": "ESPAGNOL LV2",
                  "coef": 0,
                  "professeurs": [
                      {
                          "id": 318,
                          "nom": "Un professeur quelconque"
                      }
                  ]
              },
              {
                  "codeMatiere": "SES",
                  "discipline": "SC. ECONO.& SOCIALES",
                  "coef": 0,
                  "professeurs": [
                      {
                          "id": 320,
                          "nom": "Un professeur quelconque"
                      }
                  ]
              },
              {
                  "codeMatiere": "MATHS",
                  "discipline": "MATHEMATIQUES",
                  "coef": 0,
                  "professeurs": [
                      {
                          "id": 59,
                          "nom": "Un professeur quelconque"
                      }
                  ]
              },
              {
                  "codeMatiere": "PH-CH",
                  "discipline": "PHYSIQUE-CHIMIE",
                  "coef": 0,
                  "professeurs": [
                      {
                          "id": 86,
                          "nom": "Un professeur quelconque"
                      }
                  ]
              },
              {
                  "codeMatiere": "SVT",
                  "discipline": "SCIENCES VIE & TERRE",
                  "coef": 0,
                  "professeurs": [
                      {
                          "id": 60,
                          "nom": "Un professeur quelconque"
                      }
                  ]
              },
              {
                  "codeMatiere": "SNTEC",
                  "discipline": "SC.NUMERIQ.TECHNOL.",
                  "coef": 0,
                  "professeurs": [
                      {
                          "id": 59,
                          "nom": "Un professeur quelconque"
                      }
                  ]
              },
              {
                  "codeMatiere": "EPS",
                  "discipline": "ED.PHYSIQUE & SPORT.",
                  "coef": 0,
                  "professeurs": [
                      {
                          "id": 97,
                          "nom": "Un professeur quelconque"
                      }
                  ]
              },
              {
                  "codeMatiere": "LCALA",
                  "discipline": "LCA LATIN",
                  "coef": 0,
                  "professeurs": [
                      {
                          "id": 25,
                          "nom": "Un professeur quelconque"
                      }
                  ]
              }
          ]
        }
      },
      {
        "codePeriode": "A003",
        "periode": "3e Trimestre",
        "cloture": false,
        "ensembleMatieres": {
          "nomPP": "Un professeur quelconque",
          "disciplines": [
              {
                  "codeMatiere": "FRANC",
                  "discipline": "FRANCAIS",
                  "coef": 0,
                  "professeurs": [
                      {
                          "id": 0,
                          "nom": "Un professeur quelconque"
                      },
                  ]
              },
              {
                  "codeMatiere": "HI-GE",
                  "discipline": "HISTOIRE-GEOGRAPHIE",
                  "coef": 0,
                  "professeurs": [
                      {
                          "id": 1,
                          "nom": "Un professeur quelconque"
                      }
                  ]
              },
              {
                  "codeMatiere": "AGL1",
                  "discipline": "ANGLAIS LV1",
                  "coef": 0,
                  "professeurs": [
                      {
                          "id": 214,
                          "nom": "Un professeur quelconque"
                      }
                  ]
              },
              {
                  "codeMatiere": "ESP2",
                  "discipline": "ESPAGNOL LV2",
                  "coef": 0,
                  "professeurs": [
                      {
                          "id": 318,
                          "nom": "Un professeur quelconque"
                      }
                  ]
              },
              {
                  "codeMatiere": "SES",
                  "discipline": "SC. ECONO.& SOCIALES",
                  "coef": 0,
                  "professeurs": [
                      {
                          "id": 320,
                          "nom": "Un professeur quelconque"
                      }
                  ]
              },
              {
                  "codeMatiere": "MATHS",
                  "discipline": "MATHEMATIQUES",
                  "coef": 0,
                  "professeurs": [
                      {
                          "id": 59,
                          "nom": "Un professeur quelconque"
                      }
                  ]
              },
              {
                  "codeMatiere": "PH-CH",
                  "discipline": "PHYSIQUE-CHIMIE",
                  "coef": 0,
                  "professeurs": [
                      {
                          "id": 86,
                          "nom": "Un professeur quelconque"
                      }
                  ]
              },
              {
                  "codeMatiere": "SVT",
                  "discipline": "SCIENCES VIE & TERRE",
                  "coef": 0,
                  "professeurs": [
                      {
                          "id": 60,
                          "nom": "Un professeur quelconque"
                      }
                  ]
              },
              {
                  "codeMatiere": "SNTEC",
                  "discipline": "SC.NUMERIQ.TECHNOL.",
                  "coef": 0,
                  "professeurs": [
                      {
                          "id": 59,
                          "nom": "Un professeur quelconque"
                      }
                  ]
              },
              {
                  "codeMatiere": "EPS",
                  "discipline": "ED.PHYSIQUE & SPORT.",
                  "coef": 0,
                  "professeurs": [
                      {
                          "id": 97,
                          "nom": "Un professeur quelconque"
                      }
                  ]
              },
              {
                  "codeMatiere": "LCALA",
                  "discipline": "LCA LATIN",
                  "coef": 0,
                  "professeurs": [
                      {
                          "id": 25,
                          "nom": "Un professeur quelconque"
                      }
                  ]
              }
          ]
        }
      },
    ],
    "notes": generateRandomGrades()  
  };
}
