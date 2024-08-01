import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:contrapp/object/equip_list.dart';


//Les équipements sélectionnés dans la page des équipements
class SelectedEquip extends StatelessWidget {
  const SelectedEquip({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EquipList>(
      builder: (context, equipList, child) {
        return ListView.builder(
          itemCount: equipList.equipList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(equipList.equipList[index].equipName),
            );
          },
        );
      },
    );
  }
}