import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:moyennesed/ui/styles.dart';

class ExperimentalFeaturesPopup extends StatelessWidget {
  const ExperimentalFeaturesPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Container(
        height: 210.0 * Styles.scale_,
        padding: EdgeInsets.all(20.0 * Styles.scale_),
        decoration: BoxDecoration(
          color: Styles.backgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0 * Styles.scale_)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Devine coefficient notes", style: Styles.sectionTitleTextStyle),
            Gap(10.0 * Styles.scale_),
            Text("Cette fonction permet de déterminer le coefficient d'une note à partir de son titre.", style: Styles.itemTextStyle),
            Gap(20.0 * Styles.scale_),
            Center(child: Text("Paramètres", style: Styles.itemTitleTextStyle)),
            Gap(10.0 * Styles.scale_),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 50.0 * Styles.scale_,
                  child: Column(
                    children: [
                      Text("DST", style: Styles.itemTextStyle),
                      Text("2.0", style: Styles.numberTextStyle.copyWith(fontSize: 15.0 * Styles.scale_)),
                    ],
                  ),
                ),
                SizedBox(
                  width: 50.0 * Styles.scale_,
                  child: Column(
                    children: [
                      Text("DM", style: Styles.itemTextStyle),
                      Text("0.5", style: Styles.numberTextStyle.copyWith(fontSize: 15.0 * Styles.scale_)),
                    ],
                  ),
                ),
                SizedBox(
                  width: 50.0 * Styles.scale_,
                  child: Column(
                    children: [
                      Text("Autre", style: Styles.itemTextStyle),
                      Text("1.0", style: Styles.numberTextStyle.copyWith(fontSize: 15.0 * Styles.scale_)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}