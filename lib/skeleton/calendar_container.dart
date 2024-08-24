import 'package:flutter/material.dart';
import 'package:contrapp/main.dart';
import 'calendar.dart'; // Assurez-vous que le chemin est correct

class CalendarContainer extends StatefulWidget {
  const CalendarContainer({super.key});

  @override
  CalendarContainerState createState() => CalendarContainerState();
}

class CalendarContainerState extends State<CalendarContainer> {
  List<String> months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jui', 'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];

  @override
  void initState() {
    super.initState();
    for (var equip in equipPicked.equipList) {
      if (selectedCalendar[equip.equipName] == null) {
        selectedCalendar[equip.equipName] = {for (var month in months) month: false};
      }
    }
  }

  void onMonthTap(String equipName, String month) {
    setState(() {
      selectedCalendar[equipName]![month] = !selectedCalendar[equipName]![month]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Calendar(
      months: months,
      selectedCalendar: selectedCalendar,
      onMonthTap: onMonthTap,
    );
  }
}
