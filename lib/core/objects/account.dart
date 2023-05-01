import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moyennesed/core/app_data.dart';
import 'package:moyennesed/core/file_handler.dart';
import 'package:moyennesed/core/cache_handler.dart';
import 'package:moyennesed/core/objects/grade.dart';
import 'package:moyennesed/core/objects/period.dart';


class Account with ChangeNotifier {
  // Data for all accounts //
  String type = "E"; // Student or parent (or teacher)
  bool isConnectedAccount = true;
  String firstName = "";
  String lastName = "";
  String get fullName => "$firstName $lastName";
  int id = -1;
  String gender = "M";

  // Data only for connected account //
  bool isLoggedIn = false;
  String token = "";
  String loginUsername = "";
  String loginPassword = "";
  final List<Account> childrenAccounts = <Account>[];
  final Map<String, Period> periods = {};
  bool isFromCache = false;
  late String selectedPeriod_;
  String get selectedPeriod => selectedPeriod_;
  set selectedPeriod(String value) {
    selectedPeriod_ = value;
    notifyListeners();
  }
  
  // Data only for student account //
  String levelCode = "";
  String levelName = "";

  // All provider values //
  bool isConnecting_ = false;
  bool get isConnecting => isConnecting_;
  set isConnecting(bool value) {
    isConnecting_ = value;
    notifyListeners();
  }
  bool isConnected_ = false;
  bool get isConnected => isConnected_;
  set isConnected(bool value) {
    isConnected_ = value;
    notifyListeners();
  }
  bool wrongPassword_ = false;
  bool get wrongPassword => wrongPassword_;
  set wrongPassword(bool value) {
    wrongPassword_ = value;
    notifyListeners();
  }
  bool isGettingGrades_ = false;
  bool get isGettingGrades => isGettingGrades_;
  set isGettingGrades(bool value) {
    isGettingGrades_ = value;
    notifyListeners();
  }
  bool gotGrades_ = false;
  bool get gotGrades => gotGrades_;
  set gotGrades(bool value) {
    gotGrades_ = value;
    notifyListeners();
  }
  
  // Connect the account //
  Future<void> login() async {
    if (!isConnectedAccount) { return; }

    // DEMO ACCOUNT //
    if (loginUsername == "demo" && loginPassword == "1234") {
      isConnecting = true;
      isConnected = false;
      wrongPassword = false;
      await Future.delayed(const Duration(seconds: 2));
      saveLoginData(DemoAccount.demoAccountInfos);
      isLoggedIn = true;
      isConnecting = false;
      AppData.instance.updateUI = true;
      parseGrades();
      return;
    }

    print("Connecting : $loginUsername...");
    isConnecting = true;
    isConnected = false;
    wrongPassword = false;
    if (!isFromCache) { childrenAccounts.clear(); }

    AppData.instance.updateUI = true; // Update the UI //

    final Map<String, String> loginPayload = {
      "identifiant": loginUsername,
      "motdepasse": loginPassword,
    };

    try {
      final http.Response encodedLoginResponse = await http.post(
        Uri.parse("https://api.ecoledirecte.com/login.awp"),
        body: "data=${jsonEncode(loginPayload)}",
        headers: {"user-agent": "Mozilla/5.0"},
      );
      final Map loginResponse = jsonDecode(utf8.decode(encodedLoginResponse.bodyBytes));
      AppData.instance.connectionLog = loginResponse;

      switch (loginResponse["code"]) {
        case 200:
          print("Connection successful !");
          saveLoginData(loginResponse);
          AppData.instance.updateUI = true; // Update the UI //
          isLoggedIn = true;
          FileHandler.instance.writeInfos({
            "isUserLoggedIn": true,
            "username": loginUsername,
            "password": loginPassword
          });
          break;
        
        case 505:
          wrongPassword = true;
          print("Connection failed : wrong username or password for $loginUsername !");
          break;
        
        default:
          print("Connection failed : unknown response code ${loginResponse["code"]}");
          break;
      }
    } catch (e) {
      print("Connection failed : an error occured while connecting $loginUsername...");
      print("Error : $e");
    }

    isConnecting = false;
    AppData.instance.updateUI = false; // Update the UI //
  }

  // Save all the important login data //
  void saveLoginData(Map loginResponse) {
    token = loginResponse["token"];

    final Map accountData = loginResponse["data"]["accounts"][0];

    // Save essential data //
    type = accountData["typeCompte"] ?? "E";
    id = accountData["id"] ?? -1;
    firstName = accountData["prenom"] ?? "";
    lastName = accountData["nom"] ?? "";
    gender = accountData["profile"]["sexe"] ?? "M";

    print("Added main account : $fullName");

    // Check if connected account is student or parent //
    if ((accountData["typeCompte"] ?? "E") == "E") {
      print("This account is a student's account !");
      levelCode = accountData["profile"]["classe"]["code"];
      levelName = accountData["profile"]["classe"]["libelle"];
      isConnected = true;
      parseGrades();
    } else {
      print("This account is a parent's account !");
      if (!isFromCache) {
        for (Map childAccountData in accountData["profile"]["eleves"]) {
          Account childAccount = Account();
          childAccount.isConnected = true;
          childAccount.isConnectedAccount = false;
          childAccount.id = childAccountData["id"] ?? -1;
          childAccount.firstName = childAccountData["prenom"] ?? "";
          childAccount.lastName = childAccountData["nom"] ?? "";
          childAccount.token = token;
          childrenAccounts.add(childAccount);
          AppData.instance.accounts.addAll({"${childAccount.id}": childAccount});
          print("Added child account : ${childAccount.fullName}");
        }
      } else {
        for (Account childAccount in childrenAccounts) {
          childAccount.token = token;
          childAccount.isConnected = true;
        }
        AppData.instance.displayedAccount.parseGrades();
      }
      isConnected = true;
    }
  }

  // Parse grades //
  Future<void> parseGrades() async {
    if (!isConnected) { return; }

    if (loginUsername == "demo" && loginPassword == "1234") {
      gotGrades = true;
      saveGradesData(DemoAccount.demoAccountGrades);
      isFromCache = true;
      AppData.instance.updateUI = true;
      return;
    }
    
    print("Parsing grades for : $fullName...");
    isGettingGrades = true;
    if (!isFromCache) { gotGrades = false; }
    AppData.instance.updateUI = true; // Update the UI //

    final Map<String, String> gradesPayload = {"anneeScolaire": ""};

    try {
      final http.Response encodedGradesResponse = await http.post(
        Uri.parse("https://api.ecoledirecte.com/v3/eleves/$id/notes.awp?verbe=get"),
        body: "data=${jsonEncode(gradesPayload)}",
        headers: {"user-agent": "Mozilla/5.0", "x-token": token},
      );
      final Map gradesResponse = jsonDecode(utf8.decode(encodedGradesResponse.bodyBytes));
      AppData.instance.gradesLog = gradesResponse;

      switch (gradesResponse["code"]) {
        case 200:
          print("Successfully got grades !");
          gotGrades = true;
          saveGradesData(gradesResponse);
          AppData.instance.updateUI = true; // Update the UI //
          break;
        
        case 520:
          print("Invalid token, reconnecting...");
          AppData.instance.connectedAccount.login();
          isGettingGrades = false;
          return;
        
        default:
          print("Connection failed : unknown response code ${gradesResponse["code"]}");
          break;
      }
    } catch (e) {
      print("Connection failed : an error occured while parsing grades for $fullName...");
      print("Error : $e");
    }

    isGettingGrades = false;
    isFromCache = true;
    AppData.instance.updateUI = true; // Update the UI //
  }

  void saveGradesData(Map gradesResponse) {
    // Create all periods and subjects //
    final List<String> possiblePeriodCodes = ["A001", "A002", "A003"];
    for (Map<String, dynamic> periodData in gradesResponse["data"]["periodes"]) {
      if (possiblePeriodCodes.contains(periodData["codePeriode"])) {
        Period period = Period();
        period.fromED(periodData);
        periods.addAll({period.code: period});
      }
    }

    // Add all the grades to corresponding period //
    for (Map<String, dynamic> gradeData in gradesResponse["data"]["notes"]) {
      Grade grade = Grade();
      grade.fromED(gradeData);
      if (periods.containsKey(grade.periodCode)) {
        periods[grade.periodCode]!.addGrade(grade);
      }
    }

    // Calculate all averages //
    for (Period period in periods.values) {
      period.calculateAverage();
      selectedPeriod = period.code;
    }

    if (isConnectedAccount) {
      Map<String, dynamic> cache = toCache(false);
      CacheHandler.saveAllCache(cache);
    }
  }

  // Cache //
  Map<String, dynamic> toCache(bool recursive) {
    Map<String, dynamic> cache = {
      "isLoggedIn": isLoggedIn,
      "accountType": type,
      "isConnectedAccount": isConnectedAccount,
      "firstName": firstName,
      "lastName": lastName,
      "id": id,
      "gender": gender,
      "levelCode": levelCode,
      "levelName": levelName,
      "childrenAccounts": [],
      "periods": [],
      "selectedPeriod": selectedPeriod,
      "gotGrades": gotGrades,
    };
    if (!recursive) {
      for (Account account in childrenAccounts) {
        cache["childrenAccounts"].add(account.toCache(true));
      }
    }
    for (Period period in periods.values) {
      cache["periods"].add(period.toCache());
    }

    return cache;
  }

  void fromCache(Map<String, dynamic> cacheInfos) {
    isLoggedIn = cacheInfos["isLoggedIn"] ?? false;
    type = cacheInfos["accountType"] ?? "E";
    isConnectedAccount = cacheInfos["isConnectedAccount"] ?? true;
    firstName = cacheInfos["firstName"] ?? "";
    lastName = cacheInfos["lastName"] ?? "";
    id = cacheInfos["id"] ?? -1;
    gender = cacheInfos["gender"] ?? "M";
    levelCode = cacheInfos["levelCode"] ?? "";
    levelName = cacheInfos["levelName"] ?? "";
    selectedPeriod = cacheInfos["selectedPeriod"] ?? "";
    gotGrades = cacheInfos["gotGrades"] ?? false;

    for (Map<String, dynamic> childAccountCache in (cacheInfos["childrenAccounts"] ?? [])) {
      Account childAccount = Account();
      childAccount.fromCache(childAccountCache);
      childrenAccounts.add(childAccount);
    }
    for (Map<String, dynamic> periodCache in (cacheInfos["periods"] ?? [])) {
      Period period = Period();
      period.fromCache(periodCache);
      periods.addAll({period.code: period});
    }
    isFromCache = true;

    print("Created $fullName from cache !");
  }

  // Disconnect and forget all saved data //
  void disconnect() {
    isLoggedIn = false;
    firstName = "";
    lastName = "";
    id = -1;
    gender = "M";
    token = "";
    loginUsername = "";
    loginPassword = "";
    childrenAccounts.clear();
    periods.clear();
    selectedPeriod = "";
    isFromCache = false;
    levelCode = "";
    levelName = "";
    isConnected = false;
    gotGrades = false;
  }

  // To not delete the provider after exiting profile screen //
  @override
  // ignore: must_call_super
  void dispose() { }
}
