import 'package:contrapp/button/custom_form_field.dart';
import 'package:contrapp/button/variable_indicator.dart';
import 'package:contrapp/main.dart';
import 'package:flutter/material.dart';
import 'package:contrapp/custom_navbar.dart';
import 'package:contrapp/button/travel_button.dart';
import 'package:contrapp/create_pdf.dart';

class RecapPage extends StatefulWidget {
  const RecapPage({super.key});

  static RecapPageState? of(BuildContext context) => context.findAncestorStateOfType<RecapPageState>();

  @override
  RecapPageState createState() => RecapPageState();
}

class RecapPageState extends State<RecapPage> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: CustomNavbar(height: 100),
      ),      
      body:  Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  CustomFormField(
                  color: Colors.green, 
                  icon: Icons.access_time, 
                  textSize: 32, 
                  width: 150, 
                  onChanged: (double value) {
                    tauxHoraireNotifier.value = value;
                    for (var equip in equipPicked.equipList) {
                      for (var machine in equip.machines) {
                        machine.priceNotifier.value = (value * machine.hoursExpectedNotifier.value).toInt();
                        machine.priceNotifier.value = (value * machine.hoursExpectedNotifier.value).toInt();
                      }
                    }
                    montantHT = 0;
                    for (var equip in equipPicked.equipList) {
                      for (var machine in equip.machines) {
                        montantHT += machine.priceNotifier.value;
                      }
                    }
                  }, 
                  initValue: tauxHoraireNotifier.value, 
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
                    color: Colors.green, 
                    icon: Icons.euro, 
                    variableNotifier: montantTTCNotifier, 
                    textSize: 32, 
                    height: 50, 
                    width: 160,
                  ),
                VariableIndicator(
                  color: Colors.deepOrange, 
                  icon: Icons.timelapse, 
                  variableNotifier: hoursOfWorkNotifier, 
                  textSize: 32, 
                  height: 50, 
                  width: 170,
                ),
                ],
              ),
              const SizedBox(
                width: 1000,
                child: Row(
                  children: <Widget>[              
                    TravelButton(color: Colors.deepPurple, icon: Icons.navigate_before, label: 'Précédent', link: '/attach', height: 100, roundedBorder: 50, textSize: 30),            
                    TravelButton(color: Colors.green, icon: Icons.navigate_next, label: 'Genérer le PDF', actionFunction: createPdfFromMarkdown, height: 100, roundedBorder: 50, textSize: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}