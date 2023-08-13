import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:moyennesed/core/bug_handler.dart';
import 'package:moyennesed/ui/styles.dart';


class BugDetectedPopup extends StatefulWidget {
  const BugDetectedPopup({super.key});

  @override
  State<BugDetectedPopup> createState() => _BugDetectedPopupState();
}

class _BugDetectedPopupState extends State<BugDetectedPopup> {
  void sendBugReport() {
    BugHandler.instance.sendBugReport(BugHandler.instance.possibleBugs.length - 1);
    Navigator.of(context).pop();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).padding.bottom + 300.0 * Styles.scale,
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
            child: Text("Un problème est survenu", style: Styles.title2TextStyle),
          ),
          Gap(10.0 * Styles.scale),
          SizedBox(
            height: 180.0 * Styles.scale,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text("Voulez-vous reporter un bug automatiquement pour permettre de résoudre ce problème dans le futur ?", style: Styles.subtitle3TextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ), textAlign: TextAlign.justify),
                  Gap(10.0 * Styles.scale),
                  Text("Il semble que la connexion à votre compte ou la récupération de vos notes aie échoué.", style: Styles.subtitle3TextStyle, textAlign: TextAlign.justify),
                  Gap(10.0 * Styles.scale),
                  Text("En reportant un bug, vous acceptez que les réponses d'ÉcoleDirecte soient envoyées et enregistrées pour pouvoir reproduire le bug et par la suite le régler. Ces informations incluent votre prénom, nom, et notes. Vos identifiants de connexion (identifiant et mot de passe) ne sont pas envoyés, ils ne quittent pas cet appareil.", style: Styles.subtitle3TextStyle, textAlign: TextAlign.justify),
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
                  "Reporter un bug",
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