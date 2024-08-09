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
                                        fontSize: 36, // Taille de la police en fonction de l'espace disponible
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
                      padding: EdgeInsets.fromLTRB(64, 4, 8, 0),
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
                              "Temps (minute)",
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
                  color: Colors.red[800]!,
                  width: 1,
                ),
                color: Colors.red[400],
              ),
              child:
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.black,
              onPressed: () {
                equipPicked.remove(equip);
              },
            ),
            ),
            Expanded(child: Container(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              margin: const EdgeInsets.fromLTRB(32,8,32,8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(87, 25, 197, 31),
                borderRadius: BorderRadius.circular(6),
                // border: Border.all(
                //   color: Colors.green[900]!,
                //   width: 2,
                // ),
              ),
                child:  TextFormField(
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green[900]!,
                      width: 3.0, // Augmentez cette valeur pour une barre plus haute

                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green,
                      width: 2.0,
                    ),
                  ),
                  // border: InputBorder.none,
                ),
                textAlign: TextAlign.center,
                cursorColor: Colors.green, // Set cursor color to green
                style: const TextStyle(
                  decorationColor: Colors.green, // Set underline color to green
                ),
                ),
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
            Expanded(child: Container(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              margin: const EdgeInsets.fromLTRB(32,8,32,8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(87, 25, 197, 31),
                borderRadius: BorderRadius.circular(6),
                // border: Border.all(
                //   color: Colors.green[900]!,
                //   width: 2,
                // ),
              ),
                child:  TextFormField(
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green[900]!,
                      width: 3.0, // Augmentez cette valeur pour une barre plus haute

                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green,
                      width: 2.0,
                    ),
                  ),
                  // border: InputBorder.none,
                ),
                textAlign: TextAlign.center,
                cursorColor: Colors.green, // Set cursor color to green
                style: const TextStyle(
                  decorationColor: Colors.green, // Set underline color to green
                ),
                ),
            ),
              ),
            Expanded(child: Container(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              margin: const EdgeInsets.fromLTRB(16,8,16,8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(87, 25, 197, 31),
                borderRadius: BorderRadius.circular(6),
                // border: Border.all(
                //   color: Colors.green[900]!,
                //   width: 2,
                // ),
              ),
                child:  TextFormField(
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green[900]!,
                      width: 3.0, // Augmentez cette valeur pour une barre plus haute

                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green,
                      width: 2.0,
                    ),
                  ),
                  prefixIcon: const Icon(
                    Icons.person, // Remplacez par l'icône de votre choix
                    color: Colors.green,
                  ),
                  // border: InputBorder.none,
                ),
                textAlign: TextAlign.center,
                cursorColor: Colors.green, // Set cursor color to green
                style: const TextStyle(
                  decorationColor: Colors.green, // Set underline color to green
                ),
                ),
            ),
              ),
            Expanded(
              child: Container(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              margin: const EdgeInsets.fromLTRB(16,8,16,8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(181, 25, 197, 31),
                borderRadius: BorderRadius.circular(80),
                border: Border.all(
                  color: Colors.green[900]!,
                  width: 2,
                ),
              ),
              child: Text(
                "Prix",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900]!,
                ),
              ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                margin: const EdgeInsets.fromLTRB(16,8,16,8),
                decoration: BoxDecoration(
                color: const Color.fromARGB(171, 255, 168, 55),
                borderRadius: BorderRadius.circular(80),
                border: Border.all(
                  color: Colors.orange[900]!,
                  width: 2,
                ),
                
              ),
                child: Text(
                  "Travail",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[900]!,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}),


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