import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:moyennesed/core/app_data.dart';
import 'package:moyennesed/ui/styles.dart';
import 'package:rive/rive.dart';


class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 280.0 * Styles.scale,
        height: double.infinity,
        color: const Color(0xFF171D32),
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: Icon(FluentIcons.person_24_filled, color: Colors.white),
                ),
                title: Text(
                  AppData.instance.connectedAccount.isLoggedIn ? AppData.instance.connectedAccount.fullName : "Pas connecté.e",
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  AppData.instance.connectedAccount.isLoggedIn ? AppData.instance.connectedAccount.levelName : "--",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              ListTile(
                leading: SizedBox(
                  width: 34.0 * Styles.scale,
                  height: 34.0 * Styles.scale,
                  child: RiveAnimation.asset(
                    "assets/rive/icons.riv",
                    artboard: "HOME",
                    onInit: (artboard) {},
                  ),
                ),
                title: const Text(
                  "Notes & Moyennes",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}