import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:contrapp/search/equip_list.dart';

class SelectedEquip extends StatelessWidget {
  const SelectedEquip({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EquipList>(
      builder: (context, equipList, child) {
        return ListView.builder(
          itemCount: equipList.equipPickedList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(equipList.equipPickedList[index]),
            );
          },
        );
      },
    );
  }
}