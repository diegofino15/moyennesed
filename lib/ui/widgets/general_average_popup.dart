import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:moyennesed/core/infos.dart';
import 'package:moyennesed/ui/providers/grades_provider.dart';
import 'package:moyennesed/ui/styles.dart';
import 'package:moyennesed/ui/utils.dart';

class GeneralAveragePopup extends StatelessWidget {
  const GeneralAveragePopup({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Container(
        height: 140.0 * Styles.scale_,
        padding: EdgeInsets.all(20.0 * Styles.scale_),
        decoration: BoxDecoration(
          color: Styles.backgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0 * Styles.scale_)),
        ),
        child: Row(
          children: [
            Container(
              width: 100.0 * Styles.scale_,
              height: 100.0 * Styles.scale_,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.all(Radius.circular(20.0 * Styles.scale_)),
              ),
              child: Center(child: Text(formatDouble(GlobalInfos.periods[GradesProvider.instance.currentPeriodCode]?.getAverage() ?? 0.0), style: Styles.numberTextStyle.copyWith(color: Colors.black))),
            ),
            Gap(20.0 * Styles.scale_),
            SizedBox(
              height: 100.0 * Styles.scale_,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Moyenne générale", style: Styles.itemTitleTextStyle.copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(
                    width: 200.0 * Styles.scale_,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Classe : ${formatDouble(GlobalInfos.periods[GradesProvider.instance.currentPeriodCode]?.getClassAverage() ?? 0.0)}", style: Styles.itemTextStyle),
                        Text("-", style: Styles.itemTextStyle),
                        Text("Trimestre ${GradesProvider.instance.currentPeriodIndex}", style: Styles.itemTextStyle),
                      ],
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width - 160 * Styles.scale_, child: Text(StudentInfos.fullName, style: Styles.itemTextStyle, overflow: TextOverflow.ellipsis)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}