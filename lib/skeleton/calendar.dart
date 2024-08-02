import 'package:flutter/material.dart';
import 'package:contrapp/main.dart';


class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  CalendarState createState() => CalendarState();
}


class CalendarState extends State<Calendar> {
  List<String> months = ['Jan', 'Fev', 'Mar', 'Avr', 'Mai', 'Jun', 'Jul', 'Aou', 'Sep', 'Oct', 'Nov', 'Dec'];

  @override
  void initState() {
    super.initState();
    for (var equip in equipPicked.equipList) {
      if (selectedCalendar[equip.equipName] == null) {
      selectedCalendar[equip.equipName] = {for (var month in months) month: false};
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: (equipPicked.equipList.length + 1) * (months.length + 2), // +1 pour la ligne des labels, +2 pour les colonnes d'équipement et 'Total'
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: months.length + 2, // +2 pour les colonnes d'équipement et 'Total'
        childAspectRatio: 1, // Vous pouvez ajuster cet aspect ratio en fonction de vos besoins
      ),
      itemBuilder: (context, index) {
        final row = index ~/ (months.length + 2);
        final column = index % (months.length + 2);

        if (row == 0) {
          // C'est la ligne des labels
          if (column == 0) {
            return const GridTile(child: Center(child: Text('Equipement')));
          } else if (column == months.length + 1) {
            return const GridTile(child: Center(child: Text('Total')));
          } else {
            // Ajout d'une teinte de bleu aux labels des mois
            return GridTile(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  highlightColor: Colors.transparent, // Suppression de la couleur de sélection
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 200 - column * 10, 200 - column * 10, 255), // Application de la couleur de fond à la case
                    ),
                    child: Center(
                      child: Text(months[column - 1]),
                    ),
                  ),
                ),
              ),
            );
          }
        } else {
          // C'est une des lignes d'équipement
          final equip = equipPicked.equipList[row - 1]; // -1 pour compenser la ligne des labels

          if (column == 0) {
            // C'est la colonne d'équipement
            return GridTile(child: Center(child: Text(equip.equipName)));
          } else if (column == months.length + 1) {
            // C'est la colonne 'Total'
            var total = selectedCalendar[equip.equipName]?.values.where((e) => e).length;
            return GridTile(child: Center(child: Text('$total')));
          } else {
            // C'est une des colonnes de mois
            final month = months[column - 1];
            return GridTile(
              child: Material( // Ajout du widget Material
                color: Colors.transparent, // Pour rendre le Material transparent
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedCalendar[equip.equipName]![month] = !selectedCalendar[equip.equipName]![month]!;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    // decoration: BoxDecoration(
                    //   color: selectedCalendar[equip.equipName]![month]! ? Colors.grey : Colors.grey[200],
                    // ),
                    child: selectedCalendar[equip.equipName]![month]! ? const Center(child: Text('X')) : null,
                  ),
                ),
              ),
            );
          }
        }
      },
    );
  }
}
