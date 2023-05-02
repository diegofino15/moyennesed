import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:moyennesed/ui/screens/home_screen.dart';
import 'package:moyennesed/core/app_data.dart';
import 'package:moyennesed/core/file_handler.dart';
import 'package:moyennesed/core/cache_handler.dart';
import 'package:moyennesed/core/objects/account.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init the AppData instance //
  AppData.instance.init();

  // Load the cache //
  Map<String, dynamic> cache = await CacheHandler.getAllCache();
  if (cache.isNotEmpty) {
    print("Found cache !");
    AppData.instance.connectedAccount.fromCache(cache);
    AppData.instance.accounts.clear();
    AppData.instance.accounts.addAll({"${AppData.instance.connectedAccount.id}": AppData.instance.connectedAccount});
    AppData.instance.displayedAccountID = "${AppData.instance.connectedAccount.id}";
    for (Account childAccount in AppData.instance.connectedAccount.childrenAccounts) {
      AppData.instance.accounts.addAll({"${childAccount.id}": childAccount});
      AppData.instance.displayedAccountID = "${childAccount.id}";
    }
  }

  // Auto-connect //
  Map cacheConnectionInfos = await FileHandler.instance.readInfos();
  if (cacheConnectionInfos["isUserLoggedIn"] ?? false) {
    AppData.instance.connectedAccount.loginUsername = cacheConnectionInfos["username"] ?? "";
    AppData.instance.connectedAccount.loginPassword = cacheConnectionInfos["password"] ?? "";
    AppData.instance.connectedAccount.login();

    AppData.instance.guessGradeCoefficients = cacheConnectionInfos["guessGradeCoefficients"] ?? true;
    AppData.instance.guessSubjectCoefficients = cacheConnectionInfos["guessSubjectCoefficients"] ?? true;
  } else {
    AppData.instance.disconnect();
  }

  // Run the app //
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: ChangeNotifierProvider(
          create: (_) => AppData.instance,
          builder: (context, child) => const HomeScreen(),
        ),
      )
    );
  }
}

/*
TODO:
  - Fix problems with big font size
  - Centralize all TextStyles and colors into a ThemeData
  - Create another ThemeData for dark mode
*/
