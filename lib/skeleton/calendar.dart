import 'package:flutter/material.dart';

class Calendar extends StatelessWidget {
  final List<String> months;
  final Map<String, Map<String, bool>> selectedCalendar;
  final Function(String, String) onMonthTap;

  const Calendar({
    super.key,
    required this.months,
    required this.selectedCalendar,
    required this.onMonthTap,
  });


@override
Widget build(BuildContext context) {
  final equipNames = selectedCalendar.keys.toList();

  return GridView.builder(
    itemCount: (selectedCalendar.length + 1) * (months.length + 2), // +1 pour la ligne des labels, +2 pour les colonnes d'équipement et 'Total'
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: months.length + 2, // +2 pour les colonnes d'équipement et 'Total'
      childAspectRatio: 1, // Vous pouvez ajuster cet aspect ratio en fonction de vos besoins
    ),
    itemBuilder: (context, index) {
      final row = index ~/ (months.length + 2);
      final column = index % (months.length + 2);

      if (row == 0) {
        // C'est la ligne des labels
        if (column == 0 || column == months.length + 1) {
          return GridTile(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue[900],
                borderRadius: BorderRadius.only(
                  topLeft: column == 0 ? const Radius.circular(5) : Radius.zero,
                  topRight: column == months.length + 1 ? const Radius.circular(5) : Radius.zero,
                ),
              ),
              child: Center(
                child: Text(
                  column == 0 ? 'Equipement' : 'Total',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
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
                    color: Colors.blue[900], // Application de la couleur de fond à la case
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      months[column - 1],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      } else {
        // C'est une des lignes d'équipement
        final equipName = equipNames[row - 1]; // -1 pour compenser la ligne des labels

        if (column == 0) {
          // C'est la colonne d'équipement
          return GridTile(
            child: Container(
              color: Colors.blue[100],
              child: Center(
                child: Text(
                  equipName,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        } else if (column == months.length + 1) {
          // C'est la colonne 'Total'
          var total = selectedCalendar[equipName]?.values.where((e) => e).length;
          return GridTile(
            child: Container(
              color: Colors.blue[100],
              child: Center(
                child: Text(
                  '$total',
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        } else {
          // C'est une des colonnes de mois
          final month = months[column - 1];
          return GridTile(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onMonthTap(equipName, month),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selectedCalendar[equipName]![month]! ? Colors.blue[800] : Colors.transparent,
                  ),
                  child: Center(
                    child: selectedCalendar[equipName]![month]!
                        ? const Text(
                            'X',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
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
