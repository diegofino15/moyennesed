import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:moyennesed/ui/providers/grades_provider.dart';
import 'package:moyennesed/ui/styles.dart';
import 'package:moyennesed/ui/utils.dart';
import 'package:moyennesed/ui/widgets/grade_popup.dart';
import 'package:moyennesed/ui/widgets/subject_popup.dart';
import 'package:moyennesed/core/objects/grade.dart';
import 'package:moyennesed/core/objects/subject.dart';

class SubjectCard extends StatelessWidget {
  final Subject subject;

  const SubjectCard({
    super.key,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.0 * Styles.scale_,
      decoration: BoxDecoration(
        color: Styles.getSubjectColor(subject.code, 1),
        borderRadius: BorderRadius.all(Radius.circular(10.0 * Styles.scale_)),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => openBottomSheet(context, SubjectPopup(subject: subject)),
            child: Container(
              height: 40.0 * Styles.scale_,
              padding: EdgeInsets.all(8.0 * Styles.scale_),
              decoration: BoxDecoration(
                color: Styles.getSubjectColor(subject.code, 0),
                borderRadius: BorderRadius.all(Radius.circular(10.0 * Styles.scale_)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 164 * Styles.scale_,
                    child: Text(subject.name, style: Styles.itemTitleTextStyle.copyWith(color: Colors.black), overflow: TextOverflow.fade, maxLines: 1, softWrap: false),
                  ),
                  Text(subject.grades.isNotEmpty ? formatDouble(subject.getAverage()) : "--", style: Styles.numberTextStyle.copyWith(fontSize: 22.0 * Styles.scale_, color: Colors.black))
                ],
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 100 * Styles.scale_,
            height: 45.0 * Styles.scale_,
            child: Scrollbar(
              interactive: false,
              child: ListView.separated(
                key: PageStorageKey<String>("${subject.code}-${GradesProvider.instance.currentPeriodCode}"),
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(vertical: 10.0 * Styles.scale_),
                itemCount: subject.grades.length,
                itemBuilder: (context, index) {
                  Grade grade = subject.grades[index];
                  return GestureDetector(onTap: () => openBottomSheet(context, GradePopup(grade: grade, subject: subject)), child: Text(grade.showableValue, style: Styles.numberTextStyle.copyWith(fontSize: 20.0 * Styles.scale_, color: Colors.black)));
                },
                separatorBuilder: (context, index) {
                  return Gap(index == subject.grades.length - 1 ? 0.0 : 15.0 * Styles.scale_);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
