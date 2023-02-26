import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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

  void handleSubjectPopup(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => SubjectPopup(subject: subject),
    );
  }

  void handleGradePopup(BuildContext context, Grade grade) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => GradePopup(grade: grade, subject: subject),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.0,
      decoration: BoxDecoration(
        color: Styles.getSubjectColor(subject.code, 1),
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => handleSubjectPopup(context),
            child: Container(
              height: 40.0,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Styles.getSubjectColor(subject.code, 0),
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(subject.name, style: Styles.itemTitleTextStyle.copyWith(color: Colors.black)),
                  Text(subject.grades.isNotEmpty ? formatDouble(subject.getAverage()) : "--", style: Styles.numberTextStyle.copyWith(fontSize: 22.0, color: Colors.black)),
                ],
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 100,
            height: 45.0,
            child: Scrollbar(
              interactive: false,
              child: ListView.separated(
                key: PageStorageKey<String>(subject.code),
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                itemCount: subject.grades.length,
                itemBuilder: (context, index) {
                  Grade grade = subject.grades[index];
                  return GestureDetector(onTap: () => handleGradePopup(context, grade), child: Text(grade.showableValue, style: Styles.numberTextStyle.copyWith(fontSize: 20.0, color: Colors.black)));
                },
                separatorBuilder: (context, index) {
                  return Gap(index == subject.grades.length - 1 ? 0.0 : 15.0);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
