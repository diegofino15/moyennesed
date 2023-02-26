import 'package:localstorage/localstorage.dart';

class CacheHandler {
  static LocalStorage storage = LocalStorage("grades_cache");

  static Future<void> saveAllCache(Map allCache) async {
    await storage.ready;
    storage.setItem("grades_cache", allCache);
  }

  static Future<Map> getAllCache() async {
    await storage.ready;
    return storage.getItem("grades_cache") ?? {};
  }
}

