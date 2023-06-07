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

  // Load cache //
  Future<void> loadCache() async {
    Map<String, dynamic> cache = await CacheHandler.getAllCache();
    if (cache.isNotEmpty) {
      print("Found cache !");
      connectedAccount.fromCache(cache);
      accounts.clear();
      displayedAccountID = "${connectedAccount.id}";
      accounts.addAll({displayedAccountID: connectedAccount});
      for (Account childAccount in connectedAccount.childrenAccounts) {
        displayedAccountID = "${childAccount.id}";
        accounts.addAll({displayedAccountID: childAccount});
      }
    }
  }

  // Auto-connect //
  Future<void> autoConnect() async {
    Map cacheConnectionInfos = await FileHandler.instance.readInfos();
    if ((cacheConnectionInfos["isUserLoggedIn"] ?? false) || debugMode) {
      connectedAccount.loginUsername = cacheConnectionInfos["username"] ?? "";
      connectedAccount.loginPassword = cacheConnectionInfos["password"] ?? "";
      connectedAccount.wasLoggedIn = true;
      connectedAccount.login();
    } else {
      disconnect();
    }
  }

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
  bool guessGradeCoefficients = false;
  bool schoolGivesGradeCoefficients = false;
  final Map<String, double> gradeCoefficients = {
    "dm": 0.5,
    "ie": 1.0,
    "ds": 2.0, "dst": 2.0,
    "oraux": 3.0,
    "brevet": 3.0,
  };
  
  bool guessSubjectCoefficients = false;
  bool schoolGivesSubjectCoefficients = false;
  final Map<String, double> subjectCoefficients = <String, double>{
    "FRANCAIS": 3.0, "FRANC": 3.0,
    "HISTOIRE": 3.0, "HIS": 3.0, "GEOGRAPHIE": 3.0, "GEO": 3.0,
    "ANGLAIS": 3.0, "ANG": 3.0, "LV1": 3.0, "LVA": 3.0, "LV+": 3.0,
    "ESPAGNOL": 2.0, "ESP": 2.0, "LV2": 2.0, "LVB": 2.0,
    "ALLEMAND": 2.0, "ALL": 2.0,
    "SES": 2.0, "ECO": 2.0, "ECONOMIQUE": 2.0,"ECONOMIQUES": 2.0, "SOCIALE": 2.0, "SOCIALES": 2.0,
    "MATHEMATIQUES": 3.0, "MATHS": 3.0,
    "PHYSIQUE": 2.0, "CHIMIE": 2.0,
    "SVT": 2.0, "VIE": 2.0, "TERRE": 2.0,
    "EPS": 2.0, "SPORT": 2.0, "SPORTIVE": 2.0,
  };

  // Debug data //
  Map connectionLog = {};
  Map gradesLog = {};

  // Debug mode //
  bool debugMode = false;
  Map debugConnectionLog = {};
  Map debugGradesLog = {};
}

class DemoAccount {
  static List<String> subjectCodes = [
    "FRANC", "HI-GE", "MATHS", "AGL1", "ESP2", "SES", "PH-CH", "SVT", "EPS", "SNTEC", "LCALA"
  ];

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
    int gradeNumber = 150;

    List<dynamic> demoAccountGrades = [];
    for (int i = 0; i < gradeNumber; i++) {
      String devoir = "Demo grade n°$i";
      String codePeriode = "A00${Random().nextInt(3) + 1}";
      String codeMatiere = subjectCodes.elementAt(Random().nextInt(subjectCodes.length));
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
      "notes": generateRandomGrades(),
      "parametrage": {
        "coefficientNote": false,
        "moyenneCoefMatiere": false,
      }
    }
  };
}




