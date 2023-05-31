import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:moyennesed/ui/styles.dart';

class InformationsPopup extends StatelessWidget {
  const InformationsPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).padding.bottom + 315.0 * Styles.scale,
      padding: EdgeInsets.all(20.0 * Styles.scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0 * Styles.scale)),
      ),
      child: SizedBox(
        height: 275.0 * Styles.scale - MediaQuery.of(context).padding.bottom,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Text("Ces paramètres déterminent la façon dont les coefficients des notes et des matières sont choisis.", style: TextStyle(
              fontSize: 17.0 * Styles.scale,
              color: Colors.black54,
              fontFamily: "Montserrat",
            ), textAlign: TextAlign.justify),
            Gap(10.0 * Styles.scale),
            Text("Devine coefficient notes: essaie de deviner le coefficient d'une note à partir de son titre (ex: DST=coef 2, DM=coef 0.5...). Désactivez cette option si votre établissement fournit les coefficients de vos notes.", style: TextStyle(
              fontSize: 17.0 * Styles.scale,
              color: Colors.black54,
              fontFamily: "Montserrat",
            ), textAlign: TextAlign.justify),
            Gap(10.0 * Styles.scale),
            Text("Devine coefficient matière: détermine le coefficient d'une matière selon les coefficients les plus courants (ex: Français=coef 3, Physique-Chimie=coef 2...). Désactivez cette option si votre établissement fournit les coefficients de vos matières.", style: TextStyle(
              fontSize: 17.0 * Styles.scale,
              color: Colors.black54,
              fontFamily: "Montserrat",
            ), textAlign: TextAlign.justify),
            Gap(10.0 * Styles.scale),
            Text("Aucune de ces options n'est parfaite, le but est d'approximer au maximum la moyenne de chaque matière ainsi que la moyenne générale. Si ces options ne sont pas efficaces pour vous, vous pouvez reporter un bug ou envoyer un mail à moyennesed@gmail.com pour suggerer des améliorations, toute aide est appréciée !", style: TextStyle(
              fontSize: 17.0 * Styles.scale,
              color: Colors.black54,
              fontFamily: "Montserrat",
            ), textAlign: TextAlign.justify),
          ],
        ),
      ),
    );
  }
}