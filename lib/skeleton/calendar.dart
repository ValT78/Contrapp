import 'package:flutter/material.dart';
import 'package:contrapp/main.dart';


class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  CalendarState createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  List<String> months = ['Jan', 'Fev', 'Mar', 'Avr', 'Mai', 'Jun', 'Jul', 'Aou', 'Sep', 'Oct', 'Nov', 'Dec'];
  Map<String, Map<String, bool>> selected = {};

  @override
  void initState() {
    super.initState();
    for (var equip in equipPicked.equipList) {
      selected[equip.equipName] = {for (var month in months) month: false};
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: DataTable(
        columns: [
          for (var month in months) DataColumn(label: Text(month)),
          const DataColumn(label: Text('Total')),
        ],
        rows: equipPicked.equipList.map((equip) {
          var total = selected[equip.equipName]?.values.where((e) => e).length;
          return DataRow(
            cells: [
              for (var month in months)
                DataCell(
                  InkWell(
                    onTap: () {
                      setState(() {
                        selected[equip.equipName]![month] = !selected[equip.equipName]![month]!;
                      });
                    },
                    child: selected[equip.equipName]![month]! ? const Text('X') : null,
                  ),
                ),
              DataCell(Text('$total')),
            ],
          );
        }).toList(),
      ),
    );
  }
}