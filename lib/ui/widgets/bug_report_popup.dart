import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
    setState(() => { isSendingBugReport = true });
    try {
      await http.post(
        Uri.parse("https://api.moyennesed.my.to:777/report_bug"),
        body: jsonEncode({
          "connectionLog": AppData.instance.connectionLog,
          "gradesLog": AppData.instance.gradesLog,
        })
      );
      print("Successfully sent bug report !");
      setState(() => { sentBugReport = true });
    } catch (e) {
      print("An error occured while sending a bug report...");
      print("Error : $e");
    }
    setState(() => { isSendingBugReport = false });
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350.0 * Styles.scale,
      padding: EdgeInsets.all(20.0 * Styles.scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0 * Styles.scale)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Reporter un bug", style: TextStyle(
            fontSize: 20.0 * Styles.scale,
            fontWeight: FontWeight.bold,
            fontFamily: "Montserrat",
          )),
          Gap(20.0 * Styles.scale),
          Text("En reportant un bug, les réponses faites par ÉcoleDirecte lors de votre connexion et de la récupération de vos notes sont enregistrées. Vos identifiants de connexion ne sont pas partagés. Une seule fois suffit !", style: TextStyle(
            fontSize: 17.0 * Styles.scale,
            color: Colors.black54,
            fontFamily: "Montserrat",
          )),
          Text("Si le bug présent vous empêche d'utiliser l'application, veuillez envoyer un mail à moyennesed@gmail.com", style: TextStyle(
            fontSize: 17.0 * Styles.scale,
            color: Colors.black54,
            fontFamily: "Montserrat",
          )),
          Gap(20.0 * Styles.scale),
          GestureDetector(
            onTap: sendBugReport,
            child: Container(
              padding: EdgeInsets.all(20.0 * Styles.scale),
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
