import 'package:moyennesed/core/infos.dart';
import 'package:moyennesed/core/objects/period.dart';
import 'package:moyennesed/core/handlers/network_handler.dart';
import 'package:moyennesed/core/handlers/network_utils.dart';
import 'package:moyennesed/core/handlers/cache_handler.dart';
import 'package:moyennesed/ui/global_provider.dart';
import 'package:provider/provider.dart';

// This class handles the connection and parsing of all the student's grades //
class GradesHandler {
  static Future<void> getGrades() async {
    GlobalProvider provider = Provider.of<GlobalProvider>(MainAppKey.globalKey.currentContext!, listen: false);

    if (!provider.isConnected) {
      if (!provider.gotNetworkConnection) {
        await NetworkHandler.connect();
        if (!provider.isConnected) { return; }
      } else { return; }
    }
    
    if (provider.isConnecting || provider.isGettingGrades) { return; }

    provider.isGettingGrades = true;

    print("Getting grades...");

    dynamic gradesResponse = await NetworkUtils.parse(
      NetworkUtils.gradesURL,
      {"anneeScolaire": ""}
    );

    if (gradesResponse != null) {
      sortGrades(gradesResponse);
      provider.gotGrades = true;
      print("Got grades !");
    } else {
      print("An error occured while getting grades...");
    }

    provider.isGettingGrades = false;
  }

  static void sortGrades(Map gradesResponse) {
    GlobalProvider provider = Provider.of<GlobalProvider>(MainAppKey.globalKey.currentContext!, listen: false);
    
    // Reset all previously saved informations //
    GlobalInfos.periods.clear();
    provider.currentPeriodIndex = -1;

    // Detect current period of the year //
    for (int i = 1; i <= 3; i++) {
      Map periodMap = gradesResponse["periodes"][(i - 1) * 3];
      Period period = GlobalInfos.addPeriod(periodMap);
      if (!period.isFinished && provider.currentPeriodIndex == -1) { provider.currentPeriodIndex = i; }
    }

    for (Map gradeMap in gradesResponse["notes"]) {
      String periodCode = gradeMap["codePeriode"];
      GlobalInfos.periods[periodCode]!.addGrade(gradeMap);
    }

    // Save all cache //
    Map allCache = {
      "firstName": StudentInfos.firstName,
      "lastName": StudentInfos.lastName,
      "level": StudentInfos.level,
      "actualPeriod": provider.currentPeriodIndex,
      "periods": {}
    };
    for (Period period in GlobalInfos.periods.values) {
      period.sortGrades();
      allCache["periods"].addAll({period.code: period.toJson()});
    }

    CacheHandler.saveAllCache(allCache);
  }

  static Future<void> loadCache() async {
    GlobalProvider provider = Provider.of<GlobalProvider>(MainAppKey.globalKey.currentContext!, listen: false);

    Map allCache = await CacheHandler.getAllCache();

    if (allCache.isNotEmpty) {
      StudentInfos.firstName = allCache["firstName"] ?? "...";
      StudentInfos.lastName = allCache["lastName"] ?? "";
      StudentInfos.level = allCache["level"] ?? "Chargement...";

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
      provider.currentPeriodIndex = allCache["actualPeriod"] ?? 1;
      provider.gotGrades = true;
    }
  }
}