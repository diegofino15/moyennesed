import 'package:localstorage/localstorage.dart';
import 'package:moyennesed/core/app_data.dart';

class CacheHandler {
  static LocalStorage storage = LocalStorage("moyennesed-cache");

  static Future<void> saveAllCache(Map<String, dynamic> allCache) async {
    await storage.ready;
    
    Map cache = {
      "guessGradeCoefficients": AppData.instance.guessGradeCoefficients,
      "guessSubjectCoefficients": AppData.instance.guessSubjectCoefficients,
      "data": allCache,
    };
    
    try {
      await storage.setItem("moyennesed-cache", cache);
    } catch (e) {
      print("An error occured while saving cache...");
      print("Error : $e");
    }

    print("Finished saving cache !");
  }

  static Future<Map<String, dynamic>> getAllCache() async {
    await storage.ready;

    Map cache = storage.getItem("moyennesed-cache") ?? {};

    AppData.instance.guessGradeCoefficients = cache["guessGradeCoefficients"] ?? true;
    AppData.instance.guessSubjectCoefficients = cache["guessSubjectCoefficients"] ?? true;

    return cache["data"] ?? {};
  }

  static Future<void> changeInfos(Map infos) async {
    await storage.ready;
    Map cache = storage.getItem("moyennesed-cache") ?? {};

    infos.forEach((key, value) {
      cache.update(key, (_) => value, ifAbsent: () => value);
    });

    try {
      await storage.setItem("moyennesed-cache", cache);
    } catch (e) {
      print("An error occured while saving cache...");
      print("Error : $e");
    }

    print("Finished changing cache !");
  }
}

