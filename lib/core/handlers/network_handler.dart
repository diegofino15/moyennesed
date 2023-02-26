import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moyennesed/core/infos.dart';
import 'package:moyennesed/core/handlers/network_utils.dart';
import 'package:moyennesed/core/handlers/file_handler.dart';
import 'package:moyennesed/core/handlers/cache_handler.dart';
import 'package:moyennesed/ui/global_provider.dart';
import 'package:provider/provider.dart';

// This class is used to connect to EcoleDirecte and get the connection token //
class NetworkHandler {
  static String loginUsername = "";
  static String loginPassword = "";

  static Future<void> connect() async {
    GlobalProvider provider = Provider.of<GlobalProvider>(MainAppKey.globalKey.currentContext!, listen: false);
    
    if (provider.isConnecting) { return; }
    if (loginUsername.isEmpty || loginPassword.isEmpty) { return; }

    provider.isConnected = false;
    provider.isConnecting = true;

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

        provider.isConnected = true;
        provider.isUserLoggedIn = true;
        print("Connected !");
      } else {
        loginPassword = "";
        provider.isUserLoggedIn = false;
      }
      provider.gotNetworkConnection = true;
    } catch (e) {
      provider.gotNetworkConnection = false;
      print("An error occured while connecting.");
      print("Error : $e");
    }

    provider.isConnecting = false;
  }

  static void disconnect() {
    GlobalProvider provider = Provider.of<GlobalProvider>(MainAppKey.globalKey.currentContext!, listen: false);
    
    NetworkHandler.loginUsername = "";
    NetworkHandler.loginPassword = "";
    provider.isUserLoggedIn = false;
    provider.isConnected = false;

    provider.gotGrades = false;
    provider.isGettingGrades = false;
    GlobalInfos.periods.clear();

    FileHandler.instance.writeInfos({});
    CacheHandler.saveAllCache({});
  }

  static Future<void> autoLogin() async {
    Map savedData = await FileHandler.instance.readInfos();

    loginUsername = savedData["username"] ?? "";
    loginPassword = savedData["password"] ?? "";
    Provider.of<GlobalProvider>(MainAppKey.globalKey.currentContext!, listen: false).isUserLoggedIn = savedData["isUserLoggedIn"] ?? false;

    ModifiableInfos.guessGradeCoefficient = savedData["guessgradecoef"] ?? true;
    ModifiableInfos.useSubjectCoefficients = savedData["usesubjectcoef"] ?? true;
    await connect();
  }
}