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
            color: Colors.grey[200],
            border: Border.all(color: Colors.black), // Ajout de la bordure noire
          ),
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: groupedEquipments.entries.map((entry) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0), // Marge légère
                decoration: BoxDecoration(
                  color: Colors.blue[100], // Couleur de fond green[100]
                  border: Border.all(color: Colors.black), // Bordure noire
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
                          color: Colors.green[100], // Couleur de fond green[100]
                          border: Border.all(color: Colors.black), // Bordure noire
                          borderRadius: BorderRadius.circular(1600.0), // Coins arrondis
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
                                      size: 24.0, // Taille de l'icône
                                      color: Colors.black, // Couleur de l'icône
                                    ),
                                    const SizedBox(width: 8.0), // Espacement entre l'icône et le texte
                                    Text(
                                      entry.key,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 24.0, // Taille de la police
                                        fontWeight: FontWeight.bold, // Poids de la police
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
                                textStyle: const TextStyle(
                                  fontSize: 36.0, // Taille du texte
                                  fontWeight: FontWeight.bold, // Poids du texte
                                ),
                                minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 70), // Taille minimale du bouton (largeur, hauteur)
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.add_circle, // Icône correspondante
                                    size: 36.0, // Taille de l'icône
                                    color: Colors.white, // Couleur de l'icône
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
                    // Lignes de sous-catégorie
                    ...entry.value.map((equip) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    // Action pour le bouton +
                                  },
                                ),
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(labelText: "Nombre"),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(labelText: "Désignation"),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(labelText: "Visite / an"),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(labelText: "Temps (minutes)"),
                                  ),
                                ),
                              ],
                            ),
                            const Row(
                              children: [
                                Text("Prix"),
                                SizedBox(width: 16),
                                Text("Temps de Travail"),
                              ],
                            ),
                          ],
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