import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:moyennesed/ui/styles.dart';
import 'package:moyennesed/ui/utils.dart';
import 'package:moyennesed/core/objects/grade.dart';
import 'package:moyennesed/core/objects/subject.dart';

class GradePopup extends StatelessWidget {
  final Grade grade;
  final Subject subject;

  const GradePopup({
    super.key,
    required this.grade,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Container(
        height: 150.0 * Styles.scale_,
        padding: EdgeInsets.all(20.0 * Styles.scale_),
        decoration: BoxDecoration(
          color: Styles.backgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0 * Styles.scale_)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 110 * Styles.scale_,
              height: 110 * Styles.scale_,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 100.0 * Styles.scale_,
                    height: 100.0 * Styles.scale_,
                    decoration: BoxDecoration(
                      color: Styles.getSubjectColor(grade.subjectCode, 1),
                      borderRadius: BorderRadius.all(Radius.circular(20.0 * Styles.scale_)),
                    ),
                    child: Center(child: Text(grade.valueStr, style: Styles.numberTextStyle.copyWith(fontSize: 40.0 * Styles.scale_, color: Colors.black))),
                  ),
                  (grade.isEffective && grade.valueOn != 20.0)
                    ? Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 44.0 * Styles.scale_,
                          height: 32.0 * Styles.scale_,
                          decoration: BoxDecoration(
                            color: Styles.getSubjectColor(grade.subjectCode, 0),
                            borderRadius: BorderRadius.all(Radius.circular(10.0 * Styles.scale_)),
                          ),
                          child: Center(child: Text("/${grade.valueOnStr}", style: Styles.numberTextStyle.copyWith(fontSize: 17.0 * Styles.scale_, color: Colors.black))),
                        ),
                      )
                    : Container(),
                ],
              ),
            ),
            Gap(10.0 * Styles.scale_),
            SizedBox(
              height: 100 * Styles.scale_,
              width: MediaQuery.of(context).size.width - 170 * Styles.scale_,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(grade.title, style: Styles.itemTitleTextStyle.copyWith(fontWeight: FontWeight.bold), maxLines: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Classe : ${grade.showableClassValue}", style: Styles.itemTextStyle),
                      Text("-", style: Styles.itemTextStyle),
                      Text("Coef : ${grade.coefficient}", style: Styles.itemTextStyle),
                    ],
                  ),
                  Text(formatDate(grade.dateEntered), style: Styles.itemTextStyle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
