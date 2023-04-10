import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moyennesed/core/infos.dart';
import 'package:moyennesed/core/handlers/network_utils.dart';
import 'package:moyennesed/core/handlers/file_handler.dart';
import 'package:moyennesed/core/handlers/cache_handler.dart';
import 'package:moyennesed/ui/providers/styles_provider.dart';
import 'package:moyennesed/ui/providers/grades_provider.dart';
import 'package:moyennesed/ui/providers/login_provider.dart';

// This class is used to connect to EcoleDirecte and get the connection token //
class NetworkHandler {
  static String loginUsername = "";
  static String loginPassword = "";

  static Future<void> connect() async {
    if (LoginProvider.instance.isConnecting) { return; }
    if (loginUsername.isEmpty || loginPassword.isEmpty) { return; }

    // Demo account //
    if (loginUsername == DemoAccount.demoAccountInfos["username"] && loginPassword == DemoAccount.demoAccountInfos["password"]) {
      LoginProvider.instance.isConnected = true;
      LoginProvider.instance.isUserLoggedIn = true;
      LoginProvider.instance.gotNetworkConnection = true;
      StudentInfos.saveLoginData(DemoAccount.demoAccountInfos);
      await FileHandler.instance.changeInfos({
        "username": loginUsername,
        "password": loginPassword,
        "isUserLoggedIn": true
      });
      return;
    }

    LoginProvider.instance.isConnected = false;
    LoginProvider.instance.isConnecting = true;

    print("Connection...");

    Map<String, String> payload = <String, String>{
      "identifiant": loginUsername,
      "motdepasse": loginPassword
    };

    try {
      http.Response encodedLoginResponse = await http.post(
        Uri.parse(NetworkUtils.loginUrl),
        body: NetworkUtils.formatPayload(payload),
        headers: {"user-agent": "Mozilla/5.0"}
      );
      Map loginResponse = jsonDecode(utf8.decode(encodedLoginResponse.bodyBytes));
      
      if (loginResponse["code"] == NetworkUtils.responseSuccess) {
        NetworkUtils.connectionToken = loginResponse["token"];

        StudentInfos.saveLoginData(loginResponse["data"]["accounts"][0]);

        await FileHandler.instance.changeInfos({
          "username": loginUsername,
          "password": loginPassword,
          "isUserLoggedIn": true
        });

        LoginProvider.instance.isConnected = true;
        LoginProvider.instance.isUserLoggedIn = true;
        print("Connected !");
      } else {
        loginPassword = "";
        LoginProvider.instance.isUserLoggedIn = false;
      }
      LoginProvider.instance.gotNetworkConnection = true;
    } catch (e) {
      LoginProvider.instance.gotNetworkConnection = false;
      print("An error occured while connecting.");
      print("Error : $e");
    }

    LoginProvider.instance.isConnecting = false;
  }

  static void disconnect() {
    NetworkHandler.loginUsername = "";
    NetworkHandler.loginPassword = "";
    LoginProvider.instance.isUserLoggedIn = false;
    LoginProvider.instance.isConnected = false;

    GradesProvider.instance.gotGrades = false;
    GradesProvider.instance.isGettingGrades = false;
    GlobalInfos.periods.clear();

    FileHandler.instance.writeInfos({});
    CacheHandler.saveAllCache({});
  }

  static Future<void> autoLogin() async {
    Map savedData = await FileHandler.instance.readInfos();

    loginUsername = savedData["username"] ?? "";
    loginPassword = savedData["password"] ?? "";
    LoginProvider.instance.isUserLoggedIn = savedData["isUserLoggedIn"] ?? false;
    StylesProvider.instance.isDarkMode = savedData["isDarkMode"] ?? false;

    ModifiableInfos.guessGradeCoefficient = savedData["guessGradeCoef"] ?? true;
    ModifiableInfos.useSubjectCoefficients = savedData["useSubjectCoef"] ?? true;
    await connect();
  }
}