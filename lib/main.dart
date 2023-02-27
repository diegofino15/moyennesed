import 'package:flutter/material.dart';
import 'package:moyennesed/ui/global_provider.dart';
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
      home: ChangeNotifierProvider(
        create: (_) => GlobalProvider.instance,
        builder: (context, child) => Container(key: MainAppKey.globalKey, child: const HomeScreen()),
      ),
    );
  }
}



