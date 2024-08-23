// main.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:contrapp/object/equipment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'pages/home_page.dart';
import 'pages/common_page.dart';
import 'pages/equip_page.dart';
import 'pages/calendar_page.dart';
import 'pages/attach_page.dart';
import 'pages/recap_page.dart';
import 'object/equip_list.dart';
import 'package:provider/provider.dart';


final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  final ValueNotifier<double> tauxHoraireNotifier = ValueNotifier<double>(80);

  final ValueNotifier<double> hoursOfWorkNotifier = ValueNotifier<double>(0);


  // Montant HT (et TTC) du contrat
  final ValueNotifier<int> montantHTNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> montantTTCNotifier = ValueNotifier<int>(0);

  double get montantHT {
    return variablesContrat['montantHT'];
  }
  
  set montantHT(double value) {
    variablesContrat['montantHT'] = value;
    montantHTNotifier.value = value.toInt();
    variablesContrat['montantTTC'] = value * 1.2;
    montantTTCNotifier.value = (value * 1.2).toInt();
  }
  
  EquipList equipToPick = EquipList(isModifyingApp: true); // Votre liste d'équipements
  EquipList equipPicked = EquipList(); // Votre liste d'équipements sélectionnés

  Map<String, Map<String, bool>> get selectedCalendar => variablesContrat['selectedCalendar'] as Map<String, Map<String, bool>>;

  set selectedCalendar(Map<String, Map<String, bool>> calendar) {
    variablesContrat['selectedCalendar'] = calendar;
  }


  // Liste des photos à attacher
  List<String> get attachList => variablesContrat['attachList'] as List<String>;

  set attachList(List<String> list) {
    variablesContrat['attachList'] = list;
  }


  Map<String, dynamic> variablesContrat = {
    'entreprise': '',
    'adresse1': '',
    'adresse2': '',
    'matricule': '',
    'capital': '',
    'date': DateFormat('dd/MM/yyyy').format(DateTime.now()),
    'versionContrat': 1,
    'attachList': <String>[],
    'equipPicked': <Equipment>[],
    'montantHT': 0.0,
    'montantTTC': 0.0,
    'hasAstreinte': false,
    'montantAstreinte': 0.0,
    'selectedCalendar': <String, Map<String, bool>>{},
  };

  


// Charger les données de l'application
Future<void> _loadAppData() async {

  Directory projectDir = Directory.current;
    List<FileSystemEntity> files = projectDir.listSync(recursive: false);
    File? targetFile;

    for (var file in files) {
      if (file is File && file.path.endsWith('.contrapp')) {
      targetFile = file;
      break;
      }
    }

    if(targetFile != null) {
      String jsonData = await targetFile.readAsString();
      try {
        Map<String, dynamic> data = jsonDecode(jsonData);
        equipToPick.equipList.addAll(List<Equipment>.from(data['equipToPick'].map((e) => Equipment.fromJson(e))));

      } catch (e) {
        // Handle decoding error
        print('Error decoding JSON data: $e');
      }

    }
  }

  String generateNumeroContrat() {
  final elements = variablesContrat['date'].split('/');
  String version = variablesContrat['versionContrat'].toString().padLeft(3, '0');
  
  return '${elements[2].padLeft(2)}${elements[1]}${elements[0]}$version';
}

  String generateNomFichier() {
    return '${variablesContrat['entreprise']}-${generateNumeroContrat()}';
  }


void main() {
  _loadAppData();
  runApp(ChangeNotifierProvider<EquipList>.value(
      value: equipPicked,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Gotham',
      ),
      navigatorObservers: [routeObserver],
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomePage(),
        '/common': (context) => const CommonPage(),
        '/equip': (context) => const EquipPage(),
        '/calendar': (context) => const CalendarPage(),
        '/attach': (context) => const AttachPage(),
        '/recap': (context) => const RecapPage(),
      },
      
    );
  }

  
}


