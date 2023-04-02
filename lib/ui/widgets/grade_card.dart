import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:moyennesed/ui/providers/grades_provider.dart';
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
      builder: (_) => GradePopup(grade: grade, subject: GlobalInfos.periods[GradesProvider.instance.currentPeriodCode]!.subjects[grade.subjectCode]!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => handleGradePopup(context),
      child: Container(
        width: 250.0 * Styles.scale_,
        height: 70.0 * Styles.scale_,
        padding: EdgeInsets.all(8.0 * Styles.scale_),
        decoration: BoxDecoration(
          color: Styles.backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(10.0 * Styles.scale_)),
        ),
        child: Row(
          children: [
            Gap(2.0 * Styles.scale_),
            SizedBox(
              width: 55 * Styles.scale_,
              height: 55 * Styles.scale_,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 50.0 * Styles.scale_,
                    height: 50.0 * Styles.scale_,
                    decoration: BoxDecoration(
                      color: Styles.getSubjectColor(grade.subjectCode, 1),
                      borderRadius: BorderRadius.all(Radius.circular(10.0 * Styles.scale_)),
                    ),
                    child: Center(child: Text(grade.valueStr, style: Styles.numberTextStyle.copyWith(fontSize: 20.0 * Styles.scale_, color: Colors.black))),
                  ),
                  (grade.isEffective && grade.valueOn != 20.0)
                    ? Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 22.0 * Styles.scale_,
                          height: 16.0 * Styles.scale_,
                          decoration: BoxDecoration(
                            color: Styles.getSubjectColor(grade.subjectCode, 0),
                            borderRadius: BorderRadius.all(Radius.circular(5.0 * Styles.scale_)),
                          ),
                          child: Center(child: Text("/${grade.valueOnStr}", style: Styles.numberTextStyle.copyWith(fontSize: 12.0 * Styles.scale_, color: Colors.black))),
                        ),
                      )
                    : Container(),
                ],
              ),
            ),
            Gap(5.0 * Styles.scale_),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 170.0 * Styles.scale_,
                  height: 20.0 * Styles.scale_,
                  child: Text(
                    grade.title,
                    style: Styles.itemTitleTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: 170.0 * Styles.scale_,
                  height: 20.0 * Styles.scale_,
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
