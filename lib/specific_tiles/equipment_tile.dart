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
    double scaleWidth = MediaQuery.of(context).size.width / 1920;
    final int equipmentIndex = equipPicked.equipList.indexOf(equip);
    final bool canMoveUp = equipmentIndex > 0;
    final bool canMoveDown =
        equipmentIndex != -1 && equipmentIndex < equipPicked.equipList.length - 1;

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
          Container(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(
                  255, 12, 57, 126), // Couleur de fond green[100]
              // border: Border.all(color: Colors.black), // Bordure noire
              borderRadius: BorderRadius.circular(8.0), // Coins arrondis
            ),
            child: Row(
              children: [
                _buildReorderControls(
                  canMoveUp: canMoveUp,
                  canMoveDown: canMoveDown,
                  moveUp: () => equipPicked.moveEquipmentUp(equip),
                  moveDown: () => equipPicked.moveEquipmentDown(equip),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(800),
                    color: Colors.green[800],
                  ),
                  child: IconButton(
                    tooltip: 'Ajouter une machine',
                    icon: const Icon(Icons.add),
                    color: Colors.white,
                    onPressed: () {
                      equipPicked.addMachine(equip, Machine());
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _openOperationsPage(context),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.build, // Icône symbolisant un équipement
                            size: 36.0 * scaleWidth, // Taille de l'icône
                            color: Colors.white, // Couleur de l'icône
                          ),
                          const SizedBox(
                              width:
                                  8.0), // Espacement entre l'icône et le texte
                          Text(
                            equip.equipName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30 *
                                  scaleWidth, // Taille de la police en fonction de l'espace disponible
                              fontWeight: FontWeight.bold, // Poids de la police
                              color: Colors.white, // Couleur du texte
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(800),
                    border: Border.all(
                      color: Colors.red[900]!,
                      width: 2,
                    ),
                    color: Colors.red[700],
                  ),
                  child: IconButton(
                    tooltip: 'Supprimer cet équipement',
                    icon: const Icon(Icons.delete),
                    color: Colors.black,
                    onPressed: () {
                      equipPicked.removeEquipment(equip);
                      recomputeContractTotalsFromMachines();
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _openOperationsPage(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Couleur de fond
                    foregroundColor: const Color.fromARGB(255, 14, 56, 119),
                    textStyle: TextStyle(
                      fontSize: 36.0 * scaleWidth, // Taille du texte
                      fontWeight: FontWeight.bold, // Poids du texte
                    ),
                    minimumSize: Size(70 * scaleWidth,
                        70), // Taille minimale du bouton (largeur, hauteur)
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8.0), // Coins arrondis
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(
                            Icons.add_circle, // Icône correspondante
                            size: 36.0, // Taille de l'icône
                            color: Color.fromARGB(
                                255, 14, 56, 119), // Couleur de l'icône
                          ),
                          Positioned(
                            top: -4,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4.0),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: ValueListenableBuilder(
                                valueListenable: equip.operationsNotifier,
                                builder: (context, operations, child) {
                                  return Text(
                                    operations.length.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                          width: 8.0), // Espacement entre l'icône et le texte
                      const Text("Ajouter des Opérations"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(60, 4, 60, 0),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Quantité",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  VerticalDivider(
                      thickness: 2,
                      color: Colors.black,
                      indent: 2,
                      endIndent: 2),
                  Expanded(
                    flex: 4,
                    child: Text(
                      "Informations",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  VerticalDivider(
                      thickness: 2,
                      color: Colors.black,
                      indent: 2,
                      endIndent: 2),
                  Expanded(
                    child: Text(
                      "Visite / an",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  VerticalDivider(
                      thickness: 2,
                      color: Colors.black,
                      indent: 2,
                      endIndent: 2),
                  Expanded(
                    child: Text(
                      "Temps (minute)",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  VerticalDivider(
                      thickness: 2,
                      color: Colors.black,
                      indent: 2,
                      endIndent: 2),
                  Expanded(
                    child: Text(
                      "Prix",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  VerticalDivider(
                      thickness: 2,
                      color: Colors.black,
                      indent: 2,
                      endIndent: 2),
                  Expanded(
                    child: Text(
                      "Travail (heure)",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Lignes de sous-catégorie
          ...equip.machines.asMap().entries.map((entry) {
            return MachineTile(
                equip: equip, machine: entry.value, index: entry.key);
          }),
        ],
      ),
    );
  }

  void _openOperationsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OperationPage(
          equipment: equip,
        ),
      ),
    );
  }

  Widget _buildReorderControls({
    required bool canMoveUp,
    required bool canMoveDown,
    required VoidCallback moveUp,
    required VoidCallback moveDown,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_up),
          color: canMoveUp ? Colors.white : Colors.white38,
          onPressed: canMoveUp ? moveUp : null,
          constraints: BoxConstraints(maxHeight: 30, maxWidth: 50),
        ),
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          color: canMoveDown ? Colors.white : Colors.white38,
          onPressed: canMoveDown ? moveDown : null,
          constraints: BoxConstraints(maxHeight: 30, maxWidth: 50),
        ),
      ],
    );
  }
}
