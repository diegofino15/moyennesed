import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moyennesed/core/app_data.dart';
import 'package:moyennesed/ui/popups/bug_detected_popup.dart';
import 'package:provider/provider.dart';

class BugHandler with ChangeNotifier {
  BugHandler._privateConstructor();
  static final BugHandler instance = BugHandler._privateConstructor();

  bool _isSendingBugReport = false;
  bool get isSendingBugReport => _isSendingBugReport;
  set isSendingBugReport (bool value) {
    _isSendingBugReport = value;
    notifyListeners();
  }

  final Map<String, String> possibleBugs = {
    "Problème de connexion": "Connection",
    "Problème de récupération des notes": "Grades",
    "Fausses moyennes / faux coefs" : "Averages",
    "Problème graphique": "Graphical",
    "Autre" : "Other",
    "auto" : "Automatic",
  };

  Future<bool> sendBugReport(int currentBug) async {
    isSendingBugReport = true;

    final Map<String, dynamic> debugData = {
      "date": DateTime.timestamp().toString(),
      "connectionLog": AppData.instance.connectionLog,
      "gradesLog": AppData.instance.gradesLog,
    };

    late bool successful;
    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection(possibleBugs.values.elementAt(currentBug));
      await collectionRef.add(debugData);
      print("Successfully sent bug report !");
      successful = true;
    } catch (e) {
      print("An error occured while sending bug report : $e");
      successful = false;
    }

    isSendingBugReport = false;
    return successful;
  }

  @override
  // ignore: must_call_super
  void dispose() { }

  void openBugDetectedPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ChangeNotifierProvider(
        create: (_) => instance,
        builder: (context, child) => const BugDetectedPopup(),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }
}