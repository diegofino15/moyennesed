import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:moyennesed/ui/styles.dart';
import 'package:moyennesed/ui/popups/grade_popup.dart';
import 'package:moyennesed/ui/popups/subject_popup.dart';
import 'package:moyennesed/core/app_data.dart';
import 'package:moyennesed/core/objects/grade.dart';
import 'package:moyennesed/core/objects/subject.dart';


class SubjectCard extends StatelessWidget {
  final Subject subject;
  final bool isRecusive;

  const SubjectCard({
    super.key,
    required this.subject,
    required this.isRecusive,
  });

  void openSubjectPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SubjectPopup(subject: subject),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  void openGradePopup(BuildContext context, Grade grade) {
    showModalBottomSheet(
      context: context,
      builder: (context) => GradePopup(grade: grade),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    if ((!subject.isSub || isRecusive) && subject.subSubjects.isEmpty) {
      return Container(
        height: 80.0 * Styles.scale,
        decoration: BoxDecoration(
          color: Styles.getSecondarySubjectColor(subject.mainCode),
          borderRadius: BorderRadius.all(Radius.circular(10.0 * Styles.scale)),
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => openSubjectPopup(context),
              child: Container(
                width: MediaQuery.of(context).size.width - (80.0 + (isRecusive ? 50.0 : 0.0)) * Styles.scale,
                height: 40.0 * Styles.scale,
                padding: EdgeInsets.symmetric(horizontal: 8.0 * Styles.scale),
                decoration: BoxDecoration(
                  color: Styles.getSubjectColor(subject.mainCode),
                  borderRadius: BorderRadius.all(Radius.circular(10.0 * Styles.scale)),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - (110.0 + 55.0 + (isRecusive ? 50.0 : 0.0)) * Styles.scale,
                        child: Text(subject.title, style: Styles.subtitle2TextStyle.copyWith(
                          fontWeight: FontWeight.bold,
                        ), overflow: TextOverflow.fade, maxLines: 1, softWrap: false),
                      ),
                      SizedBox(
                        width: 55.0 * Styles.scale,
                        child: Text(subject.isEffective ? subject.showableAverage : "--", style: Styles.titleTextStyle.copyWith(
                          fontFamily: "Bitter",
                        ), overflow: TextOverflow.fade, maxLines: 1, softWrap: false, textAlign: TextAlign.end),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Gap(7.5 * Styles.scale),
            Container(
              width: MediaQuery.of(context).size.width - (80.0 + (isRecusive ? 50.0 : 0.0)) * Styles.scale,
              height: 22.5 * Styles.scale,
              padding: EdgeInsets.symmetric(horizontal: 8.0 * Styles.scale),
              child: ListView.separated(
                itemCount: subject.grades.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => openGradePopup(context, subject.grades.elementAt(index)),
                  child: Text(subject.grades.elementAt(index).showableValue, style: Styles.title2TextStyle.copyWith(
                    color: subject.grades.elementAt(index).isEffective && !subject.grades.elementAt(index).isString ? Colors.black : Colors.black26,
                    fontFamily: "Bitter",
                  )),
                ),
                separatorBuilder: (context, index) => Gap(10.0 * Styles.scale),
                scrollDirection: Axis.horizontal,
                key: PageStorageKey<String>("${AppData.instance.displayedAccount.selectedPeriod}-${subject.mainCode}-${subject.subCode}-grades"),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () => openSubjectPopup(context),
          child: Container(
            height: 40.0 * Styles.scale,
            padding: EdgeInsets.symmetric(horizontal: 8.0 * Styles.scale),
            decoration: BoxDecoration(
              color: Styles.getSubjectColor(subject.mainCode),
              borderRadius: BorderRadius.all(Radius.circular(10.0 * Styles.scale)),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 160.0 * Styles.scale,
                    child: Text(subject.title, style: Styles.subtitle2TextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ), overflow: TextOverflow.fade, maxLines: 1, softWrap: false),
                  ),
                  Text(subject.isEffective ? subject.showableAverage : "--", style: Styles.titleTextStyle.copyWith(
                    fontFamily: "Bitter",
                  )),
                ],
              ),
            ),
          ),
        ),
        Column(
          children: List.generate(
            subject.subSubjects.length,
            (index) => Column(
              children: [
                Gap(10.0 * Styles.scale),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 40.0 * Styles.scale,
                      height: 40.0 * Styles.scale,
                      child: Icon(FluentIcons.arrow_right_24_filled, size: 30.0 * Styles.scale),
                    ),
                    SubjectCard(subject: subject.subSubjects.values.elementAt(index), isRecusive: true),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
