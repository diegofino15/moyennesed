import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:moyennesed/ui/providers/grades_provider.dart';
import 'package:moyennesed/ui/styles.dart';
import 'package:moyennesed/core/infos.dart';
import 'package:moyennesed/core/objects/period.dart';

class ChangePeriodPopup extends StatefulWidget {
  const ChangePeriodPopup({super.key});

  @override
  State<ChangePeriodPopup> createState() => _ChangePeriodPopupState();
}

class _ChangePeriodPopupState extends State<ChangePeriodPopup> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Container(
        height: 260.0 * Styles.scale_,
        padding: EdgeInsets.all(20.0 * Styles.scale_),
        decoration: BoxDecoration(
          color: Styles.backgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0 * Styles.scale_)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Choisir une période", style: Styles.sectionTitleTextStyle),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 200.0 - 19.0,
              child: ListView(
                children: List.generate(
                  GlobalInfos.periods.length,
                  (index) {
                    Period period = GlobalInfos.periods.values.elementAt(index);
                  
                    return Column(
                      children: [
                        Gap(10.0 * Styles.scale_),
                        GestureDetector(
                          onTap: () => setState(() => { GradesProvider.instance.currentPeriodIndex = period.index }),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50.0 * Styles.scale_,
                            padding: EdgeInsets.only(left: 15.0 * Styles.scale_, right: 10 * Styles.scale_, top: 3.0 * Styles.scale_),
                            decoration: BoxDecoration(
                              color: Styles.mainWidgetBackgroundColor,
                              borderRadius: BorderRadius.all(Radius.circular(10.0 * Styles.scale_)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(period.name, style: Styles.itemTitleTextStyle),
                                Icon(GradesProvider.instance.currentPeriodIndex == period.index ? FluentIcons.checkmark_circle_24_filled : FluentIcons.circle_24_regular, size: 30.0 * Styles.scale_, color: Styles.getColor("mainText"))
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}