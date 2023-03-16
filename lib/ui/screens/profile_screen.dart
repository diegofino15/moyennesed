import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:moyennesed/core/handlers/file_handler.dart';
import 'package:moyennesed/core/handlers/grades_handler.dart';
import 'package:moyennesed/ui/global_provider.dart';
import 'package:moyennesed/ui/styles.dart';
import 'package:moyennesed/ui/widgets/box_widget.dart';
import 'package:moyennesed/ui/widgets/input.dart';
import 'package:moyennesed/ui/widgets/button.dart';
import 'package:moyennesed/ui/widgets/experimental_features_popup.dart';
import 'package:moyennesed/core/infos.dart';
import 'package:moyennesed/core/handlers/network_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void handleConnect() {
    NetworkHandler.connect().then((value) {
      if (GlobalProvider.instance.isUserLoggedIn && GlobalProvider.instance.gotNetworkConnection) {
        GlobalProvider.instance.gotGrades = false;
        GradesHandler.getGrades();
        // Caused black screen problems //
        // if (mounted) { Navigator.of(context, rootNavigator: true).maybePop(); }
      }
    });
  }

  void handleDisconnectPopup(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (_) => Container(
        height: 150.0,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Styles.backgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Se déconnecter ?", style: Styles.sectionTitleTextStyle),
            const Gap(10.0),
            Text("Vos identifiants de connexion seront oubliés.", style: Styles.itemTextStyle),
            const Gap(10.0),
            OutlinedButton(
              onPressed: () {
                NetworkHandler.disconnect();
                Navigator.of(context).pop();
              },
              child: SizedBox(width: MediaQuery.of(context).size.width, child: Center(child: Text("Confirmer", style: Styles.itemTextStyle.copyWith(color: Colors.red)))),
            ),
          ],
        ),
      ),
    );
  }

  void handleExperimentalFeaturesPopup(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => const ExperimentalFeaturesPopup(),
    );
  }

  @override
  Widget build(BuildContext widgetBuildContext) {
    return Consumer<GlobalProvider>(
      builder: (context, provider, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: provider.isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: Styles.backgroundColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView(
              children: [
                const Gap(10.0),
                BoxWidget(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => { if (mounted) { Navigator.of(context).maybePop() } },
                        child: Icon(FluentIcons.arrow_left_24_filled, size: 25.0, color: Styles.getColor("mainText")),
                      ),
                      Text("Profil", style: Styles.pageTitleTextStyle),
                      GestureDetector(
                        onTap: () {
                          GlobalProvider.instance.isDarkMode = !GlobalProvider.instance.isDarkMode;
                          FileHandler.instance.changeInfos({"isDarkMode": GlobalProvider.instance.isDarkMode});
                        },
                        child: Icon(GlobalProvider.instance.isDarkMode ? FluentIcons.weather_moon_24_filled : FluentIcons.weather_sunny_24_filled, size: 25.0, color: Styles.getColor("mainText")),
                      ),
                    ],
                  ),
                ),
                const Gap(20.0),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60.0,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: provider.isConnected ? Colors.green : provider.isConnecting ? Colors.blue : Colors.red,
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Text(provider.isConnected ? "Vous êtes connecté${StudentInfos.gender == "M" ? "" : "e"} !" : provider.isConnecting ? "Connexion..." : "Vous êtes déconnecté", style: Styles.sectionTitleTextStyle.copyWith(color: Colors.white)),
                ),
                Gap(provider.isConnected ? 20.0 : 0.0),
                provider.isConnected
                  ? BoxWidget(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: MediaQuery.of(context).size.width - 150, child: Text(StudentInfos.fullName, style: Styles.itemTitleTextStyle, overflow: TextOverflow.ellipsis)),
                              const Gap(5.0),
                              Text(StudentInfos.level, style: Styles.itemTextStyle),
                            ],
                          ),
                          SizedBox(
                            width: 50.0,
                            height: 50.0,
                            child: MaterialButton(
                              onPressed: () => handleDisconnectPopup(context),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              color: Colors.red,
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(FeatherIcons.logOut, size: 20.0, color: Colors.white)]),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
                Gap(provider.isConnected ? 20.0 : 0.0),
                provider.isConnected
                  ? BoxWidget(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Béta", style: Styles.sectionTitleTextStyle),
                          const Gap(10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Coefficients matières (2nde)", style: Styles.itemTextStyle),
        
                              GestureDetector(
                                onTap: () => setState(() {
                                  ModifiableInfos.useSubjectCoefficients = !ModifiableInfos.useSubjectCoefficients;
                                  ModifiableInfos.save();
                                }),
                                child: Icon(ModifiableInfos.useSubjectCoefficients ? FluentIcons.checkbox_checked_24_filled : FluentIcons.checkbox_unchecked_24_regular, color: Styles.getColor("mainText"))
                              ),
                            ],
                          ),
                          const Gap(10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Devine coefficient notes", style: Styles.itemTextStyle),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => handleExperimentalFeaturesPopup(context),
                                    child: const Icon(FluentIcons.info_24_regular, size: 20.0, color: Colors.grey),
                                  ),
                                  const Gap(5.0),
                                  GestureDetector(
                                    onTap: () => setState(() {
                                      ModifiableInfos.guessGradeCoefficient = !ModifiableInfos.guessGradeCoefficient;
                                      ModifiableInfos.save();
                                    }),
                                    child: Icon(ModifiableInfos.guessGradeCoefficient ? FluentIcons.checkbox_checked_24_filled : FluentIcons.checkbox_unchecked_24_regular, color: Styles.getColor("mainText"))
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : Container(),
                Gap(provider.isConnected ? 20.0 : 0.0),
                provider.isConnected
                  ? BoxWidget(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 30.0, height: 15.0, child: Image.asset("assets/images/logoEcoleDirecte.png", fit: BoxFit.fill)),
                              const Gap(10.0),
                              Text("Site officiel EcoleDirecte", style: Styles.itemTitleTextStyle),
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (await canLaunchUrl(Uri.parse("https://www.ecoledirecte.com/"))) {
                                await launchUrl(Uri.parse("https://www.ecoledirecte.com/"));
                              } else {
                                print("Unable to launch URL");
                              }
                            },
                            child: Icon(FluentIcons.arrow_right_24_filled, size: 25.0, color: Styles.getColor("mainText")),
                          ),
                        ],
                      ),
                    )
                  : Container(),
                Gap(provider.isUserLoggedIn || provider.isConnecting ? 0.0 : 20.0),
                provider.isUserLoggedIn || provider.isConnecting
                  ? Container()
                  : BoxWidget(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Se connecter", style: Styles.sectionTitleTextStyle),
                        const Gap(20.0),
                        Text("Entrez vos informations EcoleDirecte", style: Styles.itemTextStyle),
                        const Gap(10.0),
                        Input(
                          placeholder: "Identifiant",
                          initialValue: NetworkHandler.loginUsername,
                          hideText: false,
                          changeValueFunction: (value) => { NetworkHandler.loginUsername = value },
                          submitFunction: (value) => { NetworkHandler.loginUsername = value },
                        ),
                        const Gap(10.0),
                        Input(
                          placeholder: "Mot de passe",
                          initialValue: "",
                          hideText: true,
                          changeValueFunction: (value) => { NetworkHandler.loginPassword = value },
                          submitFunction: (value) => handleConnect(),
                        ),
                        const Gap(10.0),
                        Button(
                          height: 60.0,
                          color: Colors.green,
                          onPressed: handleConnect,
                          child: Text("Se connecter", style: Styles.sectionTitleTextStyle.copyWith(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                Gap(provider.gotNetworkConnection ? 0.0 : 20.0),
                provider.gotNetworkConnection
                  ? Container()
                  : BoxWidget(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(FluentIcons.wifi_off_24_filled, size: 25.0, color: Colors.red),
                            const Gap(10.0),
                            Text("Pas de connexion internet", style: Styles.sectionTitleTextStyle)
                          ],
                        ),
                        const Gap(20.0),
                        Button(
                          height: 60.0,
                          color: Colors.blue,
                          onPressed: GradesHandler.getGrades,
                          child: Text(GlobalProvider.instance.isConnecting || GlobalProvider.instance.isGettingGrades ? "Chargement..." : "Rééssayer", style: Styles.sectionTitleTextStyle.copyWith(color: Colors.white)),
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