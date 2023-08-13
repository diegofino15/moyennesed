import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:moyennesed/ui/styles.dart';
import 'package:moyennesed/core/app_data.dart';


class GeneralAveragePopup extends StatelessWidget {
  const GeneralAveragePopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).padding.bottom + 140.0 * Styles.scale,
      padding: EdgeInsets.all(20.0 * Styles.scale),
      decoration: BoxDecoration(
        color: const Color(0xFFECECEC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0 * Styles.scale)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100.0 * Styles.scale,
            height: 100.0 * Styles.scale,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.all(Radius.circular(20.0 * Styles.scale)),
            ),
            child: Center(child: Text(AppData.instance.displayedAccount.gotGrades ? AppData.instance.displayedAccount.periods[AppData.instance.displayedAccount.selectedPeriod]!.showableAverage : "--", style: Styles.displayNumberTextStyle)),
          ),
          Gap(20.0 * Styles.scale),
          SizedBox(
            height: 100.0 * Styles.scale,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Moyenne générale", style: Styles.subtitle2TextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                )),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 160.0 * Styles.scale,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Classe : ${AppData.instance.displayedAccount.gotGrades ? AppData.instance.displayedAccount.periods[AppData.instance.displayedAccount.selectedPeriod]!.showableClassAverage : "--"}", style: Styles.popupTextStyle, overflow: TextOverflow.fade, maxLines: 1, softWrap: false),
                      Text("-", style: Styles.popupTextStyle, overflow: TextOverflow.fade, maxLines: 1, softWrap: false),
                      Text(AppData.instance.displayedAccount.gotGrades ? AppData.instance.displayedAccount.periods[AppData.instance.displayedAccount.selectedPeriod]!.code : "--", style: Styles.popupTextStyle, overflow: TextOverflow.fade, maxLines: 1, softWrap: false),
                    ],
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width - 160 * Styles.scale,
                  child: Text(AppData.instance.displayedAccount.fullName, style: Styles.popupTextStyle, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}