import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:moyennesed/ui/styles.dart';
import 'package:http/http.dart' as http;
import 'package:moyennesed/core/app_data.dart';


class BugReportPopup extends StatefulWidget {
  const BugReportPopup({super.key});

  @override
  State<BugReportPopup> createState() => _BugReportPopupState();
}

class _BugReportPopupState extends State<BugReportPopup> {
  bool isSendingBugReport = false;
  bool sentBugReport = false;
  
  Future<void> sendBugReport() async {
    if (sentBugReport) { return; }
    
    setState(() => { isSendingBugReport = true });

    final Map debugData = {
      "name": AppData.instance.connectedAccount.fullName,
      "date": DateTime.now().toString(),
      "reportedBug": possibleBugs[currentBug],
      "connectionLog": AppData.instance.connectionLog,
      "gradesLog": AppData.instance.gradesLog,
    };

    try {
      await http.post(
        Uri.parse("https://api.moyennesed.my.to:777/report_bug"),
        body: jsonEncode(debugData),
      );
      print("Successfully sent bug report !");
      setState(() => { sentBugReport = true });
    } catch (e) {
      print("An error occured while sending a bug report...");
      print("Error : $e");
    }
    setState(() => { isSendingBugReport = false });
  }
  
  int currentBug = 0;
  final List<String> possibleBugs = [
    "Problème de connexion",
    "Problème de récupération des notes",
    "Problème graphique",
    "Faux coefficients",
    "Autre",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).padding.bottom + (310.0 + 30.0 * possibleBugs.length + 40.0) * Styles.scale,
      padding: EdgeInsets.all(20.0 * Styles.scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0 * Styles.scale)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 25.0 * Styles.scale,
            child: Text("Reporter un bug", style: TextStyle(
              fontSize: 20.0 * Styles.scale,
              fontWeight: FontWeight.bold,
              fontFamily: "Montserrat",
            )),
          ),
          Gap(10.0 * Styles.scale),
          Column(
            children: List.generate(
              possibleBugs.length,
              (index) => Column(
                children: [
                  SizedBox(
                    height: 20.0 * Styles.scale,
                    child: GestureDetector(
                      onTap: () => setState(() => { currentBug = index }),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(possibleBugs[index], style: TextStyle(
                            fontSize: 17.0 * Styles.scale,
                            color: Colors.black54,
                            fontFamily: "Montserrat",
                          )),
                          Icon(currentBug == index ? FluentIcons.checkmark_circle_24_filled : FluentIcons.circle_24_regular, size: 25.0 * Styles.scale),
                        ],
                      ),
                    ),
                  ),
                  Gap(10.0 * Styles.scale),
                ],
              ),
            ),
          ),
          Gap(10.0 * Styles.scale),
          SizedBox(
            height: 180.0 * Styles.scale,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text("En reportant un bug vous acceptez que nous ayons accès aux réponses d'ÉcoleDirecte, cela contient votre nom et vos notes, mais les identifiants de connexion ne sont pas partagés, ils ne quittent pas cet appareil.", style: TextStyle(
                    fontSize: 16.0 * Styles.scale,
                    color: Colors.black54,
                    fontFamily: "Montserrat",
                  ), textAlign: TextAlign.justify),
                  Text("Si votre problème persiste, veuillez s'il vous plaît envoyer un mail à moyennesed@gmail.com pour permettre de le résoudre, merci d'avance.", style: TextStyle(
                    fontSize: 16.0 * Styles.scale,
                    color: Colors.black54,
                    fontFamily: "Montserrat",
                  ), textAlign: TextAlign.justify),
                ],
              ),
            ),
          ),
          Gap(20.0 * Styles.scale),
          GestureDetector(
            onTap: sendBugReport,
            child: Container(
              height: 60.0 * Styles.scale,
              decoration: BoxDecoration(
                color: const Color(0xFF798BFF),
                borderRadius: BorderRadius.all(Radius.circular(10.0 * Styles.scale)),
              ),
              child: Center(
                child: Text(
                  sentBugReport ? "Envoyé !" : isSendingBugReport ? "Envoi..." : "Envoyer",
                  style: TextStyle(
                    fontSize: 18.0 * Styles.scale,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
