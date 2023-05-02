import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:moyennesed/ui/styles.dart';
import 'package:moyennesed/ui/screens/profile_screen.dart';
import 'package:moyennesed/ui/widgets/change_period_popup.dart';
import 'package:moyennesed/ui/widgets/general_average_popup.dart';
import 'package:moyennesed/ui/widgets/grade_card.dart';
import 'package:moyennesed/ui/widgets/subject_card.dart';
import 'package:moyennesed/ui/widgets/loading_animation.dart';
import 'package:moyennesed/core/app_data.dart';
import 'package:moyennesed/core/cache_handler.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    currentWelcomeMessage = welcomeMessages[Random().nextInt(welcomeMessages.length)];
  }

  late String currentWelcomeMessage;
  final List<String> welcomeMessages = [
    "Alors, ça travaille bien ?",
    "Bientôt les vacances !",
    "Plus que quelques notes !",
    "Allez, quelques derniers efforts !"
  ];
  
  // Helpers //
  void openProfileScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (_) => AppData.instance.connectedAccount,
          builder: (context, child) => const ProfileScreen(),
        ),
      ),
    );
  }

  void openChangePeriodPopup() {
    showModalBottomSheet(
      context: context,
      builder: (context) => const ChangePeriodPopup(),
      backgroundColor: Colors.transparent,
    );
  }

  void openGeneralAveragePopup() {
    showModalBottomSheet(
      context: context,
      builder: (context) => const GeneralAveragePopup(),
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Set the scale of the app //
    Styles.setScale(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFECECEC),
      body: Consumer<AppData>(
        builder: (context, appData, child) => RefreshIndicator(
          onRefresh: () async {
            // Update the UI as well //
            appData.updateUI = false;
            appData.displayedAccount.parseGrades().then((value) {
              appData.updateUI = true;
              if (!appData.displayedAccount.isConnectedAccount) {
                CacheHandler.saveAllCache(appData.connectedAccount.toCache(false));
              }
            });
          },
          child: ListView(
            padding: EdgeInsets.only(left: 20.0 * Styles.scale, right: 20.0 * Styles.scale, top: (MediaQuery.of(context).padding.top + 10.0) * Styles.scale, bottom: (MediaQuery.of(context).padding.bottom + 10.0) * Styles.scale),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 60.0 * Styles.scale,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - (120 * Styles.scale),
                          child: Text(appData.connectedAccount.isConnected ? "Bonjour ${appData.connectedAccount.firstName} !" : appData.connectedAccount.isConnecting ? "Connexion..." : "Vous n'êtes pas connecté", style: TextStyle(
                            fontSize: 20.0 * Styles.scale,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Montserrat"
                          ), overflow: TextOverflow.fade, maxLines: 1, softWrap: false),
                        ),
                        Gap(5.0 * Styles.scale),
                        Text(appData.connectedAccount.isConnected ? currentWelcomeMessage : "Connectez vous sur votre profil", style: TextStyle(
                          fontSize: 17.0 * Styles.scale,
                          color: Colors.black54,
                          fontFamily: "Montserrat"
                        )),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => openProfileScreen(context),
                    child: Container(
                      width: 60.0 * Styles.scale,
                      height: 60.0 * Styles.scale,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEFEFE),
                        borderRadius: BorderRadius.all(Radius.circular(10.0 * Styles.scale)),
                      ),
                      child: Center(
                        child: Icon(
                          FluentIcons.person_24_filled,
                          size: 40.0 * Styles.scale,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Gap(20.0 * Styles.scale),
              appData.connectedAccount.type == "E"
                ? Container()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 40.0 * Styles.scale,
                        child: Text(appData.displayedAccount.id == appData.connectedAccount.id ? "Choisissez un compte sur votre profil" : "Voici les notes de ${appData.displayedAccount.firstName} :", style: TextStyle(
                          fontSize: 20.0 * Styles.scale,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Montserrat",
                        ), overflow: TextOverflow.fade, maxLines: 1, softWrap: false),
                      ),
                      Gap(20.0 * Styles.scale),
                  ],
                ),
              Container(
                padding: EdgeInsets.all(20.0 * Styles.scale),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEFEFE),
                  borderRadius: BorderRadius.all(Radius.circular(20.0 * Styles.scale)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: openChangePeriodPopup,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(appData.displayedAccount.gotGrades ? appData.displayedAccount.periods[appData.displayedAccount.selectedPeriod]!.title : "--", style: TextStyle(
                            fontSize: 18.0 * Styles.scale,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.bold,
                          )),
                          appData.displayedAccount.isGettingGrades ? const LoadingAnimation() : Icon(FluentIcons.settings_24_filled, size: 25.0 * Styles.scale),
                        ],
                      ),
                    ),
                    Gap(30.0 * Styles.scale),
                    GestureDetector(
                      onTap: openGeneralAveragePopup,
                      child: Center(
                        child: Column(
                          children: [
                            Text(appData.displayedAccount.gotGrades ? appData.displayedAccount.periods[appData.displayedAccount.selectedPeriod]!.showableAverage : "--", style: TextStyle(
                              fontSize: 34.0 * Styles.scale,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Bitter",
                            )),
                            Text("MOYENNE GÉNÉRALE", style: TextStyle(
                              fontSize: 15.0 * Styles.scale,
                              color: Colors.black54,
                              fontFamily: "Montserrat",
                            )),
                          ],
                        ),
                      ),
                    ),
                    Gap(30.0 * Styles.scale),
                    Text("Dernières notes", style: TextStyle(
                      fontSize: 18.0 * Styles.scale,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat",
                    )),
                    Gap(10.0 * Styles.scale),
                    SizedBox(
                      width: double.infinity,
                      height: 80.0 * Styles.scale,
                      child: appData.displayedAccount.gotGrades ? ListView.separated(
                        itemCount: min(15, appData.displayedAccount.periods[appData.displayedAccount.selectedPeriod]!.grades.length),
                        itemBuilder: (context, index) => GradeCard(grade: appData.displayedAccount.periods[appData.displayedAccount.selectedPeriod]!.grades[appData.displayedAccount.periods[appData.displayedAccount.selectedPeriod]!.grades.length - index - 1]),
                        separatorBuilder: (context, index) => Gap(15.0 * Styles.scale),
                        scrollDirection: Axis.horizontal,
                        key: PageStorageKey<String>("${appData.displayedAccount.selectedPeriod}-last_grades"),
                      ) : Center(
                        child: Text("--", style: TextStyle(
                          fontSize: 18.0 * Styles.scale,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Montserrat",
                        )),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(20.0 * Styles.scale),
              Container(
                padding: EdgeInsets.all(20.0 * Styles.scale),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEFEFE),
                  borderRadius: BorderRadius.all(Radius.circular(20.0 * Styles.scale)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Moyennes par matière", style: TextStyle(
                      fontSize: 18.0 * Styles.scale,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat",
                    )),
                    Gap(20.0 * Styles.scale),
                    appData.displayedAccount.gotGrades ? Column(
                      children: List.generate(
                        appData.displayedAccount.periods[appData.displayedAccount.selectedPeriod]!.subjects.length,
                        (index) => Column(
                          children: [
                            SubjectCard(subject: appData.displayedAccount.periods[appData.displayedAccount.selectedPeriod]!.subjects.values.elementAt(index), isRecusive: false),
                            Gap(index == appData.displayedAccount.periods[appData.displayedAccount.selectedPeriod]!.subjects.length - 1 ? 0 : 20.0 * Styles.scale),
                          ],
                        ),
                      ),
                    ) : Center(
                      child: Text("--", style: TextStyle(
                        fontSize: 18.0 * Styles.scale,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat",
                      )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}