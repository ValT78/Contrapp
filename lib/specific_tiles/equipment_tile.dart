import 'package:contrapp/object/equipment.dart';
import 'package:contrapp/pages/operation_page.dart';
import 'package:contrapp/main.dart';
import 'package:contrapp/specific_tiles/machine_tile.dart';
import 'package:flutter/material.dart';
import 'package:contrapp/object/machine.dart';

class EquipmentTile extends StatelessWidget {
  final Equipment equip;
  const EquipmentTile({super.key, required this.equip});
  
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OperationPage(
                    equipment: equip,
                  ),
                )
              );
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
                  
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(800),
                      color: Colors.green[800],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      color: Colors.white,
                      onPressed: () {
                        equipPicked.addMachine(equip, Machine());
                      },
                    ),
                  ),
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
                            equip.equipName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 36 * screenWidth / 1920, // Taille de la police en fonction de l'espace disponible
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
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OperationPage(
                          equipment: equip,
                        ),
                      )
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Couleur de fond
                      foregroundColor:const Color.fromARGB(255, 14, 56, 119),
                      textStyle: TextStyle(
                        fontSize: 36.0 * screenWidth / 1920, // Taille du texte
                        fontWeight: FontWeight.bold, // Poids du texte
                      ),
                      minimumSize: Size(screenWidth * 0.4, 70), // Taille minimale du bouton (largeur, hauteur)
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
            padding: EdgeInsets.fromLTRB(80, 4, 40, 0),
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
                  VerticalDivider(thickness: 2, color: Colors.black, indent: 2, endIndent: 2),
                  Expanded(
                    flex: 4
                    ,
                    child: Text(
                      "Désignation",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  VerticalDivider(thickness: 2, color: Colors.black, indent: 2, endIndent: 2),
                  Expanded(
                    child: Text(
                      "Visite / an",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  VerticalDivider(thickness: 2, color: Colors.black, indent: 2, endIndent: 2),
                  Expanded(
                    child: Text(
                      "Temps (minute)",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  VerticalDivider(thickness: 2, color: Colors.black, indent: 2, endIndent: 2),
                  Expanded(
                    child: Text(
                      "Prix",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  VerticalDivider(thickness: 2, color: Colors.black, indent: 2, endIndent: 2),
                  Expanded(
                    child: Text(
                      "Travail (heure)",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Lignes de sous-catégorie
          ...equip.machines.asMap().entries.map((entry) {
            return MachineTile(equip: equip, machine: entry.value, index: entry.key);
          }),
        ],
      ),
    );
  } 
}