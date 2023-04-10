import 'dart:convert';

import 'package:localstorage/localstorage.dart';

class CacheHandler {
  static LocalStorage storage = LocalStorage("grades_cache");

  static Future<void> saveAllCache(Map<String, dynamic> allCache) async {
    await storage.ready;
    try {
      await storage.setItem("grades_cache", allCache);
    } catch (e) {
      print("An error occured while saving cache...");
      print("Error : $e");
    }
    print("Finished saving cache !");
  }

  static Future<Map> getAllCache() async {
    await storage.ready;
    return storage.getItem("grades_cache");
  }
}

