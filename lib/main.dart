import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moyennesed/ui/components/sidebar.dart';
import 'package:provider/provider.dart';
import 'package:moyennesed/ui/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:moyennesed/firebase_options.dart';
import 'package:moyennesed/core/app_data.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init firebase app //
  await Firebase.initializeApp(
    name: "MoyennesED",
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: SideBar() /* ChangeNotifierProvider(
          create: (_) => AppData.instance,
          builder: (context, child) => const HomeScreen(),
        ),*/, 
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
