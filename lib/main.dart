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

  double tauxHoraire = 1; // Taux horaire de l'entreprise
  double daysOfWork = 0; // Jours de travail total

  // Montant HT (et TTC) du contrat
  double get montantHT {
    return variablesContrat['montantHT'];
  }
  
  set montantHT(double value) {
    variablesContrat['montantHT'] = value;
    variablesContrat['montantTTC'] = value * 1.2;
  }
  
  EquipList equipToPick = EquipList(isModifyingApp: true); // Votre liste d'équipements
  EquipList equipPicked = EquipList(); // Votre liste d'équipements sélectionnés

  Map<String, Map<String, bool>> selectedCalendar = {};


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
    'capital': 0,
    'date': DateFormat('dd/MM/yyyy').format(DateTime.now()),
    'versionContrat': 1,
    'numeroContrat': '000000001',
    'attachList': <String>[],
    'equipPicked': equipPicked.equipList,
    'montantHT': 0,
    'montantTTC': 0,
    'astreinte': 'Accès au service de dépannage 24h/24 et 7j/7',
    'prixAstreinte': 'Offerte',
    'selectedCalendar': selectedCalendar,
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


void main() {
  _loadAppData();
  runApp(ChangeNotifierProvider<EquipList>.value(
      value: equipPicked,
      child: const MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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


