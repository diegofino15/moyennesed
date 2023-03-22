import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:moyennesed/ui/global_provider.dart';
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
    return Container(
      height: 260.0,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Styles.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Choisir une période", style: Styles.sectionTitleTextStyle),
          Column(
            children: List.generate(
              GlobalInfos.periods.length,
              (index) {
                Period period = GlobalInfos.periods.values.elementAt(index);
  
                return Column(
                  children: [
                    const Gap(10.0),
                    GestureDetector(
                      onTap: () => setState(() => { GlobalProvider.instance.currentPeriodIndex = period.index }),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50.0,
                        padding: const EdgeInsets.only(left: 15.0, right: 10, top: 3.0),
                        decoration: BoxDecoration(
                          color: Styles.mainWidgetBackgroundColor,
                          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(period.name, style: Styles.itemTitleTextStyle),
                            Icon(GlobalProvider.instance.currentPeriodIndex == period.index ? FluentIcons.checkmark_circle_24_filled : FluentIcons.circle_24_regular, size: 30.0, color: Styles.getColor("mainText"))
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}