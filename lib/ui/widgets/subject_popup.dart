import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:moyennesed/ui/styles.dart';
import 'package:moyennesed/ui/utils.dart';
import 'package:moyennesed/core/objects/subject.dart';

class SubjectPopup extends StatelessWidget {
  final Subject subject;

  const SubjectPopup({
    super.key,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              color: Styles.getSubjectColor(subject.code, 0),
              borderRadius: BorderRadius.all(Radius.circular(20.0 * Styles.scale_)),
            ),
            child: Center(child: Text(subject.grades.isNotEmpty ? formatDouble(subject.getAverage()) : "--", style: Styles.numberTextStyle.copyWith(color: Colors.black))),
          ),
          Gap(20.0 * Styles.scale_),
          SizedBox(
            height: 100.0 * Styles.scale_,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 190 * Styles.scale_, child: Text(subject.name, style: Styles.itemTitleTextStyle.copyWith(fontWeight: FontWeight.bold), overflow: TextOverflow.fade, maxLines: 1, softWrap: false)),
                SizedBox(
                  width: 190 * Styles.scale_,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Classe : ${subject.grades.isNotEmpty ? formatDouble(subject.getClassAverage()) : "--"}", style: Styles.itemTextStyle),
                      Text("-", style: Styles.itemTextStyle),
                      Text("Coef : ${subject.coefficient}", style: Styles.itemTextStyle),
                    ],
                  ),
                ),
                Text(subject.professorName, style: Styles.itemTextStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
