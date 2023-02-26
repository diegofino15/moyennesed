import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moyennesed/ui/global_provider.dart';
import 'package:moyennesed/ui/styles.dart';
import 'package:moyennesed/ui/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MoyennesED());
}

class MoyennesED extends StatelessWidget {
  const MoyennesED({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: Styles.backgroundColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ChangeNotifierProvider(
              create: (_) => GlobalProvider.instance,
              builder: (context, child) => Container(
                key: MainAppKey.globalKey,
                child: const HomeScreen(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



