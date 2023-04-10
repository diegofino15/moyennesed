import 'package:moyennesed/core/infos.dart';
import 'package:moyennesed/core/objects/period.dart';
import 'package:moyennesed/core/handlers/network_handler.dart';
import 'package:moyennesed/core/handlers/network_utils.dart';
import 'package:moyennesed/core/handlers/cache_handler.dart';
import 'package:moyennesed/ui/providers/grades_provider.dart';
import 'package:moyennesed/ui/providers/login_provider.dart';

// This class handles the connection and parsing of all the student's grades //
class GradesHandler {
  static Future<void> getGrades() async {
    // DEMO ACCOUNT //
    if (NetworkHandler.loginUsername == DemoAccount.demoAccountInfos["username"] && NetworkHandler.loginPassword == DemoAccount.demoAccountInfos["password"]) {
      GradesProvider.instance.gotGrades = true;
      sortGrades(DemoAccount.demoAccountGrades);
      return;
    }
    
    if (!LoginProvider.instance.isConnected) {
      if (!LoginProvider.instance.gotNetworkConnection) {
        await NetworkHandler.connect();
        if (!LoginProvider.instance.isConnected) { return; }
      } else { return; }
    }
    
    if (LoginProvider.instance.isConnecting || GradesProvider.instance.isGettingGrades) { return; }

    GradesProvider.instance.isGettingGrades = true;

    print("Getting grades...");

    dynamic gradesResponse = await NetworkUtils.parse(
      NetworkUtils.gradesURL,
      {"anneeScolaire": ""}
    );

    if (gradesResponse != null) {
      sortGrades(gradesResponse);
      GradesProvider.instance.gotGrades = true;
      print("Got grades !");
    } else {
      print("An error occured while getting grades...");
    }

    GradesProvider.instance.isGettingGrades = false;
  }

  static void sortGrades(Map gradesResponse) {
    if (gradesResponse.isEmpty) {
      GradesProvider.instance.gotGrades = false;
      return;
    }
    // Reset all previously saved informations //
    GlobalInfos.periods.clear();
    GradesProvider.instance.currentPeriodIndex = -1;

    // Detect current period of the year //
    const List<String> possiblePeriodCodes = ["A001", "A002", "A003"];
    (gradesResponse["periodes"] ?? []).forEach((periodMap) {
      if (possiblePeriodCodes.contains(periodMap["codePeriode"] ?? "")) {
        Period period = GlobalInfos.addPeriod(periodMap);
        if (!period.isFinished && GradesProvider.instance.currentPeriodIndex == -1) { GradesProvider.instance.currentPeriodIndex = period.index; }
      }
    });

    for (Map gradeMap in (gradesResponse["notes"] ?? [])) {
      String periodCode = gradeMap["codePeriode"] ?? "";
      GlobalInfos.periods[periodCode]?.addGrade(gradeMap);
    }

    // Save all cache //
    Map<String, dynamic> allCache = {
      "firstName": StudentInfos.firstName,
      "lastName": StudentInfos.lastName,
      "level": StudentInfos.level,
      "actualPeriod": GradesProvider.instance.currentPeriodIndex_,
      "periods": {}
    };
    for (Period period in GlobalInfos.periods.values) {
      period.sortGrades();
      allCache["periods"].addAll({period.code: period.toJson()});
    }

    print("Saving all cache...");
    CacheHandler.saveAllCache(allCache);
  }

  static Future<void> loadCache() async {
    print("Loading cache...");
    Map allCache = await CacheHandler.getAllCache();

    if (allCache.isNotEmpty) {
      StudentInfos.firstName = allCache["firstName"] ?? "...";
      StudentInfos.lastName = allCache["lastName"] ?? "";
      StudentInfos.level = allCache["level"] ?? "";

      Map allPeriods = allCache["periods"] ?? {};

      for (Map periodObj in allPeriods.values) {
        Period period = Period();

        try {
          period.fromCache(periodObj);
        } catch (e) {
          print("An error occured while loading cache");
          continue;
        }
        
        GlobalInfos.periods.addAll({period.code: period});
      }
      GradesProvider.instance.currentPeriodIndex = allCache["actualPeriod"] ?? 1;
      GradesProvider.instance.gotGrades = true;
    } else {
      print("No cache found !");
    }
  }
}