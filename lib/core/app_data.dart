import 'dart:math';

import 'package:flutter/material.dart';
import 'package:moyennesed/core/file_handler.dart';
import 'package:moyennesed/core/cache_handler.dart';
import 'package:moyennesed/core/objects/account.dart';


// This class contains all the saved data on the app //
class AppData with ChangeNotifier {
  AppData._privateConstructor();
  static final AppData instance = AppData._privateConstructor();

  // To update the UI //
  bool updateUI_ = true;
  bool get updateUI => updateUI_;
  set updateUI(bool value) {
    updateUI_ = value;
    notifyListeners();
  }
  
  // Connected account //
  final Account connectedAccount = Account();

  // Displayed account //
  void init() {
    accounts = {
      "${connectedAccount.id}": connectedAccount,
    };
    displayedAccountID_ = "${connectedAccount.id}";
  }
  late Map<String, Account> accounts;

  late String displayedAccountID_;
  String get displayedAccountID => displayedAccountID_;
  set displayedAccountID(String value) {
    displayedAccountID_ = value;
    notifyListeners();
  }
  Account get displayedAccount => accounts[displayedAccountID]!;

  // Disconnect //
  void disconnect() {
    accounts.clear();
    connectedAccount.disconnect();
    connectedAccount.isConnectedAccount = true;
    accounts.addAll({"${connectedAccount.id}": connectedAccount});
    displayedAccountID = "${connectedAccount.id}";
    FileHandler.instance.writeInfos({});
    CacheHandler.saveAllCache({});
    print("Disconnected !");
  }

  // Modifiable data //
  bool guessGradeCoefficients = true;
  final Map<String, double> gradeCoefficients = {
    "dm": 0.5,
    "ds": 2.0,
    "dst": 2.0,
    "oraux": 3.0,
  };
  bool guessSubjectCoefficients = true;
  final Map<String, double> subjectCoefficients = <String, double>{
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

  // Debug data //
  Map connectionLog = {};
  Map gradesLog = {};
}

class DemoAccount {
  static const Map<String, dynamic> demoAccountInfos = {
    "token": "",
    "data": {
      "accounts": [
        {
          "type": "E",
          "id": 0,
          "prenom": "DEMO",
          "nom": "ACCOUNT",
          "profile": {
            "classe": {
              "code": "DEMO",
              "libelle": "Demo level"
            },
            "sexe": "M",
          },
        }
      ]
    }
  };
  
  static List<dynamic> generateRandomGrades() {
    int gradeNumber = 80;

    List<dynamic> demoAccountGrades = [];
    for (int i = 0; i < gradeNumber; i++) {
      String devoir = "Demo grade n°$i";
      String codePeriode = "A00${Random().nextInt(3) + 1}";
      String codeMatiere = AppData.instance.subjectCoefficients.keys.elementAt(Random().nextInt(AppData.instance.subjectCoefficients.length));
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
    "data": {
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
    }
  };
}



