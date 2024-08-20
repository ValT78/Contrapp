import 'package:contrapp/button/super_title.dart';
import 'package:contrapp/button/travel_button.dart';
import 'package:contrapp/custom_navbar.dart';
import 'package:contrapp/object/equipment.dart';
import 'package:contrapp/object/operation.dart';
import 'package:contrapp/search/main_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:contrapp/main.dart';
import 'package:contrapp/skeleton/selected_operation.dart';

class OperationPage extends StatelessWidget {
  final Equipment equipment;
  
  const OperationPage({super.key, required this.equipment});

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
            SuperTitle(title: equipment.equipName, color: Colors.blue),
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
                  height: MediaQuery.of(context).size.height - 380,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: SelectedOperation(
                      operationsNotifier: equipPicked.getOperations(equipment.equipName), 
                      equipment: equipment
                    ),
                  ),
                ),
              ],
            ),
          ),
            MainSearchBar(
              label: 'Choisissez une Opération...',
              storeList: equipToPick.getOperations(equipment.equipName).value.map((e) => e.operationNameNotifier.value).toList(),
              addElement: (String operationName) {
                equipPicked.addOperationName(equipment.equipName, operationName);
              },
              createNewElement: (String operationName) {
                equipPicked.addOperation(equipment.equipName, Operation(operationName: operationName));
                equipToPick.addOperation(equipment.equipName, Operation(operationName: operationName));
              },
              deleteElement: (String operationName) {
                equipToPick.removeOperation(equipment.equipName, equipment.operationsNotifier.value.firstWhere((element) => element.operationNameNotifier.value == operationName));
                equipPicked.removeOperation(equipment.equipName, equipment.operationsNotifier.value.firstWhere((element) => element.operationNameNotifier.value == operationName));
              },
              ), 
          ],
         ),
         SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child:const TravelButton(
                  color: Colors.green, 
                  icon: Icons.check,
                  label: 'Valider', 
                  link: '/equip', 
                  height: 100, 
                  roundedBorder: 50, 
                  textSize: 30
                ),
          ),
              ],
            ),
          ),
        );  
  }
}
