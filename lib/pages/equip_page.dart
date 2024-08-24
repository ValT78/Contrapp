import 'package:contrapp/common_tiles/custom_form_field.dart';
import 'package:contrapp/common_tiles/bouncy_action_button.dart';
import 'package:contrapp/common_tiles/variable_indicator.dart';
import 'package:contrapp/main.dart';
import 'package:contrapp/object/equipment.dart';
import 'package:contrapp/object/machine.dart';
import 'package:flutter/material.dart';
import 'package:contrapp/custom_navbar.dart';
import 'package:contrapp/skeleton/main_search_bar.dart';
import 'package:contrapp/skeleton/selected_equip.dart';


class EquipPage extends StatelessWidget {
  const EquipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: CustomNavbar(height: 100,),
      ),
      body: Center(
        child: Column( 
          children: [
         Stack(
          children: [
            Center(child:
            Column(
              children: [
                const SizedBox(
                  height: 100,
                ),

                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height - 320,
                  child: const SelectedEquip(),
                ),
              ],
            ),
          ),
            MainSearchBar(
              label:'Ajouter un équipement...',
              storeList: equipToPick.equipList.map((e) => e.equipName).toList(),
              addElement: (String equipName) {
                if (equipPicked.equipList.any((element) => element.equipName == equipName)) {
                  Equipment existingEquip = equipPicked.equipList.firstWhere((element) => element.equipName == equipName);
                  equipPicked.addMachine(existingEquip, Machine());
                } else {
                  Equipment newEquip = equipToPick.equipList.firstWhere((element) => element.equipName == equipName).clone();
                  equipPicked.addEquipment(newEquip);
                }
              },
              createNewElement: (String equipName) {
                equipToPick.addEquipment(Equipment.oneValue(equipName: equipName));
                equipPicked.addEquipment(Equipment.oneValue(equipName: equipName));
              },
              deleteElement: (String equipName) {
                equipToPick.removeEquipmentName(equipName);
                equipPicked.removeEquipmentName(equipName);
              },
            ), 
          ],
         ),
         SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Row(
              children: <Widget>[              
                const TravelButton(
                  color: Colors.deepPurple, 
                  icon: Icons.navigate_before, 
                  label: 'Précédent', 
                  link: '/common', 
                  height: 100, 
                  roundedBorder: 50, 
                  textSize: 30
                ),
                CustomFormField(
                  color: Colors.green, 
                  icon: Icons.access_time, 
                  textSize: 32, 
                  width: 150, 
                  onChanged: (double value) {
                    tauxHoraire = value;
                    montantHT = variablesContrat['montantAstreinte'];

                    for (var equip in equipPicked.equipList) {
                      for (var machine in equip.machines) {
                        machine.priceNotifier.value = (value * machine.hoursExpectedNotifier.value).ceil();
                        montantHT += machine.priceNotifier.value;
                      }
                    }
                  }, 
                  initValue: tauxHoraire, 
                  label: "Taux Horaire",
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: VariableIndicator(
                    color: Colors.green, 
                    icon: Icons.euro, 
                    variableNotifier: montantHTNotifier, 
                    textSize: 32, 
                    height: 50, 
                    width: 160,
                  ),
                ),
                VariableIndicator(
                  color: Colors.deepOrange, 
                  icon: Icons.timelapse, 
                  variableNotifier: hoursOfWorkNotifier, 
                  textSize: 32, 
                  height: 50, 
                  width: 170,
                ),
                const TravelButton(
                  color: Colors.green, 
                  icon: Icons.navigate_next, 
                  label: 'Suivant', 
                  link: '/calendar', 
                  height: 100, 
                  roundedBorder: 50, 
                  textSize: 30
                ),
              ],
            ),
          ),
          
        
        ],
        ),
      )
    );
  }

}