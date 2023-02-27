import 'package:moyennesed/core/infos.dart';

String formatDouble(double val) {
  return val.toStringAsFixed(2).replaceAll(".", ",");
}

const List<String> daysNames = [
  "",
  "Lundi",
  "Mardi",
  "Mercredi",
  "Jeudi",
  "Vendredi",
  "Samedi",
  "Dimanche"
];
const List<String> monthsNames = [
  "",
  "Janvier",
  "Février",
  "Mars",
  "Avril",
  "Mai",
  "Juin",
  "Juillet",
  "Aout",
  "Septembre",
  "Octobre",
  "Novembre",
  "Décembre"
];

String formatDate(DateTime date) {
  return "${daysNames[date.weekday]} ${date.day} ${monthsNames[date.month]}";
}

List<String> welcomeMessages = [
  "Ça fait plaisir de vous revoir !",
  "Alors, ça travaille bien ?",
  "Continuez comme ça !",
  "Bon travail tout ça !",
  "Bientôt les vacances !",
  "Plus que quelques contrôles !",
  "C'est dûr la ${StudentInfos.level.toLowerCase()} !"
];


