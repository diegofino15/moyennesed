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
  await AppData.instance.loadCache();

  // Auto-connect //
  await AppData.instance.autoConnect();

  print("Finished initializing");

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
