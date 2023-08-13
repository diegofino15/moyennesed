import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:moyennesed/ui/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    setState(() => isSendingBugReport = true );

    final Map<String, dynamic> debugData = {
      "date": DateTime.timestamp().toString(),
      "connectionLog": AppData.instance.connectionLog,
      "gradesLog": AppData.instance.gradesLog,
    };

    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection(possibleBugs.values.elementAt(currentBug));
      await collectionRef.add(debugData);
      sentBugReport = true;
      print("Successfully sent bug report !");
    } catch (e) {
      print("An error occured while sending bug report : $e");
    }

    setState(() {
      isSendingBugReport = false;
    });
  }
  
  int currentBug = 0;
  final Map<String, String> possibleBugs = {
    "Problème de connexion": "Connection",
    "Problème de récupération des notes": "Grades",
    "Fausses moyennes / faux coefs" : "Averages",
    "Problème graphique": "Graphical",
    "Autre" : "Other",
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).padding.bottom + (310.0 + 55.0 * possibleBugs.length + 40.0) * Styles.scale,
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
            child: Text("Reporter un bug", style: Styles.title2TextStyle),
          ),
          Gap(10.0 * Styles.scale),
          Column(
            children: List.generate(
              possibleBugs.length,
              (index) => Column(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => currentBug = index ),
                    child: Container(
                      padding: EdgeInsets.only(left: 15.0 * Styles.scale, right: 10.0 * Styles.scale, top: 10.0 * Styles.scale, bottom: 10.0 * Styles.scale),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECECEC),
                        borderRadius: BorderRadius.all(Radius.circular(10.0 * Styles.scale)),
                      ),
                      height: 45.0 * Styles.scale,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 100.0 * Styles.scale,
                            child: Text(possibleBugs.keys.elementAt(index), style: Styles.subtitle2_54TextStyle, overflow: TextOverflow.fade, maxLines: 1, softWrap: false),
                          ),
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
                  Text("Ne reportez un bug que si un de ces problèmes vous est arrivé.", style: Styles.subtitle3TextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ), textAlign: TextAlign.justify),
                  Gap(10.0 * Styles.scale),
                  Text("En reportant un bug, vous acceptez que les réponses d'ÉcoleDirecte soient envoyées et enregistrées pour pouvoir reproduire le bug et par la suite le régler. Ces informations incluent votre prénom, nom, et notes. Vos identifiants de connexion (identifiant et mot de passe) ne sont pas envoyés, ils ne quittent pas cet appareil.", style: Styles.subtitle3TextStyle, textAlign: TextAlign.justify),
                  Gap(10.0 * Styles.scale),
                  Text("Si votre problème persiste, veuillez s'il vous plaît envoyer un mail à moyennesed@gmail.com avec plus de détails concernant votre problème, pour permettre de le résoudre, merci d'avance.", style: Styles.subtitle3TextStyle, textAlign: TextAlign.justify),
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
                  style: Styles.subtitleTextStyle.copyWith(
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
