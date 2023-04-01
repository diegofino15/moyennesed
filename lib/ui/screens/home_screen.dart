import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    NetworkHandler.autoLogin().then((_) => {
      if (GlobalProvider.instance.isConnected) {
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

  @override
  Widget build(BuildContext widgetBuildContext) {
    Styles.setScale(context);
    int currentWelcomeMessage = Random().nextInt(welcomeMessages.length);

    return Consumer<GlobalProvider>(
      builder: (context, provider, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: provider.isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: Styles.backgroundColor,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0 * Styles.scale_),
            child: RefreshIndicator(
              onRefresh: () async { GradesHandler.getGrades(); },
              child: ListView(
                children: [
                  Gap(10.0 * Styles.scale_),
                  BoxWidget(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 120 * Styles.scale_,
                              child: Row(
                                children: [
                                  provider.gotNetworkConnection
                                    ? Container()
                                    : const Icon(FluentIcons.wifi_off_24_filled, color: Colors.red),
                                  Gap(provider.gotNetworkConnection ? 0.0 : 10.0 * Styles.scale_),
                                  Text(provider.isUserLoggedIn ? "Bonjour ${StudentInfos.firstName} !" : "Vous êtes déconnecté", style: Styles.pageTitleTextStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                            Gap(5.0 * Styles.scale_),
                            Text(provider.isUserLoggedIn ? welcomeMessages[currentWelcomeMessage] : "Connectez vous sur votre profil", style: Styles.itemTextStyle),
                          ],
                        ),
                        SizedBox(
                          width: 40.0 * Styles.scale_,
                          child: GestureDetector(
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
                                Icon(FluentIcons.person_24_filled, size: 35.0 * Styles.scale_, color: Styles.getColor("mainText")),
                                Text("Profil", style: Styles.itemTextStyle)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(20.0 * Styles.scale_),
                  BoxWidget(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Trimestre ${provider.gotGrades ? provider.currentPeriodIndex : "--"}", style: Styles.itemTitleTextStyle),
                            SizedBox(
                              height: 25.0 * Styles.scale_,
                              child: provider.isGettingGrades || provider.isConnecting
                                ? const LoadingAnim()
                                : (provider.gotGrades && provider.isConnected) || !provider.gotNetworkConnection
                                  ? GestureDetector(onTap: () => handleChangePeriodPopup(context), child: Icon(FluentIcons.settings_24_filled, size: 25.0 * Styles.scale_, color: Styles.getColor("mainText")))
                                  : GestureDetector(
                                      onTap: () => {
                                        Navigator.of(context).push(MaterialPageRoute(
                                          builder: (_) => ChangeNotifierProvider<GlobalProvider>(
                                            create: (_) => GlobalProvider.instance,
                                            child: const ProfileScreen(),
                                          ),
                                        ))
                                      },
                                      child: Icon(FluentIcons.warning_24_filled, size: 25.0 * Styles.scale_, color: Colors.orange),
                                    ),
                            ),
                          ],
                        ),
                        Gap(20.0 * Styles.scale_),
                        Center(
                          child: GestureDetector(
                            onTap: () => handleGeneralAveragePopup(context),
                            child: Column(
                              children: [
                                provider.gotGrades
                                  ? Text(GlobalInfos.periods[provider.currentPeriodCode]!.grades.isNotEmpty ? formatDouble(GlobalInfos.periods[provider.currentPeriodCode]!.getAverage()) : "--", style: Styles.numberTextStyle)
                                  : Text("--", style: Styles.numberTextStyle),
                                Gap(5.0 * Styles.scale_),
                                Text("MOYENNE GÉNÉRALE", style: Styles.itemTextStyle),
                              ],
                            ),
                          ),
                        ),
                        Gap(20.0 * Styles.scale_),
                        Text("Dernières notes", style: Styles.itemTitleTextStyle),
                        Gap(10.0 * Styles.scale_),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 80.0 * Styles.scale_,
                          height: 70.0 * Styles.scale_,
                          child: ListView.separated(
                            key: const PageStorageKey<String>("grades"),
                            scrollDirection: Axis.horizontal,
                            itemCount: provider.gotGrades ? min(20, GlobalInfos.periods[provider.currentPeriodCode]!.grades.length) : 0,
                            itemBuilder: (context, index) => GradeCard(grade: GlobalInfos.periods[provider.currentPeriodCode]!.grades[GlobalInfos.periods[provider.currentPeriodCode]!.grades.length - index - 1]),
                            separatorBuilder: (context, index) {
                              return Gap(index == min(20, GlobalInfos.periods[provider.currentPeriodCode]!.grades.length) - 1 ? 0.0 : 10.0 * Styles.scale_);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(20.0 * Styles.scale_),
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
                                  Gap(20.0 * Styles.scale_),
                                  SubjectCard(subject: subject),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(20.0 * Styles.scale_),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}