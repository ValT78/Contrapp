
import 'package:contrapp/common_tiles/custom_form_field.dart';
import 'package:contrapp/common_tiles/super_title.dart';
import 'package:contrapp/common_tiles/bouncy_action_button.dart';
import 'package:contrapp/common_tiles/variable_indicator.dart';
import 'package:contrapp/object/equipment.dart';
import 'package:contrapp/pages/operation_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:contrapp/object/equip_list.dart';
import 'package:contrapp/object/machine.dart';
import 'package:contrapp/main.dart';
import 'package:flutter/services.dart';

//Les équipements sélectionnés dans la page des équipements
class SelectedEquip extends StatelessWidget {
  const SelectedEquip({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Consumer<EquipList>(
      builder: (context, equipPicked, child) {
        double screenWidth = MediaQuery.of(context).size.width;

        return Container(
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8.0),
            // border: Border.all(color: Colors.black), // Ajout de la bordure noire
          ),
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: equipPicked.equipList.map((equip) {
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OperationPage(
                              equipment: equip,
                            ),
                          )
                        );
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
                            
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(800),
                                color: Colors.green[800],
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.add),
                                color: Colors.white,
                                onPressed: () {
                                  equipPicked.addMachine(equip, Machine());
                                },
                              ),
                            ),
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
                                      equip.equipName,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 36 * screenWidth / 1920, // Taille de la police en fonction de l'espace disponible
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
                                Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OperationPage(
                                    equipment: equip,
                                  ),
                                )
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white, // Couleur de fond
                                foregroundColor:const Color.fromARGB(255, 14, 56, 119),
                                textStyle: TextStyle(
                                  fontSize: 36.0 * screenWidth / 1920, // Taille du texte
                                  fontWeight: FontWeight.bold, // Poids du texte
                                ),
                                minimumSize: Size(screenWidth * 0.4, 70), // Taille minimale du bouton (largeur, hauteur)
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
                      padding: EdgeInsets.fromLTRB(80, 4, 40, 0),
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
                            VerticalDivider(thickness: 2, color: Colors.black, indent: 2, endIndent: 2),
                            Expanded(
                              flex: 4
                              ,
                              child: Text(
                                "Désignation",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            VerticalDivider(thickness: 2, color: Colors.black, indent: 2, endIndent: 2),
                            Expanded(

                              child: Text(
                                "Visite / an",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            VerticalDivider(thickness: 2, color: Colors.black, indent: 2, endIndent: 2),
                            Expanded(
                              child: Text(
                                "Temps (minute)",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            VerticalDivider(thickness: 2, color: Colors.black, indent: 2, endIndent: 2),
                            Expanded(
                              child: Text(
                                "Prix",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            VerticalDivider(thickness: 2, color: Colors.black, indent: 2, endIndent: 2),
                            Expanded(
                              child: Text(
                                "Travail (heure)",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Lignes de sous-catégorie
                    ...equip.machines.asMap().entries.map((entry) {
                      int index = entry.key;
                      var machine = entry.value;
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
                                      machine.priceNotifier.value = (machine.hoursExpectedNotifier.value * tauxHoraireNotifier.value).ceil();
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
                                                valueListenable: machine.marque,
                                                builder: (context, marque, child) {
                                                  return ValueListenableBuilder(
                                                    valueListenable: machine.information,
                                                    builder: (context, information, child) {
                                                      return Text(
                                                        '$marque - $information',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      );
                                                    },
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
                                        machine.priceNotifier.value = (machine.hoursExpectedNotifier.value * tauxHoraireNotifier.value).ceil();
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
                                      machine.priceNotifier.value = (machine.hoursExpectedNotifier.value * tauxHoraireNotifier.value).ceil();
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

  void _showPopup(BuildContext context2, Equipment equip, Machine machine, double screenWidth) {
  FocusNode focusNode = FocusNode();

  showDialog(
    context: context2,
    builder: (BuildContext context) {
      return KeyboardListener(
        focusNode: focusNode,
        onKeyEvent: (KeyEvent event) {
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.escape || event.logicalKey == LogicalKeyboardKey.enter) {
              Navigator.of(context).pop();
            }
          }
        },
        child: Dialog(
          child: Container(
            width: screenWidth * 2 / 3,
            height: MediaQuery.of(context).size.height * 2 / 3,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SuperTitle(
                  title: equip.equipName, 
                  color: Colors.purple,
                  fontSize: 49,
                ),
                const Spacer(flex: 1),
                CustomFormField(
                  color: Colors.purple, 
                  icon: Icons.build, 
                  textSize: 50, 
                  width: screenWidth * 2 / 3 -200,
                  label: "Marque de l'équipement",
                  onChanged: (value) {
                    machine.marque.value = value;
                  }, 
                  initValue: machine.marque.value
                ),
                const Spacer(flex: 1),
                CustomFormField(
                  color: Colors.deepPurple, 
                  icon: Icons.info, 
                  textSize: 50, 
                  width: screenWidth * 2 / 3 -200,
                  label: "Informations",
                  onChanged: (value) {
                    machine.information.value = value;
                  }, 
                  initValue: machine.information.value
                ),
                const Spacer(flex: 1),
                Container(
                  margin: const EdgeInsets.fromLTRB(128.0, 0, 128, 16),
                  child: TravelButton(
                    color: Colors.deepPurple, 
                    icon: Icons.check, 
                    label: "Valider", 
                    roundedBorder: 16, 
                    height: 150 * screenWidth/1920,
                    textSize: 50 * screenWidth/1920,
                    actionFunction: () {
                      Navigator.of(context).pop();
                    },
                  )
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