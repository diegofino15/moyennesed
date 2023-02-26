import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:moyennesed/ui/global_provider.dart';
import 'package:moyennesed/ui/styles.dart';
import 'package:moyennesed/ui/utils.dart';
import 'package:moyennesed/ui/widgets/box_widget.dart';
import 'package:moyennesed/ui/widgets/load_animation.dart';
import 'package:moyennesed/ui/widgets/grade_card.dart';
import 'package:moyennesed/ui/widgets/subject_card.dart';
import 'package:moyennesed/ui/widgets/change_period_popup.dart';
import 'package:moyennesed/ui/widgets/general_average_popup.dart';
import 'package:moyennesed/ui/screens/profile_screen.dart';
import 'package:moyennesed/core/infos.dart';
import 'package:moyennesed/core/handlers/network_handler.dart';
import 'package:moyennesed/core/handlers/grades_handler.dart';
import 'package:moyennesed/core/objects/subject.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    autoLoad();
  }

  Future<void> autoLoad() async {
    GradesHandler.loadCache();
    NetworkHandler.autoLogin().then((provider) => {
      if (Provider.of<GlobalProvider>(MainAppKey.globalKey.currentContext!, listen: false).isConnected) {
        GradesHandler.getGrades()
      }
    });
  }

  void handleGeneralAveragePopup(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (_) => const GeneralAveragePopup()
    );
  }

  void handleChangePeriodPopup(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (_) => const ChangePeriodPopup()
    );
  }

  // Current welcome message being shown //
  int currentWelcomeMessage = Random().nextInt(welcomeMessages.length);

  @override
  Widget build(BuildContext _) {
    return Consumer<GlobalProvider>(
      builder: (context, provider, child) => Scaffold(
        backgroundColor: Styles.backgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: RefreshIndicator(
            onRefresh: () => GradesHandler.getGrades(),
            child: ListView(
              children: [
                const Gap(10.0),
                BoxWidget(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              provider.gotNetworkConnection
                                ? Container()
                                : const Icon(FluentIcons.wifi_off_24_filled, color: Colors.red),
                              Gap(provider.gotNetworkConnection ? 0.0 : 10.0),
            
                              Text(provider.isUserLoggedIn ? "Bonjour ${StudentInfos.firstName} !" : "Vous n'êtes pas connecté", style: Styles.pageTitleTextStyle),
                            ],
                          ),
                          const Gap(5.0),
                          Text(provider.isUserLoggedIn ? welcomeMessages[currentWelcomeMessage] : "Connectez vous sur votre profil", style: Styles.itemTextStyle),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => ChangeNotifierProvider<GlobalProvider>(
                              create: (_) => GlobalProvider.instance,
                              child: const ProfileScreen(),
                            ),
                          ));
                        },
                        child: Column(
                          children: [
                            Icon(FluentIcons.person_24_filled, size: 35.0, color: Styles.getColor("mainText")),
                            Text("Profil", style: Styles.itemTextStyle)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(20.0),
                BoxWidget(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Trimestre ${provider.gotGrades ? provider.currentPeriodIndex : "--"}", style: Styles.itemTitleTextStyle),
                          SizedBox(
                            height: 25.0,
                            child: provider.isGettingGrades ? const LoadingAnim() : provider.gotGrades ? GestureDetector(onTap: () => handleChangePeriodPopup(context), child: Icon(FluentIcons.arrow_bidirectional_up_down_24_filled, size: 25.0, color: Styles.getColor("mainText"))) : Container(),
                          ),
                        ],
                      ),
                      const Gap(20.0),
                      Center(
                        child: Column(
                          children: [
                            provider.gotGrades
                              ? GestureDetector(
                                  onTap: () => handleGeneralAveragePopup(context),
                                  child: Text(GlobalInfos.periods[provider.currentPeriodCode]!.grades.isNotEmpty ? formatDouble(GlobalInfos.periods[provider.currentPeriodCode]!.getAverage()) : "--", style: Styles.numberTextStyle),
                                )
                              : Text("--", style: Styles.numberTextStyle),
                            const Gap(5.0),
                            Text("MOYENNE GÉNÉRALE", style: Styles.itemTextStyle),
                          ],
                        ),
                      ),
                      const Gap(20.0),
                      Text("Dernières notes", style: Styles.itemTitleTextStyle),
                      const Gap(10.0),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 80.0,
                        height: 70.0,
                        child: ListView.separated(
                          key: const PageStorageKey<String>("grades"),
                          scrollDirection: Axis.horizontal,
                          itemCount: provider.gotGrades ? min(20, GlobalInfos.periods[provider.currentPeriodCode]!.grades.length) : 0,
                          itemBuilder: (context, index) => GradeCard(grade: GlobalInfos.periods[provider.currentPeriodCode]!.grades[GlobalInfos.periods[provider.currentPeriodCode]!.grades.length - index - 1]),
                          separatorBuilder: (context, index) {
                            return Gap(index == min(20, GlobalInfos.periods[provider.currentPeriodCode]!.grades.length) - 1 ? 0.0 : 10.0);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(20.0),
                BoxWidget(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Moyennes par matière", style: Styles.itemTitleTextStyle),
                      Column(
                        children: List.generate(
                          provider.gotGrades ? GlobalInfos.periods[provider.currentPeriodCode]!.subjects.length : 0,
                          (index) {
                            Subject subject = GlobalInfos.periods[provider.currentPeriodCode]!.subjects.values.elementAt(index);
            
                            return Column(
                              children: [
                                const Gap(20.0),
                                SubjectCard(subject: subject),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}