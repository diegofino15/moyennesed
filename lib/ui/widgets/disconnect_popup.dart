import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:moyennesed/ui/styles.dart';
import 'package:moyennesed/core/app_data.dart';


class DisconnectPopup extends StatelessWidget {
  const DisconnectPopup({super.key});

  void disconnect(BuildContext context) {
    AppData.instance.disconnect();
    AppData.instance.updateUI = true;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230.0 * Styles.scale,
      padding: EdgeInsets.all(20.0 * Styles.scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0 * Styles.scale)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Se déconnecter", style: TextStyle(
            fontSize: 20.0 * Styles.scale,
            fontWeight: FontWeight.bold,
            fontFamily: "Montserrat",
          )),
          Gap(20.0 * Styles.scale),
          Text("Voulez-vous vraiment vous déconnecter ? Vos identifiant de connexion seront oubliés.", style: TextStyle(
            fontSize: 17.0 * Styles.scale,
            color: Colors.black54,
            fontFamily: "Montserrat",
          )),
          Gap(20.0 * Styles.scale),
          GestureDetector(
            onTap: () => disconnect(context),
            child: Container(
              padding: EdgeInsets.all(20.0 * Styles.scale),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(10.0 * Styles.scale)),
              ),
              child: Center(
                child: Text(
                  "Se déconnecter",
                  style: TextStyle(
                    fontSize: 18.0 * Styles.scale,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}