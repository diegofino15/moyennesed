import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moyennesed/core/infos.dart';
import 'package:moyennesed/core/handlers/network_utils.dart';
import 'package:moyennesed/core/handlers/file_handler.dart';
import 'package:moyennesed/core/handlers/cache_handler.dart';
import 'package:moyennesed/ui/global_provider.dart';
import 'package:moyennesed/ui/styles.dart';

// This class is used to connect to EcoleDirecte and get the connection token //
class NetworkHandler {
  static String loginUsername = "";
  static String loginPassword = "";

  static Future<void> connect() async {
    if (GlobalProvider.instance.isConnecting) { return; }
    if (loginUsername.isEmpty || loginPassword.isEmpty) { return; }

    GlobalProvider.instance.isConnected = false;
    GlobalProvider.instance.isConnecting = true;

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

        GlobalProvider.instance.isConnected = true;
        GlobalProvider.instance.isUserLoggedIn = true;
        print("Connected !");
      } else {
        loginPassword = "";
        GlobalProvider.instance.isUserLoggedIn = false;
      }
      GlobalProvider.instance.gotNetworkConnection = true;
    } catch (e) {
      GlobalProvider.instance.gotNetworkConnection = false;
      print("An error occured while connecting.");
      print("Error : $e");
    }

    GlobalProvider.instance.isConnecting = false;
  }

  static void disconnect() {
    NetworkHandler.loginUsername = "";
    NetworkHandler.loginPassword = "";
    GlobalProvider.instance.isUserLoggedIn = false;
    GlobalProvider.instance.isConnected = false;

    GlobalProvider.instance.gotGrades = false;
    GlobalProvider.instance.isGettingGrades = false;
    GlobalInfos.periods.clear();

    FileHandler.instance.writeInfos({});
    CacheHandler.saveAllCache({});
  }

  static Future<void> autoLogin() async {
    Map savedData = await FileHandler.instance.readInfos();

    loginUsername = savedData["username"] ?? "";
    loginPassword = savedData["password"] ?? "";
    GlobalProvider.instance.isUserLoggedIn = savedData["isUserLoggedIn"] ?? false;
    GlobalProvider.instance.isDarkMode = savedData["isDarkMode"] ?? false;

    ModifiableInfos.guessGradeCoefficient = savedData["guessgradecoef"] ?? true;
    ModifiableInfos.useSubjectCoefficients = savedData["usesubjectcoef"] ?? true;
    await connect();
  }
}