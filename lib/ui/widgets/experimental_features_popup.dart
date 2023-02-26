import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:moyennesed/ui/styles.dart';

class ExperimentalFeaturesPopup extends StatelessWidget {
  const ExperimentalFeaturesPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210.0,
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        color: Styles.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Devine coefficient notes", style: Styles.sectionTitleTextStyle),
          const Gap(10.0),
          const Text("Cette fonction permet de déduire le coefficient d'une note à partir de son titre.", style: Styles.itemTextStyle),
          const Gap(20.0),
          const Center(child: Text("Paramètres", style: Styles.itemTitleTextStyle)),
          const Gap(10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 50.0,
                child: Column(
                  children: [
                    const Text("DST", style: Styles.itemTextStyle),
                    Text("2.0", style: Styles.numberTextStyle.copyWith(fontSize: 15.0)),
                  ],
                ),
              ),
              SizedBox(
                width: 50.0,
                child: Column(
                  children: [
                    const Text("DM", style: Styles.itemTextStyle),
                    Text("0.5", style: Styles.numberTextStyle.copyWith(fontSize: 15.0)),
                  ],
                ),
              ),
              SizedBox(
                width: 50.0,
                child: Column(
                  children: [
                    const Text("Autre", style: Styles.itemTextStyle),
                    Text("1.0", style: Styles.numberTextStyle.copyWith(fontSize: 15.0)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}