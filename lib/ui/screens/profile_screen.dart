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
        height: 155.0 * Styles.scale_,
        padding: EdgeInsets.all(20.0 * Styles.scale_),
        decoration: BoxDecoration(
          color: Styles.backgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0 * Styles.scale_)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Se déconnecter ?", style: Styles.sectionTitleTextStyle),
            Gap(10.0 * Styles.scale_),
            Text("Vos identifiants de connexion seront oubliés.", style: Styles.itemTextStyle),
            Gap(10.0 * Styles.scale_),
            OutlinedButton(
              onPressed: () {
                NetworkHandler.disconnect();
                Navigator.of(context).pop();
              },
              child: SizedBox(width: MediaQuery.of(context).size.width, height: 20 * Styles.scale_, child: Center(child: Text("Confirmer", style: Styles.itemTextStyle.copyWith(color: Colors.red)))),
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
            padding: EdgeInsets.symmetric(horizontal: 20.0 * Styles.scale_),
            child: ListView(
              children: [
                Gap(10.0 * Styles.scale_),
                BoxWidget(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => { if (mounted) { Navigator.of(context).maybePop() } },
                        child: Icon(FluentIcons.arrow_left_24_filled, size: 25.0 * Styles.scale_, color: Styles.getColor("mainText")),
                      ),
                      Text("Profil", style: Styles.pageTitleTextStyle),
                      GestureDetector(
                        onTap: () {
                          GlobalProvider.instance.isDarkMode = !GlobalProvider.instance.isDarkMode;
                          FileHandler.instance.changeInfos({"isDarkMode": GlobalProvider.instance.isDarkMode});
                        },
                        child: Icon(GlobalProvider.instance.isDarkMode ? FluentIcons.weather_moon_24_filled : FluentIcons.weather_sunny_24_filled, size: 25.0 * Styles.scale_, color: Styles.getColor("mainText")),
                      ),
                    ],
                  ),
                ),
                Gap(20.0 * Styles.scale_),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60.0 * Styles.scale_,
                  padding: EdgeInsets.all(20.0 * Styles.scale_),
                  decoration: BoxDecoration(
                    color: provider.isConnected ? Colors.green : provider.isConnecting ? Colors.blue : Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(20.0 * Styles.scale_)),
                  ),
                  child: Text(provider.isConnected ? "Vous êtes connecté${StudentInfos.gender == "M" ? "" : "e"} !" : provider.isConnecting ? "Connexion..." : "Vous êtes déconnecté", style: Styles.sectionTitleTextStyle.copyWith(color: Colors.white)),
                ),
                Gap(provider.isConnected ? 20.0 * Styles.scale_ : 0.0),
                provider.isConnected
                  ? BoxWidget(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: MediaQuery.of(context).size.width - 150 * Styles.scale_, child: Text(StudentInfos.fullName, style: Styles.itemTitleTextStyle, overflow: TextOverflow.ellipsis)),
                              Gap(5.0 * Styles.scale_),
                              Text(StudentInfos.level, style: Styles.itemTextStyle),
                            ],
                          ),
                          SizedBox(
                            width: 50.0 * Styles.scale_,
                            height: 50.0 * Styles.scale_,
                            child: MaterialButton(
                              onPressed: () => handleDisconnectPopup(context),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0 * Styles.scale_)),
                              ),
                              color: Colors.red,
                              child: Center(child: Icon(FeatherIcons.logOut, size: 20.0 * Styles.scale_, color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
                Gap(provider.isConnected ? 20.0 * Styles.scale_ : 0.0),
                provider.isConnected
                  ? BoxWidget(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Paramètres", style: Styles.sectionTitleTextStyle),
                          Gap(10.0 * Styles.scale_),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Coefficients matières (2nde)", style: Styles.itemTextStyle),
        
                              GestureDetector(
                                onTap: () => setState(() {
                                  ModifiableInfos.useSubjectCoefficients = !ModifiableInfos.useSubjectCoefficients;
                                  ModifiableInfos.save();
                                }),
                                child: Icon(ModifiableInfos.useSubjectCoefficients ? FluentIcons.checkbox_checked_24_filled : FluentIcons.checkbox_unchecked_24_regular, size: 25.0 * Styles.scale_, color: Styles.getColor("mainText"))
                              ),
                            ],
                          ),
                          Gap(10.0 * Styles.scale_),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Devine coefficient notes", style: Styles.itemTextStyle),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => handleExperimentalFeaturesPopup(context),
                                    child: Icon(FluentIcons.info_24_regular, size: 20.0 * Styles.scale_, color: Colors.grey),
                                  ),
                                  Gap(5.0 * Styles.scale_),
                                  GestureDetector(
                                    onTap: () => setState(() {
                                      ModifiableInfos.guessGradeCoefficient = !ModifiableInfos.guessGradeCoefficient;
                                      ModifiableInfos.save();
                                    }),
                                    child: Icon(ModifiableInfos.guessGradeCoefficient ? FluentIcons.checkbox_checked_24_filled : FluentIcons.checkbox_unchecked_24_regular, size: 25.0 * Styles.scale_, color: Styles.getColor("mainText"))
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : Container(),
                Gap(provider.isUserLoggedIn || provider.isConnecting ? 0.0 : 20.0 * Styles.scale_),
                provider.isUserLoggedIn || provider.isConnecting
                  ? Container()
                  : BoxWidget(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Se connecter", style: Styles.sectionTitleTextStyle),
                        Gap(20.0 * Styles.scale_),
                        Text("Entrez vos informations EcoleDirecte", style: Styles.itemTextStyle),
                        Gap(10.0 * Styles.scale_),
                        Input(
                          placeholder: "Identifiant",
                          initialValue: NetworkHandler.loginUsername,
                          hideText: false,
                          changeValueFunction: (value) => { NetworkHandler.loginUsername = value },
                          submitFunction: (value) => { NetworkHandler.loginUsername = value },
                        ),
                        Gap(10.0 * Styles.scale_),
                        Input(
                          placeholder: "Mot de passe",
                          initialValue: "",
                          hideText: true,
                          changeValueFunction: (value) => { NetworkHandler.loginPassword = value },
                          submitFunction: (value) => handleConnect(),
                        ),
                        Gap(10.0 * Styles.scale_),
                        Button(
                          height: 60.0 * Styles.scale_,
                          color: Colors.green,
                          onPressed: handleConnect,
                          child: Text("Se connecter", style: Styles.sectionTitleTextStyle.copyWith(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                Gap(20.0 * Styles.scale_),
                BoxWidget(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 30.0 * Styles.scale_, height: 15.0 * Styles.scale_, child: Image.asset("assets/images/logoEcoleDirecte.png", fit: BoxFit.fill)),
                          Gap(10.0 * Styles.scale_),
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
                        child: Icon(FluentIcons.arrow_right_24_filled, size: 25.0 * Styles.scale_, color: Styles.getColor("mainText")),
                      ),
                    ],
                  ),
                ),
                Gap(provider.gotNetworkConnection ? 0.0 : 20.0 * Styles.scale_),
                provider.gotNetworkConnection
                  ? Container()
                  : BoxWidget(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(FluentIcons.wifi_off_24_filled, size: 25.0 * Styles.scale_, color: Colors.red),
                            Gap(10.0 * Styles.scale_),
                            Text("Pas de connexion internet", style: Styles.sectionTitleTextStyle)
                          ],
                        ),
                        Gap(20.0 * Styles.scale_),
                        Button(
                          height: 60.0 * Styles.scale_,
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