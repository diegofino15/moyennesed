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
    return Container(
      height: 150.0,
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        color: Styles.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            height: 110,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: Styles.getSubjectColor(grade.subjectCode, 1),
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Center(child: Text(grade.valueStr, style: Styles.numberTextStyle.copyWith(fontSize: 40.0))),
                ),
                (grade.isEffective && (grade.valueOn ?? 20.0) != 20.0)
                  ? Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 44.0,
                        height: 32.0,
                        decoration: BoxDecoration(
                          color: Styles.getSubjectColor(grade.subjectCode, 0),
                          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: Center(child: Text("/${grade.valueOnStr}", style: Styles.numberTextStyle.copyWith(fontSize: 24.0))),
                      ),
                    )
                  : Container(),
              ],
            ),
          ),
          const Gap(10.0),
          SizedBox(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 200.0,
                  child: Text(grade.title, style: Styles.itemTitleTextStyle.copyWith(fontWeight: FontWeight.bold), maxLines: 2),
                ),
                SizedBox(
                  width: 200.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Classe : ${grade.showableClassValue}", style: Styles.itemTextStyle),
                      const Text("-", style: Styles.itemTextStyle),
                      Text("Coef : ${grade.coefficient}", style: Styles.itemTextStyle),
                    ],
                  ),
                ),
                Text(formatDate(grade.dateEntered), style: Styles.itemTextStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
