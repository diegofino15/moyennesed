import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:moyennesed/ui/styles.dart';
import 'package:moyennesed/core/app_data.dart';


class GeneralAveragePopup extends StatelessWidget {
  const GeneralAveragePopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140.0 * Styles.scale,
      padding: EdgeInsets.all(20.0 * Styles.scale),
      decoration: BoxDecoration(
        color: Styles.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0 * Styles.scale)),
      ),
      child: Row(
        children: [
          Container(
            width: 100.0 * Styles.scale,
            height: 100.0 * Styles.scale,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.all(Radius.circular(20.0 * Styles.scale)),
            ),
            child: Center(child: Text(AppData.instance.displayedAccount.gotGrades ? AppData.instance.displayedAccount.periods[AppData.instance.displayedAccount.selectedPeriod]!.showableAverage : "--", style: TextStyle(
              fontSize: 35.0 * Styles.scale,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: "Bitter",
            ))),
          ),
          Gap(20.0 * Styles.scale),
          SizedBox(
            height: 100.0 * Styles.scale,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Moyenne générale", style: TextStyle(
                  fontSize: 17.0 * Styles.scale,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Montserrat"
                )),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 160.0 * Styles.scale,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Classe : ${AppData.instance.displayedAccount.gotGrades ? AppData.instance.displayedAccount.periods[AppData.instance.displayedAccount.selectedPeriod]!.showableClassAverage : "--"}", style: TextStyle(
                        fontSize: 15.0 * Styles.scale,
                        color: Colors.black54,
                        fontFamily: "Montserrat",
                      ), overflow: TextOverflow.fade, maxLines: 1, softWrap: false),
                      Text("-", style: TextStyle(
                        fontSize: 15.0 * Styles.scale,
                        color: Colors.black54,
                        fontFamily: "Montserrat",
                      ), overflow: TextOverflow.fade, maxLines: 1, softWrap: false),
                      Text(AppData.instance.displayedAccount.gotGrades ? AppData.instance.displayedAccount.periods[AppData.instance.displayedAccount.selectedPeriod]!.code : "--", style: TextStyle(
                        fontSize: 15.0 * Styles.scale,
                        color: Colors.black54,
                        fontFamily: "Montserrat",
                      ), overflow: TextOverflow.fade, maxLines: 1, softWrap: false),
                    ],
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width - 160 * Styles.scale, child: Text(AppData.instance.displayedAccount.fullName, style: TextStyle(
                  fontSize: 15.0 * Styles.scale,
                  color: Colors.black54,
                  fontFamily: "Montserrat",
                ), overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}