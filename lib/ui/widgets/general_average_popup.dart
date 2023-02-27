import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:moyennesed/core/infos.dart';
import 'package:moyennesed/ui/global_provider.dart';
import 'package:moyennesed/ui/styles.dart';
import 'package:moyennesed/ui/utils.dart';

class GeneralAveragePopup extends StatelessWidget {
  const GeneralAveragePopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140.0,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Styles.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      child: Row(
        children: [
          Container(
            width: 100.0,
            height: 100.0,
            decoration: const BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            child: Center(child: Text(formatDouble(GlobalInfos.periods[GlobalProvider.instance.currentPeriodCode]!.getAverage()), style: Styles.numberTextStyle.copyWith(color: Colors.black))),
          ),
          const Gap(20.0),
          SizedBox(
            height: 100.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Moyenne générale", style: Styles.itemTitleTextStyle.copyWith(fontWeight: FontWeight.bold)),
                SizedBox(
                  width: 200.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Classe : ${formatDouble(GlobalInfos.periods[GlobalProvider.instance.currentPeriodCode]!.getClassAverage())}", style: Styles.itemTextStyle),
                      Text("-", style: Styles.itemTextStyle),
                      Text("Trimestre ${GlobalProvider.instance.currentPeriodIndex}", style: Styles.itemTextStyle),
                    ],
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width - 160, child: Text(StudentInfos.fullName, style: Styles.itemTextStyle, overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}