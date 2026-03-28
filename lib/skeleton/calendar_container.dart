import 'package:flutter/material.dart';
import 'package:contrapp/main.dart';
import 'package:contrapp/object/contract_calendar.dart';
import 'calendar.dart';

class CalendarContainer extends StatefulWidget {
  const CalendarContainer({super.key});

  @override
  CalendarContainerState createState() => CalendarContainerState();
}

class CalendarContainerState extends State<CalendarContainer> {
  final List<String> months = List<String>.from(calendarMonths);
  final Set<String> expandedEquipments = <String>{};

  @override
  void initState() {
    super.initState();
    _syncCalendarData();
  }

  void _syncCalendarData() {
    syncSelectedCalendarWithEquipments(
      selectedCalendar,
      equipPicked.equipList,
      months,
    );
    expandedEquipments.removeWhere(
      (equipName) => !selectedCalendar.containsKey(equipName),
    );
  }

  void onEquipmentMonthTap(String equipName, String month) {
    setState(() {
      _syncCalendarData();
      final monthSelection = getEquipmentMonthSelection(
        selectedCalendar,
        equipName,
        months,
      );
      monthSelection[month] = !(monthSelection[month] ?? false);
    });
  }

  void onOperationMonthTap(String equipName, String operationName, String month) {
    setState(() {
      _syncCalendarData();
      final monthSelection = getOperationMonthSelection(
        selectedCalendar,
        equipName,
        operationName,
        months,
      );
      monthSelection[month] = !(monthSelection[month] ?? false);
    });
  }

  void onToggleExpanded(String equipName) {
    setState(() {
      if (expandedEquipments.contains(equipName)) {
        expandedEquipments.remove(equipName);
      } else {
        expandedEquipments.add(equipName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _syncCalendarData();

    return Calendar( // On passe des fonctions en argument pour que le widget enfant puisse modifier l'état du parent
      equipments: equipPicked.equipList,
      months: months,
      selectedCalendar: selectedCalendar,
      expandedEquipments: expandedEquipments,
      onEquipmentMonthTap: onEquipmentMonthTap,
      onOperationMonthTap: onOperationMonthTap,
      onToggleExpanded: onToggleExpanded,
    );
  }
}
