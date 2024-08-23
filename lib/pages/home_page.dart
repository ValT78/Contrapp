import 'package:contrapp/custom_navbar.dart';
import 'package:contrapp/object/equipment.dart';
import 'package:flutter/material.dart';
import 'package:contrapp/common_tiles/bouncy_action_button.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:contrapp/main.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: CustomNavbar(height: 100,),
      ),
      body: Center(
        child: SizedBox(
          width: 1000,
          child: Row(
            children: <Widget>[              
                TravelButton(color: Colors.amber, icon: Icons.file_upload, label: 'Charger un contrat existant', actionFunction: loadContractData, link: '/common', height: 500, roundedBorder: 30, textSize: 50),            
                const TravelButton(color: Colors.green, icon: Icons.create, label: 'Créer un nouveau contrat', link: '/common', height: 500, roundedBorder: 30, textSize: 50),
            ],
          ),
        ),
      )
    );
  }

  // Fonction pour charger les données
Future<void> loadContractData() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['cntrt'],
  );

  if (result != null) {
    File file = File(result.files.single.path!);
    String jsonData = await file.readAsString();

    Map<String, dynamic> data = jsonDecode(jsonData);

    variablesContrat = data;

    // Convertir explicitement les listes en List<String>
    attachList = List<String>.from(data['attachList']);
    equipPicked.equipList = (List<Equipment>.from(data['equipPicked'].map((e) => Equipment.fromJson(e))));
    selectedCalendar = Map<String, Map<String, bool>>.from(data['selectedCalendar'].map((key, value) => MapEntry(key, Map<String, bool>.from(value))));
    variablesContrat['versionContrat']++;
  }
}

}