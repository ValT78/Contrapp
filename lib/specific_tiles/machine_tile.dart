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
  const MachineTile(
      {super.key,
      required this.equip,
      required this.machine,
      required this.index});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool canMoveUp = index > 0;
    final bool canMoveDown = index < equip.machines.length - 1;

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
              _buildReorderControls(
                canMoveUp: canMoveUp,
                canMoveDown: canMoveDown,
                moveUp: () => equipPicked.moveMachineUp(equip, machine),
                moveDown: () => equipPicked.moveMachineDown(equip, machine),
              ),
              CustomFormField(
                color: Colors.lightBlue,
                icon: Icons.shopping_cart,
                textSize: 32,
                width: 100,
                initValue: machine.number,
                onChanged: (value) {
                  updateMachineAndContractTotals(
                    machine,
                    number: value,
                  );
                },
              ),
              const Spacer(
                flex: 1,
              ),
              Flexible(
                  fit: FlexFit.loose,
                  flex: 12,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withValues(alpha: 0.3),
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
                              _showInformationMachinePopUp(context, equip, machine, screenWidth);
                            },
                            splashColor:
                                Colors.deepPurple.withValues(alpha: 0.2),
                            hoverColor:
                                Colors.deepPurple.withValues(alpha: 0.1),
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
                  )),
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
                  updateMachineAndContractTotals(
                    machine,
                    visitsPerYear: value,
                  );
                },
              ),
              const Spacer(
                flex: 1,
              ),
              CustomFormField(
                color: Colors.orange,
                icon: Icons.timelapse,
                textSize: 32,
                // horizontalMargin: 32,
                width: 150,
                initValue: machine.minutesExpected,
                onChanged: (value) {
                  updateMachineAndContractTotals(
                    machine,
                    minutesExpected: value,
                  );
                },
              ),
              const Spacer(
                flex: 1,
              ),
              VariableIndicator(
                color: Colors.green,
                icon: Icons.euro,
                variableNotifier: machine.priceNotifier,
                textSize: 24,
                width: 120,
                height: 50,
              ),
              const Spacer(
                flex: 1,
              ),
              VariableIndicator(
                color: Colors.deepOrange,
                icon: Icons.work,
                variableNotifier: machine.hoursExpectedNotifier,
                textSize: 24,
                width: 120,
                height: 50,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(800),
                  border: Border.all(
                    color: Colors.red[800]!,
                    width: 2,
                  ),
                  color: Color.fromARGB(255, 255, 36, 0),
                ),
                child: IconButton(
                  tooltip: 'Supprimer cette machine',
                  icon: const Icon(Icons.delete),
                  color: Colors.red[50],
                  onPressed: () {
                    equipPicked.removeMachine(equip, machine);
                    if (equip.machines.isEmpty) {
                      equipPicked.removeEquipment(equip);
                    }
                    recomputeContractTotalsFromMachines();
                  },
                ),
              ),
            ],
          ),
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
          color: canMoveUp ? Colors.black : Colors.black26,
          onPressed: canMoveUp ? moveUp : null,
          constraints: BoxConstraints(maxHeight: 30, maxWidth: 50),
        ),
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          color: canMoveDown ? Colors.black : Colors.black26,
          onPressed: canMoveDown ? moveDown : null,
          constraints: BoxConstraints(maxHeight: 30, maxWidth: 50),
        ),
      ],
    );
  }

  void _showInformationMachinePopUp(BuildContext context, Equipment equip, Machine machine,
      double screenWidth) {
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
                        width: screenWidth * 2 / 3 - 100,
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
                            height: 150 * screenWidth / 1920,
                            width: screenWidth * 2 / 3 - 32,
                            textSize: 50 * screenWidth / 1920,
                            actionFunction: () {
                              Navigator.of(context2).pop();
                            },
                            scaleWidthFactor: 1,
                          )),
                    ],
                  ),
                  Column(children: [
                    const SizedBox(height: 60),
                    MainSearchBar(
                      label: "Ajouter une information...",
                      storeList: equipInformations.toList(),
                      yPosition:
                          MediaQuery.of(context2).size.height * 2 / 3 - 200,
                      addElement: (String information) {
                        if (machine.information.value != "") {
                          machine.information.value += " - $information";
                          informationController.text =
                              machine.information.value;
                        } else {
                          machine.information.value = information;
                          informationController.text = information;
                        }
                      },
                      createNewElement: (String information) {
                        equipInformations.add(information);
                        if (machine.information.value != "") {
                          machine.information.value += " - $information";
                          informationController.text =
                              machine.information.value;
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
                  ]),
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
