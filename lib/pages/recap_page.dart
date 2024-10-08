import 'dart:math';

import 'package:contrapp/common_tiles/custom_form_field.dart';
import 'package:contrapp/common_tiles/number_indicator.dart';
import 'package:contrapp/common_tiles/super_title.dart';
import 'package:contrapp/common_tiles/variable_indicator.dart';
import 'package:contrapp/main.dart';
import 'package:contrapp/specific_tiles/astreinte_button.dart';
import 'package:contrapp/specific_tiles/tva_button.dart';
import 'package:flutter/material.dart';
import 'package:contrapp/custom_navbar.dart';
import 'package:contrapp/common_tiles/bouncy_action_button.dart';
import 'package:contrapp/create_pdf.dart';

class RecapPage extends StatelessWidget {
  const RecapPage({super.key});

  int _getNumberOfMachines() {
    int count = 0;
    for (var equip in equipPicked.equipList) {
      count += equip.machines.length;
    }
    return count;
  }

  int _getNumberOfOperations() {
    int count = 0;
    for (var equip in equipPicked.equipList) {
      count += equip.operationsNotifier.value.length;
    }
    return count;
  }

  int _getNumberOfAttachments() {
    return attachList.length;
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: const PreferredSize(
      preferredSize: Size.fromHeight(100),
      child: CustomNavbar(height: 100),
    ),
    body: Center(
        child: SingleChildScrollView(
      child: SizedBox(
          width: max(1200 * MediaQuery.of(context).size.width / 1920, 1200),
          height: max(900 * MediaQuery.of(context).size.width / 1920, 900),
          child: Column(
            children: [
              const Spacer(),
              SuperTitle(
                title: variablesContrat['entreprise'],
                color: Colors.blue,
                fontSize: 70,
              ),
              const Spacer(),
              Row(
                children: [
                  NumberIndicator(
                    text: "Équipements",
                    number: _getNumberOfMachines(),
                    width: 300,
                    widthScaleFactor: 3,
                  ),
                  const Spacer(),
                  NumberIndicator(
                    text: "Opérations",
                    number: _getNumberOfOperations(),
                    width: 300,
                    widthScaleFactor: 3,
                  ),
                  const Spacer(),
                  NumberIndicator(
                    text: "Pièces-Jointes",
                    number: _getNumberOfAttachments(),
                    width: 300,
                    widthScaleFactor: 3,
                  ),
                ],
              ),
              const Spacer(),
              const SizedBox(height: 20),
              Row(
                children: [
                  const AstreinteButton(),
                  const Spacer(),
                  const TvaButton(),
                  const Spacer(),
                  CustomFormField(
                    color: Colors.green,
                    icon: Icons.access_time,
                    textSize: 60,
                    height: 100,
                    width: 300,
                    onChanged: (double value) {
                      tauxHoraire = value;
                      for (var equip in equipPicked.equipList) {
                        for (var machine in equip.machines) {
                          machine.priceNotifier.value =
                              (value * machine.hoursExpectedNotifier.value)
                                  .ceil();
                          machine.priceNotifier.value =
                              (value * machine.hoursExpectedNotifier.value)
                                  .ceil();
                        }
                      }
                      montantHT = variablesContrat['montantAstreinte'];
                      for (var equip in equipPicked.equipList) {
                        for (var machine in equip.machines) {
                          montantHT += machine.priceNotifier.value;
                        }
                      }
                    },
                    initValue: tauxHoraire,
                    label: "Taux Horaire",
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(40, 5, 45, 5),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Heure de Travail",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          VerticalDivider(
                            thickness: 2,
                            color: Colors.black,
                            indent: 2,
                            endIndent: 2,
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Matériel HT",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          VerticalDivider(
                            thickness: 2,
                            color: Colors.black,
                            indent: 2,
                            endIndent: 2,
                          ),
                          Expanded(
                            child: Text(
                              "Total HT",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          VerticalDivider(
                            thickness: 2,
                            color: Colors.black,
                            indent: 2,
                            endIndent: 2,
                          ),
                          Expanded(
                            child: Text(
                              "Prix TTC",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Spacer(),
                      VariableIndicator(
                        color: Colors.deepOrange,
                        icon: Icons.timelapse,
                        variableNotifier: hoursOfWorkNotifier,
                        textSize: 45,
                        height: 70,
                        width: 220,
                      ),
                      const Spacer(),
                      VariableIndicator(
                        color: Colors.green,
                        icon: Icons.euro,
                        variableNotifier: montantHTNotifier,
                        textSize: 45,
                        height: 70,
                        width: 220,
                      ),
                      const Spacer(),
                      VariableIndicator(
                        color: Colors.green,
                        icon: Icons.euro,
                        variableNotifier: totalHTNotifier,
                        textSize: 45,
                        height: 70,
                        width: 220,
                      ),
                      const Spacer(),
                      VariableIndicator(
                        color: Colors.green,
                        icon: Icons.euro,
                        variableNotifier: montantTTCNotifier,
                        textSize: 45,
                        height: 70,
                        width: 220,
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              const Spacer(),
              const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TravelButton(
                      color: Colors.deepPurple,
                      icon: Icons.navigate_before,
                      label: 'Précédent',
                      link: '/attach',
                      height: 100,
                      width: 500,
                      roundedBorder: 50,
                      textSize: 30,
                      scaleWidthFactor: 2,
                    ),
                    TravelButton(
                      color: Colors.green,
                      icon: Icons.picture_as_pdf,
                      label: 'Générer le PDF',
                      actionFunction: createPdfFromMarkdown,
                      height: 100,
                      width: 500,
                      roundedBorder: 50,
                      textSize: 30,
                      scaleWidthFactor: 2,
                      showSnackBar: true,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

}