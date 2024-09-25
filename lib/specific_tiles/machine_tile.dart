import 'package:contrapp/common_tiles/bouncy_action_button.dart';
import 'package:contrapp/common_tiles/super_title.dart';
import 'package:contrapp/common_tiles/variable_indicator.dart';
import 'package:contrapp/object/equipment.dart';
import 'package:contrapp/main.dart';
import 'package:contrapp/common_tiles/custom_form_field.dart';
import 'package:contrapp/skeleton/main_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:contrapp/object/machine.dart';
import 'package:flutter/services.dart';

class MachineTile extends StatelessWidget {
  final Equipment equip;
  final Machine machine;
  final int index;
  const MachineTile({super.key, required this.equip, required this.machine, required this.index});
  
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: index % 2 == 0 ? Colors.blue[200] : Colors.blue[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Material(
          color: Colors.transparent, // Important pour voir l'effet d'encre
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(800),
                  border: Border.all(
                    color: Colors.red[900]!,
                    width: 2,
                  ),
                  color: Colors.red[700],
                ),
                child:
              IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.black,
                onPressed: () {
                  equipPicked.removeMachine(equip, machine);
                  if(equip.machines.isEmpty) {
                    equipPicked.removeEquipment(equip);
                  }
                },
              ),
              ),
              const Spacer(
                flex: 1,
              ),
                CustomFormField(
                  color: Colors.lightBlue, 
                  icon: Icons.shopping_cart, 
                  textSize: 32, 
                  width: 100,
                  initValue: machine.number,
                  onChanged: (value) {
                    machine.number = value;
                    machine.hoursExpectedNotifier.value = double.parse((machine.minutesExpected * machine.number * machine.visitsPerYear / 60).toStringAsFixed(2));
                    machine.priceNotifier.value = (machine.hoursExpectedNotifier.value * tauxHoraire).ceil();
                    montantHT = 0;
                    hoursOfWorkNotifier.value = 0;
                    for (var equip in equipPicked.equipList) {
                      for (var machine in equip.machines) {
                        montantHT += machine.priceNotifier.value;
                        hoursOfWorkNotifier.value += machine.hoursExpectedNotifier.value;
                      }
                    }
                    hoursOfWorkNotifier.value = double.parse(hoursOfWorkNotifier.value.toStringAsFixed(2));
                  },
                ),
                
                  const Spacer(
                  flex: 1,
                  ), 
                  Flexible(fit: FlexFit.loose,
                  flex: 12,
                  child:
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      height: 50,
                      child: Stack(
                        children: [
                          Center(
                            child: ValueListenableBuilder(
                              valueListenable: machine.information,
                              builder: (context, information, child) {
                                return Text(
                                      information,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                            ),
                          ),
                          Positioned.fill(
                            child: InkWell(
                              onTap: () {
                                _showPopup(context, equip, machine, screenWidth);
                              },
                              splashColor: Colors.deepPurple.withOpacity(0.2),
                              hoverColor: Colors.deepPurple.withOpacity(0.1),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  suffixIcon: Icon(
                                    Icons.arrow_drop_down_circle,
                                    color: Colors.deepPurple[800],
                                    size: 32,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ),
                  const Spacer(
                  flex: 1,  
                  ),
                  CustomFormField(
                    color: Colors.lightBlue, 
                    icon: Icons.build, 
                    textSize: 32, 
                    width: 100,
                    initValue: machine.visitsPerYear,
                    onChanged: (value) {
                      machine.visitsPerYear = value;
                      machine.hoursExpectedNotifier.value = double.parse((machine.minutesExpected * machine.number * machine.visitsPerYear / 60).toStringAsFixed(2)); 
                      machine.priceNotifier.value = (machine.hoursExpectedNotifier.value * tauxHoraire).ceil();
                      montantHT = 0;
                      hoursOfWorkNotifier.value = 0;
                      for (var equip in equipPicked.equipList) {
                        for (var machine in equip.machines) {
                          montantHT += machine.priceNotifier.value;
                          hoursOfWorkNotifier.value += machine.hoursExpectedNotifier.value;
                        }
                      }
                      hoursOfWorkNotifier.value = double.parse(hoursOfWorkNotifier.value.toStringAsFixed(2));
                    },
                  ),
                
                const Spacer(flex: 1,  
                ),
                  CustomFormField(
                  color: Colors.orange, 
                  icon: Icons.timelapse, 
                  textSize: 32, 
                  // horizontalMargin: 32,
                  width: 150,
                  initValue: machine.minutesExpected,
                  onChanged: (value) {
                    machine.minutesExpected = value;
                    machine.hoursExpectedNotifier.value = double.parse((machine.minutesExpected * machine.number * machine.visitsPerYear / 60).toStringAsFixed(2));
                    machine.priceNotifier.value = (machine.hoursExpectedNotifier.value * tauxHoraire).ceil();
                    montantHT = 0;
                    hoursOfWorkNotifier.value = 0;
                    for (var equip in equipPicked.equipList) {
                      for (var machine in equip.machines) {
                        montantHT += machine.priceNotifier.value;
                        hoursOfWorkNotifier.value += machine.hoursExpectedNotifier.value;
                      }
                    }
                    hoursOfWorkNotifier.value = double.parse(hoursOfWorkNotifier.value.toStringAsFixed(2));
                  },
                  ),
                  
                  const Spacer(flex: 1,
                  ),
                VariableIndicator(
                  color: Colors.green, 
                  icon: Icons.euro, 
                  variableNotifier: machine.priceNotifier, 
                  textSize: 24, 
                  width: 120, 
                  height: 50,
                ),
                const Spacer(flex: 1,
                ),
              VariableIndicator(
                color: Colors.deepOrange, 
                icon: Icons.work, 
                variableNotifier: machine.hoursExpectedNotifier, 
                textSize: 24, 
                width: 120, 
                height: 50,
              ),
            const Spacer(flex: 1,
            ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPopup(BuildContext context, Equipment equip, Machine machine, double screenWidth) {
  FocusNode focusNode = FocusNode();
  TextEditingController informationController = TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context2) {
      return KeyboardListener(
        focusNode: focusNode,
        onKeyEvent: (KeyEvent event) {
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.escape) {
              Navigator.of(context2).pop();
            }
          }
        },
        child: Dialog(
          child: Container(
            width: screenWidth * 2 / 3,
            height: MediaQuery.of(context2).size.height * 2 / 3,
            padding: const EdgeInsets.all(16.0),
            child: Stack(
            children: [
              
              Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SuperTitle(
                  title: equip.equipName, 
                  color: Colors.purple,
                  fontSize: 45,
                ),
                const Spacer(flex: 1),
                
                CustomFormField(
                  color: Colors.deepPurple, 
                  icon: Icons.info, 
                  textSize: 50, 
                  width: screenWidth * 2 / 3 -100,
                  label: "Marque - Modèle - Emplacement - Informations",
                  onChanged: (value) {
                    machine.information.value = value;
                  }, 
                  initValue: machine.information.value,
                  controller: informationController,
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.fromLTRB(128.0, 0, 128, 16),
                  child: TravelButton(
                    color: Colors.deepPurple, 
                    icon: Icons.check, 
                    label: "Valider", 
                    roundedBorder: 16, 
                    height: 150 * screenWidth/1920,
                    width: screenWidth * 2 / 3 -32,
                    textSize: 50 * screenWidth/1920,
                    actionFunction: () {
                      Navigator.of(context2).pop();
                    },
                    scaleWidthFactor: 1,
                  )
                ),
              ],
            ),
            Column(
               children: [
                const SizedBox(height: 60),
                MainSearchBar(
                  label: "Ajouter une information...", 
                  storeList: equipInformations.toList(), 
                  yPosition: MediaQuery.of(context2).size.height * 2 / 3 -200,
                  addElement: (String information) {
                    if (machine.information.value != "") {
                      machine.information.value += " - $information";
                      informationController.text = machine.information.value;
                    } else {
                      machine.information.value = information;
                      informationController.text = information;
                    }
                  },
                  createNewElement: (String information) {
                    equipInformations.add(information);
                    if (machine.information.value != "") {
                      machine.information.value += " - $information";
                      informationController.text = machine.information.value;
                    } else {
                      machine.information.value = information;
                      informationController.text = information;
                    }
                    modifyApp();                    
                  },
                  deleteElement: (String information) {
                    equipInformations.remove(information);
                    modifyApp();
                  },
                ),
               ]
              ),
            ],
            ),
          ),
        ),
      );
    },
  );

  // Request focus to the RawKeyboardListener
  focusNode.requestFocus();
  }
}