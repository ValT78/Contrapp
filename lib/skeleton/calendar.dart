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
    for (var equip in equipPickedList) {
      selected[equip] = {for (var month in months) month: false};
    }
    print(equipPickedList);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: DataTable(
        columns: [
          for (var month in months) DataColumn(label: Text(month)),
          const DataColumn(label: Text('Total')),
        ],
        rows: equipPickedList.map((equip) {
          var total = selected[equip]?.values.where((e) => e).length;
          return DataRow(
            cells: [
              for (var month in months)
                DataCell(
                  InkWell(
                    onTap: () {
                      setState(() {
                        selected[equip]![month] = !selected[equip]![month]!;
                      });
                    },
                    child: selected[equip]![month]! ? const Text('X') : null,
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