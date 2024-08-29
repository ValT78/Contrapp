import 'dart:math';

import 'package:contrapp/common_tiles/super_title.dart';
import 'package:contrapp/custom_navbar.dart';
import 'package:contrapp/object/equipment.dart';
import 'package:flutter/material.dart';
import 'package:contrapp/common_tiles/bouncy_action_button.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:contrapp/main.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
Widget build(BuildContext context) {
  double widthFactor = MediaQuery.of(context).size.width / 1920;
  return Scaffold(
    appBar: PreferredSize(
      preferredSize: Size.fromHeight(max(100 * widthFactor, 100)),
      child: CustomNavbar(height: max(100 * widthFactor, 100)),
    ),
    body: Center(
      child: SizedBox(
        width: max(1000 * MediaQuery.of(context).size.width / 1920, 1000),
        height: MediaQuery.of(context).size.height - 100,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              
              SizedBox(
                height: 150,
                child: TravelButton(
                  color: Colors.red,
                  icon: Icons.exit_to_app,
                  label: "Quitter l'application",
                  height: 100,
                  width: 1000,
                  roundedBorder: 30,
                  textSize: 50,
                  actionFunction: () => buttonQuitApp(context),
                  scaleWidthFactor: 2,
                ),
              ),
              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TravelButton(
                    color: Colors.amber,
                    icon: Icons.file_upload,
                    label: 'Charger un contrat existant',
                    actionFunction: () => loadContractData(null, null),
                    link: '/common',
                    height: 400,
                    width: 500,
                    roundedBorder: 30,
                    textSize: 50,
                    scaleWidthFactor: 2,
                  ),
                  const TravelButton(
                    color: Colors.green,
                    icon: Icons.create,
                    label: 'Créer un nouveau contrat',
                    link: '/common',
                    height: 400,
                    width: 500,
                    roundedBorder: 30,
                    textSize: 50,
                    scaleWidthFactor: 2,
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              const SuperTitle(title: "Ouverts Récemment", color: Colors.grey),
              const Divider(),
                ...oldContractPaths.keys.toList().reversed.map((key) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () async {
                      bool asLoaded = await loadContractData(oldContractPaths[key]?['path'], context);
                      if(asLoaded) Navigator.pushNamed(context, '/common');
                      },
                      child: ListTile(
                      leading: const Icon(Icons.insert_drive_file, size: 30,), // Ajout de l'icône de fichier
                      title: Row (
                        children: [
                        Text(key, style: const TextStyle(fontSize: 20)), // Ajout du nom du f ichier
                        const Spacer(),
                        Text(oldContractPaths[key]?['date'] != null ? DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(oldContractPaths[key]!['date']!)) : '', style: const TextStyle(fontSize: 15)), // Ajout de la date de dernière modification
                        ],
                      ),
                      ),
                    ),
                    const Divider(), // Ajout du trait entre les tiles
                  ],
                );
              }
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  // Fonction pour charger les données
Future<bool> loadContractData(String? contractPath, BuildContext? context) async {
  
  FilePickerResult? contract;
  String? jsonData;
  if (contractPath == null) {
    contract = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['cntrt'],
    );
    if (contract != null && contract.files.single.path != null) {
      contractPath = contract.files.single.path!;
      File file = File(contract.files.single.path!);
       jsonData = await file.readAsString();
    }
  }
  else {
    try {
      File file = File(contractPath);
      
      jsonData = await file.readAsString();
      // Traitez les données du fichier ici
    } catch (e) {
      ScaffoldMessenger.of(context!).showSnackBar(
        const SnackBar(
          content: Text('Aucun fichier trouvé'),
        ),
      );
      return false;
    }
  }

  if (jsonData != null) {

    Map<String, dynamic> data = jsonDecode(jsonData);
    resetAppData();

    variablesContrat = data;

    attachList = List<String>.from(data['attachList']);
    equipPicked.equipList = (List<Equipment>.from(data['equipPicked'].map((e) => Equipment.fromJson(e))));
    selectedCalendar = Map<String, Map<String, bool>>.from(data['selectedCalendar'].map((key, value) => MapEntry(key, Map<String, bool>.from(value))));
    variablesContrat['versionContrat']++;
    montantHT = variablesContrat['montantAstreinte'];
    hoursOfWorkNotifier.value = 0.0;
    for (var equip in equipPicked.equipList) {
      for (var machine in equip.machines) {
        machine.hoursExpectedNotifier.value = machine.minutesExpected * machine.number * machine.visitsPerYear/60;
        machine.priceNotifier.value = (tauxHoraire * machine.hoursExpectedNotifier.value).ceil();
        montantHT += machine.priceNotifier.value;
        hoursOfWorkNotifier.value += machine.hoursExpectedNotifier.value;
      }
    }
    if(contractPath != null) {
      addContractToHistoric(generateNomFichier(), contractPath);
      await modifyApp();
    }
    return true;
  }
  else {
    return false;
  }
}

void buttonQuitApp(BuildContext context) async {
  bool shouldClose = await showExitDialog(context);
    if(shouldClose) {
      exit(0);
    }
}

}