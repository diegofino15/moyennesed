import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:moyennesed/ui/styles.dart';
import 'package:moyennesed/ui/widgets/bug_report_popup.dart';
import 'package:moyennesed/ui/widgets/disconnect_popup.dart';
import 'package:moyennesed/ui/widgets/informations_popup.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:moyennesed/core/app_data.dart';
import 'package:moyennesed/core/file_handler.dart';
import 'package:moyennesed/core/cache_handler.dart';
import 'package:moyennesed/core/objects/account.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  late AnimationController loginAnimationController;
  late AnimationController errorAnimationController;
  bool showPassword = false;

  @override
  void initState() {
    super.initState();

    loginAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2)
    );
    loginAnimationController.forward();

    errorAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1)
    );
  }

  @override
  void dispose() {
    loginAnimationController.dispose();
    errorAnimationController.dispose();
    super.dispose();
  }

  void login() {
    AppData.instance.connectedAccount.login().then((value) {
      if (AppData.instance.connectedAccount.wrongPassword) {
        errorAnimationController.reset();
        errorAnimationController.forward();
      }
    });
  }
  
  void openBugReportingPopup() {
    showModalBottomSheet(
      context: context,
      builder: (context) => const BugReportPopup(),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  void openDisconnectPopup() {
    showModalBottomSheet(
      context: context,
      builder: (context) => const DisconnectPopup(),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  void openInformationsPopup() {
    showModalBottomSheet(
      context: context,
      builder: (context) => const InformationsPopup(),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  void openEcoleDirecte() async {
    if (await canLaunchUrl(Uri.parse("https://www.ecoledirecte.com/"))) {
      await launchUrl(
        Uri.parse("https://www.ecoledirecte.com/"),
        mode: LaunchMode.platformDefault,
        webViewConfiguration: const WebViewConfiguration(
          enableJavaScript: true,
          enableDomStorage: true,
        )
      );
    } else {
      print("Unable to launch URL");
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECECEC),
      body: Consumer<Account>(
        builder: (context, account, child) => ListView(
          padding: EdgeInsets.only(left: 20.0 * Styles.scale, right: 20.0 * Styles.scale, top: (MediaQuery.of(context).padding.top + 10.0) * Styles.scale, bottom: (MediaQuery.of(context).padding.bottom + 10.0) * Styles.scale),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 60.0 * Styles.scale,
                    height: 60.0 * Styles.scale,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEFEFE),
                      borderRadius: BorderRadius.all(Radius.circular(10.0 * Styles.scale)),
                    ),
                    child: Center(
                      child: Icon(
                        FluentIcons.arrow_left_24_filled,
                        size: 30.0 * Styles.scale,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 150.0 * Styles.scale,
                  height: 60.0 * Styles.scale,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEFEFE),
                    borderRadius: BorderRadius.all(Radius.circular(20.0 * Styles.scale)),
                  ),
                  child: Center(
                    child: Text("Profil", style: TextStyle(
                      fontSize: 22.0 * Styles.scale,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat",
                    )),
                  ),
                ),
                GestureDetector(
                  onTap: openBugReportingPopup,
                  child: Container(
                    width: 60.0 * Styles.scale,
                    height: 60.0 * Styles.scale,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEFEFE),
                      borderRadius: BorderRadius.all(Radius.circular(10.0 * Styles.scale)),
                    ),
                    child: Center(
                      child: Icon(
                        FluentIcons.bug_24_filled,
                        size: 30.0 * Styles.scale,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Gap(20.0 * Styles.scale),
            Container(
              padding: EdgeInsets.all(20.0 * Styles.scale),
              decoration: BoxDecoration(
                color: account.isConnected ? Colors.green : account.isConnecting ? Colors.blue : Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(20.0 * Styles.scale)),
              ),
              child: Text(account.isConnected ? "Vous êtes connecté${account.gender == "M" ? "" : "e"} !" : account.isConnecting ? "Connexion..." : "Vous n'êtes pas connecté !", style: TextStyle(
                fontSize: 20.0 * Styles.scale,
                fontWeight: FontWeight.bold,
                fontFamily: "Montserrat",
                color: Colors.white,
              )),
            ),
            account.isLoggedIn
            ? Column(
              children: [
                Gap(20.0 * Styles.scale),
                Container(
                  padding: EdgeInsets.all(20.0 * Styles.scale),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.0 * Styles.scale)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 150.0 * Styles.scale,
                            child: Text(account.fullName, style: TextStyle(
                              fontSize: 20.0 * Styles.scale,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Montserrat",
                            ), overflow: TextOverflow.fade, maxLines: 1, softWrap: false),
                          ),
                          Gap(5.0 * Styles.scale),
                          Text(account.type == "E" ? account.levelName : "Compte parent", style: TextStyle(
                            fontSize: 17.0 * Styles.scale,
                            fontFamily: "Montserrat",
                            color: Colors.black54,
                          )),
                        ],
                      ),
                      GestureDetector(
                        onTap: openDisconnectPopup,
                        child: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(10.0 * Styles.scale)),
                          ),
                          child: Center(
                            child: Icon(
                              FluentIcons.arrow_exit_20_filled,
                              size: 30.0 * Styles.scale,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                account.type != "E"
                ? Column(
                  children: List.generate(
                    account.childrenAccounts.length,
                    (index) => Column(
                      children: [
                        Gap(10.0 * Styles.scale),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 40.0 * Styles.scale,
                              height: 40.0 * Styles.scale,
                              child: Icon(FluentIcons.arrow_right_24_filled, size: 30.0 * Styles.scale),
                            ),
                            GestureDetector(
                              onTap: () => setState(() {
                                AppData.instance.displayedAccountID = "${account.childrenAccounts.elementAt(index).id}";
                                if (!AppData.instance.displayedAccount.gotGrades && !AppData.instance.displayedAccount.isGettingGrades) {
                                  AppData.instance.displayedAccount.parseGrades().then((value) => {
                                    CacheHandler.saveAllCache(account.toCache(false))
                                  });
                                }
                                AppData.instance.updateUI = true; // Update the UI //
                              }),
                              child: Container(
                                width: MediaQuery.of(context).size.width - 100.0 * Styles.scale,
                                padding: EdgeInsets.all(20.0 * Styles.scale),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(20.0 * Styles.scale)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width - 180.0 * Styles.scale,
                                      child: Text(account.childrenAccounts.elementAt(index).firstName, style: TextStyle(
                                        fontSize: 20.0 * Styles.scale,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Montserrat",
                                      ), overflow: TextOverflow.fade, maxLines: 1, softWrap: false),
                                    ),
                                    Icon(
                                      AppData.instance.displayedAccount.id == account.childrenAccounts.elementAt(index).id ? FluentIcons.checkmark_circle_24_filled : FluentIcons.circle_24_regular,
                                      size: 27.5 * Styles.scale,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
                : Container(),
                Gap(20.0 * Styles.scale),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.0 * Styles.scale),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.0 * Styles.scale)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Paramètres", style: TextStyle(
                            fontSize: 20.0 * Styles.scale,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Montserrat",
                          )),
                          GestureDetector(
                            onTap: openInformationsPopup,
                            child: Icon(FluentIcons.info_24_regular, color: Colors.grey, size: 27.5 * Styles.scale),
                          ),
                        ],
                      ),
                      Gap(10.0 * Styles.scale),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Devine coefficient notes", style: TextStyle(
                            fontSize: 16.0 * Styles.scale,
                            color: Colors.black54,
                            fontFamily: "Montserrat",
                          )),
                          GestureDetector(
                            onTap: () => setState(() {
                              AppData.instance.guessGradeCoefficients = !AppData.instance.guessGradeCoefficients;
                              FileHandler.instance.changeInfos({"guessGradeCoefficients": AppData.instance.guessGradeCoefficients});
                            }),
                            child: Icon(
                              AppData.instance.guessGradeCoefficients ? FluentIcons.checkbox_checked_24_filled : FluentIcons.checkbox_unchecked_24_filled,
                              size: 27.5 * Styles.scale,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Devine coefficient matières", style: TextStyle(
                            fontSize: 16.0 * Styles.scale,
                            color: Colors.black54,
                            fontFamily: "Montserrat",
                          )),
                          GestureDetector(
                            onTap: () => setState(() {
                              AppData.instance.guessSubjectCoefficients = !AppData.instance.guessSubjectCoefficients;
                              FileHandler.instance.changeInfos({"guessSubjectCoefficients": AppData.instance.guessSubjectCoefficients});
                            }),
                            child: Icon(
                              AppData.instance.guessSubjectCoefficients ? FluentIcons.checkbox_checked_24_filled : FluentIcons.checkbox_unchecked_24_filled,
                              size: 27.5 * Styles.scale,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
            : Column(
              children: [
                Gap(20.0 * Styles.scale),
                Container(
                  padding: EdgeInsets.all(20.0 * Styles.scale),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.0 * Styles.scale)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Lottie.asset(
                        "assets/lottie/login.json",
                        controller: loginAnimationController,
                        fit: BoxFit.contain,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFECECEC),
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(20.0 * Styles.scale)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.0 * Styles.scale),
                          child: TextField(
                            autocorrect: false,
                            onChanged: (value) => { account.loginUsername = value },
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Identifiant",
                            ),
                          ),
                        ),
                      ),
                      Gap(10.0 * Styles.scale),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFECECEC),
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(20.0 * Styles.scale)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.0 * Styles.scale),
                          child: Stack(
                            children: [
                              TextField(
                                autocorrect: false,
                                onChanged: (value) {
                                  account.loginPassword = value;
                                  if (account.wrongPassword) { account.wrongPassword = false; }
                                },
                                obscureText: !showPassword,
                                onSubmitted: (value) => login(),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Mot de passe",
                                ),
                              ),
                              Positioned(
                                right: 15 * Styles.scale,
                                top: 10 * Styles.scale,
                                child: GestureDetector(
                                  onTap: () => setState(() => showPassword = !showPassword ),
                                  child: account.wrongPassword
                                    ? SizedBox(
                                        width: 30.0 * Styles.scale,
                                        height: 30.0 * Styles.scale,
                                        child: Lottie.asset(
                                          "assets/lottie/error.json",
                                          controller: errorAnimationController,
                                        ),
                                      )
                                    : Icon(showPassword ? FluentIcons.eye_24_filled : FluentIcons.eye_off_24_filled, size: 30.0 * Styles.scale),
                                ),
                              ),
                            ]
                          ),
                        ),
                      ),
                      Gap(10.0 * Styles.scale),
                      GestureDetector(
                        onTap: login,
                        child: Container(
                          padding: EdgeInsets.all(20.0 * Styles.scale),
                          decoration: BoxDecoration(
                            color: const Color(0xFF798BFF),
                            borderRadius: BorderRadius.all(Radius.circular(10.0 * Styles.scale)),
                          ),
                          child: Center(
                            child: Text(
                              account.isConnecting ? "Connexion..." : "Se connecter",
                              style: TextStyle(
                                fontSize: 18.0 * Styles.scale,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gap(20.0 * Styles.scale),
            GestureDetector(
              onTap: openEcoleDirecte,
              child: Container(
                padding: EdgeInsets.all(20.0 * Styles.scale),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20.0 * Styles.scale)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 130.0 * Styles.scale,
                      child: Text("Site officiel EcoleDirecte", style: TextStyle(
                        fontSize: 20.0 * Styles.scale,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat",
                      ), overflow: TextOverflow.fade, maxLines: 1, softWrap: false),
                    ),
                    SizedBox(
                      width: 30.0 * Styles.scale,
                      height: 30.0 * Styles.scale,
                      child: Icon(FluentIcons.arrow_right_24_filled, size: 30.0 * Styles.scale),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}