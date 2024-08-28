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

  return LayoutBuilder(
    builder: (context, constraints) {
      // Calculer la largeur d'une case du GridView
      final totalWidth = constraints.maxWidth;
      final gridItemWidth = (totalWidth) / (months.length + 2); // 200 est la largeur totale des colonnes Equipement et Total
      final equipColumnWidth = gridItemWidth * 5; // La colonne Equipement est 3 fois plus large
      final gridItemHeight = gridItemWidth / 1.5; 

      return SingleChildScrollView(
    child: Column(
        children: [
          Row(
            children: [
              // Colonne d'équipement
              SizedBox(
                width: equipColumnWidth,
                child: Column(
                  children: [
                    Container(
                      height: gridItemHeight,
                      decoration: BoxDecoration(
                        color: Colors.blue[900],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Equipement',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 60 * totalWidth / 1920,
                          ),
                        ),
                      ),
                    ),
                    ...equipNames.map((equipName) => Container(
                      height: gridItemHeight,
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        border: Border(
                          right: BorderSide(color: Colors.grey[300]!),
                          bottom: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          equipName,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 25 * totalWidth / 1920,
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              ),
              // GridView pour les mois
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: (selectedCalendar.length + 1) * months.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: months.length,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final row = index ~/ months.length;
                    final column = index % months.length;

                    if (row == 0) {
                      return GridTile(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue[900],
                            border: Border(
                              right: BorderSide(color: Colors.grey[300]!),
                              bottom: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              months[column],
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 30 * totalWidth / 1920,
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      final equipName = equipNames[row - 1];
                      final month = months[column];
                      return GridTile(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => onMonthTap(equipName, month),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(color: Colors.grey[300]!),
                                  bottom: BorderSide(color: Colors.grey[300]!),
                                ),
                              ),
                              child: Center(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                    child: Container(
                                    margin: const EdgeInsets.all(12), // Add 15margin to all sides
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: selectedCalendar[equipName]![month]! ? Colors.blue[800] : Colors.transparent,
                                    ),
                                    child: Center(
                                      child: selectedCalendar[equipName]![month]!
                                        ? const Text(
                                          '✓',
                                          style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                          ),
                                        )
                                        : null,
                                    ),
                                    ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              // Colonne Total
              SizedBox(
                width: gridItemWidth,
                child: Column(
                  children: [
                    Container(
                      height: gridItemHeight,
                      decoration: BoxDecoration(
                        color: Colors.blue[900],
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(5),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Total',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 40 * totalWidth / 1920,
                          ),
                        ),
                      ),
                    ),
                    ...equipNames.map((equipName) {
                      var total = selectedCalendar[equipName]?.values.where((e) => e).length;
                      return Container(
                        height: gridItemHeight,
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          border: Border(
                            right: BorderSide(color: Colors.grey[300]!),
                            bottom: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '$total',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 50 * totalWidth / 1920,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      );
    },
  );
}










}
