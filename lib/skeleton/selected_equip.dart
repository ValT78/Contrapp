import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:contrapp/object/equip_list.dart';
import 'package:contrapp/object/equipment.dart';

//Les équipements sélectionnés dans la page des équipements
class SelectedEquip extends StatelessWidget {
  const SelectedEquip({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EquipList>(
      builder: (context, equipPicked, child) {

        // Grouper les équipements par nom
        Map<String, List<Equipment>> groupedEquipments = {};
        for (var equip in equipPicked.equipList) {
          if (!groupedEquipments.containsKey(equip.equipName)) {
            groupedEquipments[equip.equipName] = [];
          }
          groupedEquipments[equip.equipName]!.add(equip);
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8.0),
            // border: Border.all(color: Colors.black), // Ajout de la bordure noire
          ),
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: groupedEquipments.entries.map((entry) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4.0), // Marge légère
                decoration: BoxDecoration(
                  color: Colors.blue[100], // Couleur de fond green[100]
                  // border: Border.all(color: Colors.black), // Bordure noire
                  borderRadius: BorderRadius.circular(8.0), // Coins arrondis
                ),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ligne de catégorie
                    GestureDetector(
                      onTap: () {
                        // Action à réaliser lors du clic
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 12, 57, 126), // Couleur de fond green[100]
                          // border: Border.all(color: Colors.black), // Bordure noire
                          borderRadius: BorderRadius.circular(8.0), // Coins arrondis
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.build, // Icône symbolisant un équipement
                                      size: 36.0, // Taille de l'icône
                                      color: Colors.white, // Couleur de l'icône
                                    ),
                                    const SizedBox(width: 8.0), // Espacement entre l'icône et le texte
                                    Text(
                                      entry.key,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 36.0, // Taille de la police
                                        fontWeight: FontWeight.bold, // Poids de la police
                                        color: Colors.white, // Couleur du texte
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Action pour "Ajouter des Opérations"
                              },
                              style: ElevatedButton.styleFrom(
                                
                                backgroundColor: Colors.white, // Couleur de fond
                                foregroundColor:const Color.fromARGB(255, 14, 56, 119),
                                textStyle: const TextStyle(
                                  fontSize: 36.0, // Taille du texte
                                  fontWeight: FontWeight.bold, // Poids du texte
                                ),
                                minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 70), // Taille minimale du bouton (largeur, hauteur)
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0), // Coins arrondis
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.add_circle, // Icône correspondante
                                    size: 36.0, // Taille de l'icône
                                    color: Color.fromARGB(255, 14, 56, 119), // Couleur de l'icône
                                  ),
                                  SizedBox(width: 8.0), // Espacement entre l'icône et le texte
                                  Text("Ajouter des Opérations"),
                                ],
                              ),
                            ),
                          ],
                        ),

                      ),
                    ),
                    const Padding(
                      padding: const EdgeInsets.fromLTRB(64, 4, 8, 0),
                      child: IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Quantité",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          VerticalDivider(thickness: 1, color: Colors.black, indent: 2, endIndent: 2),
                          Expanded(
                            flex: 3,
                            child: Text(
                              "Désignation",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          VerticalDivider(thickness: 1, color: Colors.black, indent: 2, endIndent: 2),
                          Expanded(
                            child: Text(
                              "Visite / an",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          VerticalDivider(thickness: 1, color: Colors.black, indent: 2, endIndent: 2),
                          Expanded(
                            child: Text(
                              "Temps",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          VerticalDivider(thickness: 1, color: Colors.black, indent: 2, endIndent: 2),
                          Expanded(
                            child: Text(
                              "Prix",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          VerticalDivider(thickness: 1, color: Colors.black, indent: 2, endIndent: 2),
                          Expanded(
                            child: Text(
                              "Travail",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      ),
                    ),



                    // Lignes de sous-catégorie
...entry.value.asMap().entries.map((entry) {
  int index = entry.key;
  var equip = entry.value;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
    child: Container(
      decoration: BoxDecoration(
        color: index % 2 == 0 ? Colors.blue[200] : Colors.blue[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent, // Important pour voir l'effet d'encre
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(800),
                border: Border.all(
                  color: Colors.green[800]!,
                  width: 1,
                ),
                color: Colors.green[400],
              ),
              child:
            IconButton(
              icon: const Icon(Icons.add),
              color: Colors.black,
              onPressed: () {
                // Action pour le bouton +
              },
            ),
            ),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 3,
              child: InkWell(
                onTap: () {
                  // Action pour le bouton Désignation
                },
                child: const InputDecorator(
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.arrow_drop_down),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                child: const Text("Prix"),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                child: const Text("Travail"),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}).toList(),


                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
}
}