
import 'package:contrapp/specific_tiles/equipment_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:contrapp/object/equip_list.dart';

//Les équipements sélectionnés dans la page des équipements
class SelectedEquip extends StatelessWidget {
  const SelectedEquip({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Consumer<EquipList>(
      builder: (context, equipPicked, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8.0),
            // border: Border.all(color: Colors.black), // Ajout de la bordure noire
          ),
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: equipPicked.equipList.map((equip) {
              return EquipmentTile(equip: equip);
            }).toList(),
          ),
        );
      },
    );
  }
}