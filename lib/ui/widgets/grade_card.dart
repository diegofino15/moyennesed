import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:moyennesed/ui/styles.dart';
import 'package:moyennesed/ui/widgets/grade_popup.dart';
import 'package:moyennesed/core/objects/grade.dart';


class GradeCard extends StatelessWidget {
  final Grade grade;

  const GradeCard({
    super.key,
    required this.grade,
  });

  void openGradePopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => GradePopup(grade: grade),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openGradePopup(context),
      child: Container(
        width: 250.0 * Styles.scale,
        height: 80.0 * Styles.scale,
        padding: EdgeInsets.all(10.0 * Styles.scale),
        decoration: BoxDecoration(
          color: const Color(0xFFECECEC),
          borderRadius: BorderRadius.all(Radius.circular(10.0 * Styles.scale)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 60.0 * Styles.scale,
              height: 60.0 * Styles.scale,
              child: Stack(
                children: [
                  Positioned(
                    top: (30.0 - 55.0 / 2.0) * Styles.scale,
                    left: (30.0 - 55.0 / 2.0) * Styles.scale,
                    child: Container(
                      width: 55.0 * Styles.scale,
                      height: 55.0 * Styles.scale,
                      decoration: BoxDecoration(
                        color: Styles.getSecondarySubjectColor(grade.subjectCode),
                        borderRadius: BorderRadius.all(Radius.circular(10.0 * Styles.scale)),
                      ),
                      child: Center(
                        child: Text(grade.valueStr.isNotEmpty ? grade.valueStr : "N/A", style: TextStyle(
                          fontSize: 20.0 * Styles.scale,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Bitter",
                        )),
                      ),
                    ),
                  ),
                  grade.isEffective && grade.valueOn != 20.0 ? Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 30.0 * Styles.scale,
                      height: 20.0 * Styles.scale,
                      decoration: BoxDecoration(
                        color: Styles.getSubjectColor(grade.subjectCode),
                        borderRadius: BorderRadius.all(Radius.circular(5.0 * Styles.scale)),
                      ),
                      child: Center(
                        child: Text("/${grade.valueOnStr}", style: TextStyle(
                          fontSize: 12.0 * Styles.scale,
                          fontFamily: "Bitter",
                          fontWeight: FontWeight.bold,
                        )),
                      ),
                    ),
                  ) : Container(),
                ],
              ),
            ),
            Gap(10.0 * Styles.scale),
            SizedBox(
              width: (250.0 - 30.0 - 60.0) * Styles.scale,
              height: 60.0 * Styles.scale,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(grade.title, style: TextStyle(
                    fontSize: 16.0 * Styles.scale,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold,
                  ), overflow: TextOverflow.ellipsis, maxLines: 2, softWrap: false),
                  SizedBox(
                    height: 20.0 * Styles.scale,
                    child: Text(grade.subjectTitle, style: TextStyle(
                      fontSize: 14.0 * Styles.scale,
                      fontFamily: "Montserrat",
                    ), overflow: TextOverflow.fade, maxLines: 1, softWrap: false),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
