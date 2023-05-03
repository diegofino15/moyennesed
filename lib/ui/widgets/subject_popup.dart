import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:moyennesed/ui/styles.dart';
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
      height: MediaQuery.of(context).padding.bottom + 140.0 * Styles.scale,
      padding: EdgeInsets.all(20.0 * Styles.scale),
      decoration: BoxDecoration(
        color: const Color(0xFFECECEC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0 * Styles.scale)),
      ),
      child: Row(
        children: [
          Container(
            width: 100.0 * Styles.scale,
            height: 100.0 * Styles.scale,
            decoration: BoxDecoration(
              color: Styles.getSubjectColor(subject.mainCode),
              borderRadius: BorderRadius.all(Radius.circular(20.0 * Styles.scale)),
            ),
            child: Center(child: Text(subject.showableAverage, style: TextStyle(
              fontSize: 35.0 * Styles.scale,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: "Bitter",
            ))),
          ),
          Gap(20.0 * Styles.scale),
          SizedBox(
            height: 100.0 * Styles.scale,
            width: MediaQuery.of(context).size.width - 170 * Styles.scale,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject.title, style: TextStyle(
                  fontSize: 17.0 * Styles.scale,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Montserrat"
                ), overflow: TextOverflow.fade, maxLines: 1, softWrap: false),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Classe : ${subject.showableClassAverage}", style: TextStyle(
                      fontSize: 15.0 * Styles.scale,
                      color: Colors.black54,
                      fontFamily: "Montserrat",
                    )),
                    Text("-", style: TextStyle(
                      fontSize: 15.0 * Styles.scale,
                      color: Colors.black54,
                      fontFamily: "Montserrat",
                    )),
                    Text("Coef : ${subject.coefficient}", style: TextStyle(
                      fontSize: 15.0 * Styles.scale,
                      color: Colors.black54,
                      fontFamily: "Montserrat",
                    )),
                  ],
                ),
                Text(subject.teachers.isNotEmpty ? subject.teachers.first : "Pas de professeur", style: TextStyle(
                  fontSize: 15.0 * Styles.scale,
                  color: Colors.black54,
                  fontFamily: "Montserrat",
                ), maxLines: 1, overflow: TextOverflow.fade, softWrap: false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}