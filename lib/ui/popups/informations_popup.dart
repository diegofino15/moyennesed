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
            Text("Ces paramètres se mettent en place automatiquement lors de votre première connexion. Vous pouvez les changer à tout moment.", style: Styles.subtitle2TextStyle.copyWith(
              fontWeight: FontWeight.bold,
            ), textAlign: TextAlign.justify),
            Gap(10.0 * Styles.scale),
            Text("Ces paramètres déterminent la façon dont les coefficients des notes et des matières sont choisis.", style: Styles.subtitle2_54TextStyle, textAlign: TextAlign.justify),
            Gap(10.0 * Styles.scale),
            Text("Devine coefficient notes: essaie de deviner le coefficient d'une note à partir de son titre (ex: DST=coef 2, DM=coef 0.5...). Désactivez cette option si votre établissement fournit les coefficients de vos notes.", style: Styles.subtitle2_54TextStyle, textAlign: TextAlign.justify),
            Gap(10.0 * Styles.scale),
            Text("Devine coefficient matières: détermine le coefficient d'une matière selon les coefficients les plus courants (ex: Français=coef 3, Physique-Chimie=coef 2...). Désactivez cette option si votre établissement fournit les coefficients de vos matières.", style: Styles.subtitle2_54TextStyle, textAlign: TextAlign.justify),
            Gap(10.0 * Styles.scale),
            Text("Aucune de ces options n'est parfaite, le but est d'approximer au maximum la moyenne de chaque matière ainsi que la moyenne générale. Si ces options ne sont pas efficaces pour vous, vous pouvez reporter un bug ou envoyer un mail à moyennesed@gmail.com pour suggérer des améliorations, toute aide est appréciée !", style: Styles.subtitle2_54TextStyle, textAlign: TextAlign.justify),
          ],
        ),
      ),
    );
  }
}