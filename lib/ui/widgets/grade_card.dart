import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:moyennesed/ui/global_provider.dart';
import 'package:moyennesed/ui/styles.dart';
import 'package:moyennesed/ui/widgets/grade_popup.dart';
import 'package:moyennesed/core/infos.dart';
import 'package:moyennesed/core/objects/grade.dart';

class GradeCard extends StatelessWidget {
  final Grade grade;

  const GradeCard({
    super.key,
    required this.grade,
  });

  void handleGradePopup(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (_) => GradePopup(grade: grade, subject: GlobalInfos.periods[GlobalProvider.instance.currentPeriodCode]!.subjects[grade.subjectCode]!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => handleGradePopup(context),
      child: Container(
        width: 250.0,
        height: 70.0,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Styles.backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Row(
          children: [
            const Gap(2.0),
            SizedBox(
              width: 55,
              height: 55,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Styles.getSubjectColor(grade.subjectCode, 1),
                      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Center(child: Text(grade.valueStr, style: Styles.numberTextStyle.copyWith(fontSize: 20.0, color: Colors.black))),
                  ),
                  (grade.isEffective && (grade.valueOn ?? 20.0) != 20.0)
                    ? Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 22.0,
                          height: 16.0,
                          decoration: BoxDecoration(
                            color: Styles.getSubjectColor(grade.subjectCode, 0),
                            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: Center(child: Text("/${grade.valueOnStr}", style: Styles.numberTextStyle.copyWith(fontSize: 12.0, color: Colors.black))),
                        ),
                      )
                    : Container(),
                ],
              ),
            ),
            const Gap(5.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 170.0,
                  height: 20.0,
                  child: Text(
                    grade.title,
                    style: Styles.itemTitleTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: 170.0,
                  height: 20.0,
                  child: Text(
                    grade.subjectName,
                    style: Styles.itemTextStyle,
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
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
