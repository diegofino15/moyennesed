import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:moyennesed/ui/global_provider.dart';
import 'package:moyennesed/ui/styles.dart';
import 'package:moyennesed/core/infos.dart';
import 'package:moyennesed/core/objects/period.dart';
import 'package:provider/provider.dart';

class ChangePeriodPopup extends StatefulWidget {
  const ChangePeriodPopup({super.key});

  @override
  State<ChangePeriodPopup> createState() => _ChangePeriodPopupState();
}

class _ChangePeriodPopupState extends State<ChangePeriodPopup> {
  int selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    GlobalProvider provider = Provider.of<GlobalProvider>(MainAppKey.globalKey.currentContext!, listen: false);

    if (selectedIndex == -1) {
      selectedIndex = provider.currentPeriodIndex;
    }

    return Container(
      height: 260.0,
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        color: Styles.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Choisir une période", style: Styles.sectionTitleTextStyle),
              SizedBox(
                height: 30.0,
                child: OutlinedButton(
                  onPressed: () => setState(() {
                    provider.currentPeriodIndex = selectedIndex;
                    Navigator.of(context).pop();
                  }),
                  child: Center(child: Text("Valider", style: Styles.itemTextStyle.copyWith(color: Colors.green))),
                ),
              ),
            ],
          ),
          Column(
            children: List.generate(
              GlobalInfos.periods.length,
              (index) {
                Period period = GlobalInfos.periods.values.elementAt(index);
  
                return Column(
                  children: [
                    const Gap(10.0),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50.0,
                      padding: const EdgeInsets.only(left: 15.0, right: 10, top: 3.0),
                      decoration: const BoxDecoration(
                        color: Styles.mainWidgetBackgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(period.name, style: Styles.itemTitleTextStyle),
                          GestureDetector(
                            onTap: () => setState(() => { selectedIndex = period.index }),
                            child: Icon(selectedIndex == period.index ? FluentIcons.checkmark_circle_24_filled : FluentIcons.circle_24_regular, size: 30.0),
                          ),
                        ],
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