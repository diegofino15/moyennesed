import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moyennesed/core/infos.dart';
import 'package:moyennesed/core/handlers/network_handler.dart';
import 'package:moyennesed/ui/global_provider.dart';

// This class gives the app all the necessary paths to parse data from EcoleDirecte //
class NetworkUtils {
  static late String connectionToken;

  static const String baseUrl = "https://api.ecoledirecte.com/v3";

  static const String loginUrl = "$baseUrl/login.awp?v=4.27.1";
  static String get gradesURL => "$baseUrl/eleves/${StudentInfos.id}/notes.awp?verbe=get";

  static String formatPayload(Map payload) => 'data=${jsonEncode(payload)}';
  static Future<dynamic> parse(String url, Map payload) async {
    try {
      http.Response encodedResponse = await http.post(
        Uri.parse(url),
        body: NetworkUtils.formatPayload(payload),
        headers: {"x-token": connectionToken, "user-agent": "Mozilla/5.0"}
      );
      Map response = jsonDecode(utf8.decode(encodedResponse.bodyBytes));

      GlobalProvider.instance.gotNetworkConnection = true;
      if (response["code"] == responseSuccess) { return response["data"]; }
      else if (response["code"] == responseOutdatedToken) {
        await NetworkHandler.connect();
        if (GlobalProvider.instance.isConnected) {
          return parse(url, payload);
        }
      } else { return null; }
    } catch (e) {
      GlobalProvider.instance.gotNetworkConnection = false;
      GlobalProvider.instance.isConnected = false;
      print("An error occured when connecting to : $url");
      return null;
    }
  }

  // All the possible responses from EcoleDirecte //
  static const int responseSuccess = 200;
  static const int responseFail = 505;
  static const int responseOutdatedToken = 525;
  static const int responseInvalidToken = 520;
}