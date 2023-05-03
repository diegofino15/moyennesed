import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:moyennesed/ui/styles.dart';
import 'package:moyennesed/core/objects/grade.dart';


class GradePopup extends StatelessWidget {
  final Grade grade;

  const GradePopup({
    super.key,
    required this.grade,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).padding.bottom + 150.0 * Styles.scale,
      padding: EdgeInsets.all(20.0 * Styles.scale),
      decoration: BoxDecoration(
        color: const Color(0xFFECECEC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0 * Styles.scale)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110 * Styles.scale,
            height: 110 * Styles.scale,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 100.0 * Styles.scale,
                  height: 100.0 * Styles.scale,
                  decoration: BoxDecoration(
                    color: Styles.getSecondarySubjectColor(grade.subjectCode),
                    borderRadius: BorderRadius.all(Radius.circular(20.0 * Styles.scale)),
                  ),
                  child: Center(child: Text(grade.valueStr.isNotEmpty ? grade.valueStr : "N/A", style: TextStyle(
                    fontSize: 40.0 * Styles.scale,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: "Bitter",
                  ))),
                ),
                (grade.isEffective && grade.valueOn != 20.0)
                  ? Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 44.0 * Styles.scale,
                        height: 32.0 * Styles.scale,
                        decoration: BoxDecoration(
                          color: Styles.getSubjectColor(grade.subjectCode),
                          borderRadius: BorderRadius.all(Radius.circular(10.0 * Styles.scale)),
                        ),
                        child: Center(child: Text("/${grade.valueOnStr}", style: TextStyle(
                          fontSize: 17.0 * Styles.scale,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: "Bitter",
                        ))),
                      ),
                    )
                  : Container(),
              ],
            ),
          ),
          Gap(10.0 * Styles.scale),
          SizedBox(
            height: 100 * Styles.scale,
            width: MediaQuery.of(context).size.width - 170 * Styles.scale,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(grade.title, style: TextStyle(
                  fontSize: 17.0 * Styles.scale,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Montserrat",
                ), maxLines: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Classe : ${grade.showableClassValue}", style: TextStyle(
                      fontSize: 15.0 * Styles.scale,
                      color: Colors.black54,
                      fontFamily: "Montserrat",
                    )),
                    Text("-", style: TextStyle(
                      fontSize: 15.0 * Styles.scale,
                      color: Colors.black54,
                      fontFamily: "Montserrat",
                    )),
                    Text("Coef : ${grade.coefficient}", style: TextStyle(
                      fontSize: 15.0 * Styles.scale,
                      color: Colors.black54,
                      fontFamily: "Montserrat",
                    )),
                  ],
                ),
                Text(Styles.formatDate(grade.dateEntered), style: TextStyle(
                  fontSize: 15.0 * Styles.scale,
                  color: Colors.black54,
                  fontFamily: "Montserrat",
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
