import 'package:flutter/material.dart';
import 'package:moyennesed/ui/global_provider.dart';
import 'package:moyennesed/ui/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MoyennesED());
}

class MoyennesED extends StatelessWidget {
  MoyennesED({super.key});

  final GlobalKey globalKey_ = GlobalKey();
  GlobalKey get globalKey => globalKey_;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider(
        create: (_) => GlobalProvider.instance,
        builder: (context, child) => Container(key: globalKey, child: const HomeScreen()),
      ),
    );
  }
}



