import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:moyennesed/ui/styles.dart';
import 'package:moyennesed/core/app_data.dart';


class ChangePeriodPopup extends StatefulWidget {
  const ChangePeriodPopup({super.key});

  @override
  State<ChangePeriodPopup> createState() => _ChangePeriodPopupState();
}

class _ChangePeriodPopupState extends State<ChangePeriodPopup> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).padding.bottom + 255.0 * Styles.scale,
      padding: EdgeInsets.all(20.0 * Styles.scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0 * Styles.scale)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 25.0 * Styles.scale,
            child: Text("Changer de période", style: TextStyle(
              fontSize: 20.0 * Styles.scale,
              fontWeight: FontWeight.bold,
              fontFamily: "Montserrat",
            )),
          ),
          Gap(10.0 * Styles.scale),
          Column(
            children: List.generate(
              AppData.instance.displayedAccount.periods.length,
              (index) => Column(
                children: [
                  Gap(10.0 * Styles.scale),
                  GestureDetector(
                    onTap: () => setState(() {
                      AppData.instance.displayedAccount.selectedPeriod = AppData.instance.displayedAccount.periods.values.elementAt(index).code;
                      AppData.instance.updateUI = true;
                    }),
                    child: Container(
                      height: 50.0 * Styles.scale,
                      padding: EdgeInsets.only(left: 20.0 * Styles.scale, right: 10.0 * Styles.scale, top: 10.0 * Styles.scale, bottom: 10.0 * Styles.scale),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECECEC),
                        borderRadius: BorderRadius.all(Radius.circular(10.0 * Styles.scale)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppData.instance.displayedAccount.periods.values.elementAt(index).title, style: TextStyle(
                            fontSize: 17.0 * Styles.scale,
                            fontFamily: "Montserrat",
                          )),
                          Icon(AppData.instance.displayedAccount.selectedPeriod == AppData.instance.displayedAccount.periods.keys.elementAt(index)
                            ? FluentIcons.checkmark_circle_24_filled
                            : FluentIcons.circle_24_regular,
                            size: 30.0 * Styles.scale,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}